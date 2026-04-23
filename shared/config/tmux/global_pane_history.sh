#!/usr/bin/env bash

# Configuration: Where registers are stored (e.g., a global tmux option)
# For simplicity, let's assume @tmux_registers_data stores "name:pane_id" lines.
# If your 'save' function puts them elsewhere, adjust this.
TMUX_REGISTERS_OPTION="@tmux_registers_data"


# Function to get the current list of registers
# Reads from the global tmux option.
get_registers() {
    tmux show-option -gqv "$TMUX_REGISTERS_OPTION" 2>/dev/null | tr ' ' '\n'
}


# Function to save a register (simplified for this example)
save_register() {
    local register_name="$1"
    # --- CRITICAL FIX: Get the actual pane ID from tmux ---
    local current_pane_id=$(tmux display-message -p '#{pane_id}')

    local existing_registers
    existing_registers=$(get_registers)

    local new_entry="${register_name}:${current_pane_id}" # Use the actual pane ID

    # Remove any existing entry for this name or pane_id, then add the new one
    local updated_registers=""
    while IFS= read -r line; do
        # Use the actual pane ID for comparison
        if [[ "$line" != "${register_name}:*" && "$line" != *":${current_pane_id}" ]]; then
            updated_registers+=" $line"
        fi
    done <<< "$existing_registers"

    updated_registers="${updated_registers} ${new_entry}"
    # Remove leading space and set the option
    tmux set-option -gq "$TMUX_REGISTERS_OPTION" "$(echo "$updated_registers" | xargs)"
    tmux display-message "Register '$register_name' saved for pane #{pane_id}." 
}

# Function to jump to a register
jump_to_register() {
    local register_name="$1"
    local register_info=""
    register_info=$(get_registers | grep "^${register_name}:" | head -n 1)

    if [[ -z "$register_info" ]]; then
        tmux display-message "Register '$register_name' not found."
        return 1
    fi

    local target_pane_id=$(echo "$register_info" | awk -F':' '{print $2}')

    if [[ -n "$target_pane_id" ]]; then
        tmux display-message "Jumping to register '$register_name' (pane $target_pane_id)."
        tmux switch-client -t "$target_pane_id"
    else
        tmux display-message "Error parsing register '$register_name'."
    fi
}

# --- New Function to list windows with associated registers ---
list_windows_with_registers() {
    local all_windows
    # Keep this format for tmux output. It has explicit prefixes.
    all_windows=$(tmux list-windows -F 'ID_#{window_id}:IDX_#{window_index}:NAME_#{window_name}:CUR_#{window_current_flag}:LAST_#{window_last_flag}')

    local all_registers
    all_registers=$(get_registers)

    local -a collected_lines=()

    # First, build a map of pane_id to its register names
    declare -A pane_id_to_registers
    while IFS= read -r reg_line; do
        if [[ -n "$reg_line" ]]; then
            local name=$(echo "$reg_line" | awk -F':' '{print $1}')
            local pid=$(echo "$reg_line" | awk -F':' '{print $2}')
            pid="${pid//[[:space:]]/}" # Clean pid from any whitespace
            pane_id_to_registers["$pid"]+="$name,"
        fi
    done <<< "$all_registers"

    # Then, iterate through windows and check their panes for registers
    while IFS= read -r window_line_raw; do

        if [[ -n "$window_line_raw" ]]; then
            # --- CRITICAL FIX: Pure Bash parsing ---
            # Split the line by colon into an array
            IFS=':' read -r -a fields <<< "$window_line_raw"

            # Extract values using Bash parameter expansion to remove prefixes
            local win_id="${fields[0]#ID_}"         # Remove "ID_" from first field
            local win_idx="${fields[1]#IDX_}"       # Remove "IDX_" from second field
            local win_name="${fields[2]#NAME_}"     # Remove "NAME_" from third field
            local is_current="${fields[3]#CUR_}"    # Remove "CUR_" from fourth field
            local is_last="${fields[4]#LAST_}"      # Remove "LAST_" from fifth field

            # Trim any remaining whitespace (safety measure)
            win_id="${win_id//[[:space:]]/}"
            win_idx="${win_idx//[[:space:]]/}"
            win_name="${win_name//[[:space:]]/}"
            is_current="${is_current//[[:space:]]/}"
            is_last="${is_last//[[:space:]]/}"


            # If win_id is empty, something is fundamentally wrong with tmux output or array indexing
            if [[ -z "$win_id" ]]; then
                tmux display-message "ERROR: win_id is empty after parsing. Skipping this window."
                continue
            fi

            local current_marker=""
            [[ "$is_current" == "1" ]] && current_marker=" (current)"
            [[ "$is_last" == "1" ]] && current_marker=" (last)"

            local register_names_for_window=""
            local panes_in_window
            panes_in_window=$(tmux list-panes -t "$win_id" -F '#{pane_id}')


            while IFS= read -r pane_id_in_win; do
                pane_id_in_win="${pane_id_in_win//[[:space:]]/}"
                local temp_reg_value="${pane_id_to_registers[$pane_id_in_win]}"

                if [[ -n "$temp_reg_value" ]]; then
                    local regs_for_pane="${temp_reg_value%,}"
                    if [[ -n "$register_names_for_window" ]]; then
                        register_names_for_window+=", "
                    fi
                    register_names_for_window+="[${regs_for_pane}]"
                fi
            done <<< "$panes_in_window"

            local register_display=""
            if [[ -n "$register_names_for_window" ]]; then
                register_display=" Registers: ${register_names_for_window}"
            fi

            local formatted_line="${win_idx}: ${win_name}${current_marker}${register_display}\t${win_id}"
            collected_lines+=("$formatted_line")
        fi
    done <<< "$all_windows"

    local joined_output=$(printf "%s\n" "${collected_lines[@]}")
    printf '%b' "$joined_output" | sort -n -t ':' -k 1,1
}


# --- Choose function (modified to use list_windows_with_registers) ---
# --- choose_window_with_registers Function (Updated for display-menu and cross-compatibility) ---
choose_window_with_registers() {
    local window_info
    # list_windows_with_registers provides output in "label\ttarget_id" format
    window_info=$(list_windows_with_registers)

    if [[ -z "$window_info" ]]; then
        tmux display-message "No windows or registers to display."
        return
    fi

    local -A assigned_keys # Associative array to track keys already used (requires Bash 4+ or zsh)
    local -a menu_args=()  # Array to build display-menu arguments
    local default_key_index=0 # Fallback for items without a unique register key

    # Parse each line from list_windows_with_registers output
    while IFS=$'\t' read -r display_string target_id; do
        if [[ -z "$display_string" || -z "$target_id" ]]; then
            continue # Skip malformed or empty lines
        fi

        local proposed_key=""
        local register_names_raw=""

        # --- Compatible extraction of register names from display_string ---
        # Step 1: Extract "Registers: [content]" part using standard grep -o
        local temp_match=$(echo "$display_string" | grep -o 'Registers: \[[^]]*\]')

        if [[ -n "$temp_match" ]]; then
            # Step 2: Extract just the content inside the brackets using sed -E
            register_names_raw=$(echo "$temp_match" | sed -E 's/Registers: \[([^]]+)\]/\1/')
        fi
        # --- End Compatible extraction ---

        local first_register=""

        if [[ -n "$register_names_raw" ]]; then
            # Split by comma and take the first register name (e.g., from "e,other")
            first_register=$(echo "$register_names_raw" | cut -d',' -f1)
            if [[ -n "$first_register" ]]; then
                # Use the first character of the first register name as the proposed key
                proposed_key="${first_register:0:1}"
                # Convert to lowercase for case-insensitive key assignment
                proposed_key=$(echo "$proposed_key" | tr '[:upper:]' '[:lower:]')
            fi
        fi

        local final_key=""

        if [[ -n "$proposed_key" && -z "${assigned_keys[$proposed_key]}" ]]; then
            # If a proposed key exists and hasn't been used yet, assign it
            final_key="$proposed_key"
            assigned_keys["$final_key"]=1 # Mark key as used
            ((default_key_index++))
        else
            # Fallback to a numeric key if no register or if the proposed key conflicts
            # Keep trying numbers until a free one is found
            while [[ -n "${assigned_keys[$default_key_index]}" ]]; do
                ((default_key_index++))
            done
            final_key="$default_key_index"
            assigned_keys["$final_key"]=1 # Mark key as used
        fi

        # Add the menu item (label, key, command) to the menu_args array
        menu_args+=("$display_string") # The text displayed in the menu
        menu_args+=("$final_key")     # The key to press for this item (letter or number)
        menu_args+=("switch-client -Z -t \"$target_id\"") # The tmux command to execute

    done <<< "$window_info"

    if [[ ${#menu_args[@]} -eq 0 ]]; then
        tmux display-message "No windows or registers to display."
        return
    fi

    # Display the menu centered on the screen
    # -x C and -y C center the menu horizontally and vertically
    # "${menu_args[@]}" expands the array into separate arguments for display-menu
    tmux display-menu -x C -y C "${menu_args[@]}"
}


__debug_print_chooser_input() {
    list_windows_with_registers
}


# --- New Function: clear_register ---
clear_register() {
    local register_name="$1"
    if [[ -z "$register_name" ]]; then
        tmux display-message "Usage: clear-register <register_name>"
        return 1
    fi

    local existing_registers
    existing_registers=$(get_registers) # Get current list of registers (e.g., "name1:paneid1 name2:paneid2")

    local updated_registers=""
    local found_and_cleared="false" # Flag to check if the register was found

    # Iterate through each existing register entry
    # Each 'line' will be in the format "name:pane_id"
    while IFS= read -r line; do
        if [[ -z "$line" ]]; then
            continue # Skip any empty lines if they somehow exist
        fi
        # Extract the name part (everything before the first ':')
        local current_entry_name="${line%%:*}"

        if [[ "$current_entry_name" = "$register_name" ]]; then
            # This is the register we want to clear, so we skip adding it to updated_registers
            found_and_cleared="true"
        else
            # Keep this register, add it back to the list
            updated_registers+=" $line"
        fi
    done <<< "$existing_registers" # Feed existing_registers into the while loop

    if [[ "$found_and_cleared" = "false" ]]; then
        tmux display-message "Register '$register_name' not found."
        return 0 # Exit successfully, as it's not an error if it wasn't there
    fi

    # Remove any leading/trailing spaces and set the global option
    # xargs is good for handling potential multiple spaces between entries too
    tmux set-option -gq "$TMUX_REGISTERS_OPTION" "$(echo "$updated_registers" | xargs)"

    tmux display-message "Register '$register_name' cleared."
}

# Main script logic
case "$1" in
    "save")
        # Example usage: global_pane_history.sh save my_register_name
        save_register "$2"
        ;;
    "clear")
        clear_register "$2"
        ;;
    "jump")
        # Example usage: global_pane_history.sh jump my_register_name
        jump_to_register "$2"
        ;;
    "chooser")
        # Your existing global pane/window chooser (if you still use it)
        # (Placeholder for existing 'chooser' logic, if any)
        # You'll likely replace the C-l binding with the new window-register chooser
        tmux display-message "Placeholder for old 'chooser' logic. Use 'window_chooser' instead."
        ;;
    "window_chooser") # New mode for choosing windows with register info
        choose_window_with_registers
        ;;
    "update")
        # This is for the pane-focus-in hook.
        # Your existing logic to update @global_pane_history.
        # Example:
        local current_pane_id="#{pane_id}"
        local global_history=$(tmux show-option -gqv "@global_pane_history" 2>/dev/null)
        global_history=$(echo "$global_history" | tr ' ' '\n' | grep -v "$current_pane_id" | tr '\n' ' ') # Remove old
        global_history="$global_history $current_pane_id" # Add new
        tmux set-option -gq "@global_pane_history" "$(echo "$global_history" | xargs)" # Clean spaces
        ;;
    debug_chooser_input)
        __debug_print_chooser_input
        ;;
    *)
        tmux display-message "Usage: $0 {save|jump|chooser|window_chooser|update}"
        ;;
esac
