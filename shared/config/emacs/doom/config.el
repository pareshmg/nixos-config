;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-molokai)
;; (setq doom-molokai-brighter-comments t)
(setq doom-molokai-brighter-modeline t)
;; (set-background-color "#1C1E1F")


;;; make vertico file names stand out when doing a project search
(custom-set-faces!
  '(vertico-group-title :inherit org-clock-overlay))


;; doom-acario-dark
;; doom-monokai-classic
;; doom-dracula

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/.org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Items from personal.el which I will eventually move back there
(global-set-key (kbd "C-M-j") 'consult-imenu)
;;(global-set-key (kbd "C-M-J") 'consult-imenu-multi)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; windmove
(global-set-key (kbd "M-<left>") 'windmove-left)
(global-set-key (kbd "M-<right>") 'windmove-right)
(global-set-key (kbd "M-<up>") 'windmove-up)
(global-set-key (kbd "M-<down>") 'windmove-down)

;; to work with tmux
(global-set-key (kbd "ESC <left>") 'windmove-left)
(global-set-key (kbd "ESC <right>") 'windmove-right)
(global-set-key (kbd "ESC <up>") 'windmove-up)
(global-set-key (kbd "ESC <down>") 'windmove-down)

;; remove C-z to minimize cause it is annoying
(global-set-key (kbd "C-Z") nil)
(global-set-key (kbd "C-M-z") 'suspend-frame)

;; align according to regexp
(global-set-key (kbd "C-x a r") 'align-regexp)
(global-set-key (kbd "C-x O") 'previous-multiframe-window)


;; Yasnippets
(global-set-key (kbd "C-M-y") 'yas/expand)
(setq yas-snippet-dirs (append yas-snippet-dirs
                               '("~/.config/doom/snippets")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; jump to any spot using avy, but allow yourself to press enter

;; (require 'avy)
;; ;;;###autoload
;; (defun avy-goto-string-par (str &optional arg beg end)
;;   "Jump to the currently visible CHAR1 followed by CHAR2.
;; The window scope is determined by `avy-all-windows'.
;; When ARG is non-nil, do the opposite of `avy-all-windows'.
;; BEG and END narrow the scope where candidates are searched."
;;   (interactive (list (read-string "string: " nil nil nil t)
;;                      current-prefix-arg
;;                      nil nil))
;;   (when (eq str ?
;; )
;;     (setq str ?\n))
;;   (avy-with avy-goto-string-par
;;     (avy-jump
;;      (regexp-quote str)
;;      :window-flip arg
;;      :beg beg
;;      :end end)))

(global-unset-key (kbd "M-j"))
(global-set-key (kbd "M-j") 'avy-goto-char-timer)

(setq tab-always-indent t)

(custom-set-variables
  '(avy-timeout-seconds 10.0)
 )

;; line wrap indicators
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
(global-visual-line-mode 1)
(setq word-wrap nil)

;; more obvious paren
(setq show-paren-delay 0)
(after! paren
  (set-face-background 'show-paren-match "gray42"))

(defadvice show-paren-function (after my-echo-paren-matching-line activate)
  "If a matching paren is off-screen, echo the matching line."
  (when (and (> (point) 1) (char-equal (char-syntax (char-before (point))) ?\)))
    (let ((matching-text (blink-matching-open)))
      (when matching-text
        (message matching-text)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mode line
;; (setq doom-modeline-icon t)
;; (setq doom-modeline-icon nil)
;; (setq doom-modeline-unicode-fallback t)
;; (setq doom-modeline-buffer-file-name-style 'auto)
;; (setq doom-modeline-minor-modes nil)
;;(require 'powerline)
;;(powerline-default-theme)
;;
(use-package diminish
  :ensure t)

(use-package spaceline
  :ensure t)

(use-package spaceline-config
  :ensure spaceline
  :config
  (spaceline-helm-mode 1)
  (spaceline-emacs-theme)
  (spaceline-toggle-org-clock-on)
  (spaceline-toggle-minor-modes-off)
  (spaceline-toggle-version-control-off)
  (custom-set-faces
   '(spaceline-highlight-face
     ((t (:background "SteelBlue1" ; "DarkGoldenrod2"
          :foreground "#3E3D31"
          :inherit 'mode-line)))
     "Default highlight face for spaceline."
     :group 'spaceline)))


;;;; Mouse scrolling in terminal emacs
(unless (display-graphic-p)
  ;; activate mouse-based scrolling
  (xterm-mouse-mode 1)
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line)
  )

;; leader key
(global-unset-key (kbd "M-m"))
(setq doom-leader-alt-key "M-m")
(setq doom-localleader-alt-key "M-m l")

;; move cursor by camelCase
(global-subword-mode 1) ; 1 for on, 0 for off

;; load paths
(defvar me-emacs-dir "~/.config/emacs-me")
(defvar per-emacs-dir "~/.config/doom/personal")
(add-to-list 'load-path me-emacs-dir)
(add-to-list 'load-path per-emacs-dir)
(require 'me)

(load (concat (file-name-as-directory per-emacs-dir) "myFuns.el"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Org-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package org
;;   :mode (("\\.org$" . org-mode))
;;   :ensure org-plus-contrib
;;   :config
;;   (load (concat (file-name-as-directory per-emacs-dir) "org-config.el")))
(after! org
  (load (concat (file-name-as-directory per-emacs-dir) "org-config.el")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; basic configs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq-default fill-column 120)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Doom overrides
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; don't continue comments on newline
(setq +default-want-RET-continue-comments nil)

;;; use +vertico/project-search instead of +default/project-search to get preview
(map! :map 'override "M-m s p" #'+vertico/project-search)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; fringe
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq-default fringe-indicator-alist '((truncation left-arrow right-arrow)
                                       (continuation left-curly-arrow right-curly-arrow)
                                       (overlay-arrow . right-triangle)
                                       (up . up-arrow)
                                       (down . down-arrow)
                                       (top top-left-angle top-right-angle)
                                       (bottom bottom-left-angle bottom-right-angle top-right-angle top-left-angle)
                                       (top-bottom left-bracket right-bracket top-right-angle top-left-angle)
                                       (empty-line . empty-line)
                                       (unknown . question-mark)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; copy paste with mac clipboard
(when (eq system-type 'darwin)
  (use-package pbcopy
    :ensure t
    :config
    (turn-on-pbcopy))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; clipetty
(use-package clipetty
  :ensure t
  :hook (after-init . global-clipetty-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; save session every hour
;; (run-at-time 3600 t #'doom-save-session)

;; runs after 5 min of idle time. But block the annoying string output that causes
;; the minibuffer to expand
(defun doom-save-session-no-message ()
  (let ((fname (concat (doom-session-file) "-timer")))
    (let ((inhibit-message t)) (doom-save-session fname))
    (message (concat "autosaved workspace to " fname))))

(run-with-idle-timer 300 t #'doom-save-session-no-message)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ellama
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (use-package! ellama
;;   :init
;;   :config
;;   ;; setup key bindings
;;   (setopt ellama-keymap-prefix "C-c e")
;;   (setopt ellama-provider
;; 		  (make-llm-ollama
;; 		   :chat-model "llama2" :embedding-model "llama2")))



(after! git-commit
  (setq git-commit-summary-max-length 72))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; aider ai pair programmer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package aidermacs
  :config
  (global-set-key (kbd "M-m g") 'aidermacs-transient-menu)
  :custom
  ;; (aidermacs-default-model "ollama_chat/llama3.1:8b")
  (aidermacs-default-model "ollama_chat/qwen2.5-coder:32b")
  (aidermacs-show-diff-after-change t)
  (aidermacs-auto-commits nil)
  (aidermacs-default-model "ollama_chat/qwen2.5-coder:32b")
  ;;(aidermacs-weak-model "ollama_chat/llama3.1:8b")
  (aidermacs-extra-args '("--edit-format" "diff" "--editor-edit-format" "diff")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; nix
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(use-package nix-mode
  :hook
  (nix-mode . (lambda () (add-hook 'before-save-hook 'nix-format-before-save 'local)))
  (nix-mode . eglot-ensure)
  :custom
  (nix-nixfmt-bin "nixpkgs-fmt"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; eglot
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package eglot
  ;; :bind
  ;; (:map eglot-mode-map
  ;;       ("C-." . 'xref-find-definitions)
  ;;       ("C-," . 'xref-go-back)
  ;;       ("C-c ?" . 'eglot-help-at-point)
  ;;       ("C-c C-c" . 'eglot-code-actions)
  ;;       ("C-c C-r" . 'eglot-rename))
  :config
  )


;; --------------------------------------------------------------------
;; custom project root for eglot
;; --------------------------------------------------------------------

(defun my/project-try-sub-project (dir)
  "Find a project root based on sub-project marker files up to the VCS root."
  (let* ((vc-root (ignore-errors (vc-find-root (file-name-directory dir) ".git")))
         ;; Customize this list for your sub-project markers!
         (sub-project-markers '("package.json" "pyproject.toml" "flake.nix"))
         (root (locate-dominating-file dir
                                       (lambda (d)
                                         (or (member (file-name-nondirectory d) sub-project-markers)
                                             (equal d vc-root))))))
    (when (and root (not (equal root vc-root)))
      (cons 'sub-project root))))

(defun my/eglot-ensure-advice (orig-fun &rest args)
  "Advise eglot-ensure to prioritize finding sub-project root."
  (let ((project-find-functions
         (cons 'my/project-try-sub-project project-find-functions)))
    (apply orig-fun args)))


;; --------------------------------------------------------------------
;; Silence some (based)pyright rules inside Eglot
;; --------------------------------------------------------------------
(after! eglot
  (add-to-list 'eglot-server-programs
               `((python-mode python-ts-mode)
                 . ,(eglot-alternatives
                     '(("basedpyright-langserver" "--stdio")
                       ("pyright-langserver" "--stdio")
                       "pylsp"
                       "pyls"
                       "jedi-language-server"
                       ("ruff" "server")
                       "ruff-lsp"))))
  (setq-default
   eglot-workspace-configuration
   '(:basedpyright ( :typeCheckingMode "recommended" )
     :basedpyright.analysis
     ( :diagnosticSeverityOverrides
       ( :reportUnusedCallResult "none"
                                 :reportUnknownVariableType "none"
                                 :reportUntypedBaseClass "none"
                                 :reportUnknownArgumentType "none"
                                 :reportUnknownParameterType "none"
                                 :reportMissingParameterType "none"
                                 :reportAny "none"
                                 :reportUnknownMemberType "none")
                              :inlayHints ( :callArgumentNames :json-false ) )))
  ;; Apply the advice only to 'eglot-ensure'
  (advice-add 'eglot-ensure :around #'my/eglot-ensure-advice)
  )








(setq project-vc-extra-root-markers '("pyproject.toml" "flake.nix"))
(with-eval-after-load 'projectile
  ;; Add pyproject.toml to the list of project root indicators
  (add-to-list 'projectile-project-root-files "flake.nix")
  (add-to-list 'projectile-project-root-files "pyproject.toml")
  )

;; ;; Doom-specific lsp-mode performance tuning
;; (after! lsp-mode
;;   ;; Register basedpyright as the LSP server
;;   (lsp-register-client
;;    (make-lsp-client
;;     :new-connection (lsp-stdio-connection '("basedpyright-langserver" "--stdio"))
;;     :major-modes '(python-mode)
;;     :server-id 'basedpyright
;;     :priority 2))  ;; Ensure it's preferred over pyright or pylsp

;;   ;; Increase read buffer for LSP responses (default is 4k)
;;   (setq read-process-output-max (* 1024 1024)) ; 1MB

;;   ;; Delay before LSP triggers after typing
;;   (setq lsp-idle-delay 0.5)

;;   ;; Disable unnecessary features
;;   ;; (setq
;;   ;;  ;; lsp-enable-symbol-highlighting nil  ;; saves a lot of CPU
;;   ;;  lsp-enable-on-type-formatting nil  ;; turn off format-on-type
;;   ;;  lsp-log-io nil                          ;; turn off noisy LSP logs unless debugging
;;   ;;  ;; lsp-modeline-diagnostics-enable nil   ;; less UI overhead
;;   ;;  ;; lsp-modeline-code-actions-enable nil   ;; disable modeline code actions
;;   ;;  lsp-headerline-breadcrumb-enable nil  ;; disable breadcrumb header
;;   ;;  )
;;   (setq
;;    lsp-inlay-hint-enable t
;;    )

;;   ;; Optionally lazy-load LSP only when needed
;;   (add-hook 'lsp-mode-hook #'lsp-inlay-hints-mode)
;;   (add-hook 'python-mode-hook #'lsp-deferred)
;;   (add-hook 'typescript-mode-hook #'lsp-deferred)
;;   (add-hook 'tsx-mode-hook #'lsp-deferred)




;;   )

;; Optional: Disable lsp-ui for even leaner setup
;; (after! lsp-ui
;;   (setq lsp-ui-doc-enable nil
;;         lsp-ui-sideline-enable nil))



(reformatter-define ruff-sort-imports
  :program "ruff"
  :args '("check" "--select" "I" "--fix" "-")
  :lighter " ruff(sort)")

(reformatter-define ruff-format
  :program "ruff"
  :args '("format" "-")
  :lighter " ruff")


(add-hook 'python-mode-hook
          (lambda ()
            (setq-local lsp-disabled-clients '(pylsp pyright)) ;; explicitly disable others
            (add-hook 'before-save-hook #'ruff-sort-imports-buffer nil t)
            (add-hook 'before-save-hook #'ruff-format-buffer nil t)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; projectile

(defvar my/project-subproj-files
  '("pyproject.toml" "package.json" "setup.cfg" "flake.nix")
  "Files that identify a sub-project root.")

(defvar my/project-root-files
  '(".git")
  "Files that identify a sub-project root.")

(defun my/find-custom-project-root ()
  "Find the first parent directory with any of `my/project-root-files`."
  (cl-some (lambda (file)
             (locate-dominating-file default-directory file))
           my/project-root-files))

(defun my/projectile-project-root-advice (orig-fn &rest args)
  "Advice to override `projectile-project-root` with custom logic."
  (or (my/find-custom-project-root)
      (apply orig-fn args)))


(defun my/find-custom-subproj ()
  "Find the first parent directory with any of `my/project-root-files`."
  (cl-some (lambda (file)
             (locate-dominating-file default-directory file))
           my/project-subproj-files))

(defun my/projectile-subproj-advice (orig-fn &rest args)
  "Advice to override `projectile-project-root` with custom logic."
  (message "projectile-project-root called with args: %S" args)
  (or (my/find-custom-subproj)
      (apply orig-fn args)))



(defun my/projectile-projroot-search (&optional arg initial-query directory)
  "Temporarily override `projectile-project-root` with our custom logic for this call."
  (interactive "P")
  (advice-add 'projectile-project-root :around #'my/projectile-project-root-advice)
  (unwind-protect
      (+vertico/project-search arg initial-query directory)
    (advice-remove 'projectile-project-root #'my/projectile-project-root-advice)))


(defun my/projectile-subproj-search (&optional arg initial-query directory)
  "Temporarily override `projectile-project-root` with our custom logic for this call."
  (interactive "P")
  (advice-add 'projectile-project-root :around #'my/projectile-subproj-advice)
  (unwind-protect
      (+vertico/project-search arg initial-query directory)
    (advice-remove 'projectile-project-root #'my/projectile-subproj-advice)))


(defun my/projectile-subproj-run (arg)
  "Temporarily override `projectile-project-root` with our custom logic for this call."
  (interactive "P")
  (advice-add 'projectile-project-root :around #'my/projectile-subproj-advice)
  (unwind-protect
      (projectile-compile-project arg)
    (advice-remove 'projectile-project-root #'my/projectile-subproj-advice)))




(defun my/projectile-projroot-find-file (&optional invalidate-cache)
  "Temporarily override `projectile-project-root` with our custom logic for this call."
  (interactive "P")
  (advice-add 'projectile-project-root :around #'my/projectile-project-root-advice)
  (unwind-protect
      (projectile-find-file invalidate-cache)
    (advice-remove 'projectile-project-root #'my/projectile-project-root-advice)))


(defun my/projectile-subproj-find-file (&optional invalidate-cache)
  "Temporarily override `projectile-project-root` with our custom logic for this call."
  (interactive "P")
  (advice-add 'projectile-project-root :around #'my/projectile-subproj-advice)
  (unwind-protect
      (projectile-find-file invalidate-cache)
    (advice-remove 'projectile-project-root #'my/projectile-subproj-advice)))



(map! (:leader
      (:prefix ("s" . "search")
       :desc "Search project root" "p" #'my/projectile-projroot-search
       :desc "Search sub-project" "C-p" #'my/projectile-subproj-search))
      (:map global-map
       :desc "Find file project root" "C-c c" #'my/projectile-subproj-run
       :desc "Find file project root" "C-c p f" #'my/projectile-projroot-find-file
       :desc "Find file sub project" "C-c p C-f" #'my/projectile-subproj-find-file))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; magit clean merged branches
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-magit/delete-merged-branches ()
  (interactive)
  (magit-fetch-all-prune)
  (let* ((default-branch
           (read-string "Default branch: " (magit-get-current-branch)))
         (merged-branches
          (magit-git-lines "branch"
                           "--format" "%(refname:short)"
                           "--merged"
                           default-branch))
         (branches-to-delete
          (remove default-branch merged-branches)))
    (if branches-to-delete
        (if (yes-or-no-p (concat "Delete branches? ["
                                 (mapconcat 'identity branches-to-delete ", ") "]"))
            (magit-branch-delete branches-to-delete))
      (message "Nothing to delete"))))


;;(transient-append-suffix 'magit-branch "C"
;;    '("K" "delete all merged" my-magit/delete-merged-branches))

(after! magit
  (transient-append-suffix 'magit-branch "C"
    '("K" "Delete all merged branches" my-magit/delete-merged-branches)))



(defun open-current-buffer-in-vscode ()
  "Opens the current buffer's file in VS Code at the current cursor location."
  (interactive)
  (let ((file-path (buffer-file-name))
        (line-number (line-number-at-pos)))
    (if file-path
        (shell-command (format "/Applications/Antigravity.app/Contents/Resources/app/bin/antigravity -r --goto \"%s:%d\"" file-path line-number))
      (message "Buffer is not associated with a file."))))

(global-set-key (kbd "M-m c v") 'open-current-buffer-in-vscode)

(defun open-current-buffer-in-zed ()
  "Opens the current buffer's file in VS Code."
  (interactive)
  (let ((file-path (buffer-file-name)))
    (if file-path
        (shell-command (format "open -a \"Zed.app\" \"%s\"" file-path))
      (message "Buffer is not associated with a file."))))

(global-set-key (kbd "M-m c z") 'open-current-buffer-in-zed)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; copilot

;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("M-n <tab>" . 'copilot-accept-completion)
              ("M-n TAB" . 'copilot-accept-completion)
              ("M-n M-TAB" . 'copilot-accept-completion-by-word)
              ("M-n M-<Tab>" . 'copilot-accept-completion-by-word)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Done
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (message "All done, %s%s" (user-login-name) ".")
