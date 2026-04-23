target-folder:

let
  walk = path:
    let
      entries = builtins.readDir path;
      walkEntry = name: kind:
        let
          fullPath = "${path}/${name}";
          #kind = entries.${name};
        in
          if kind == "directory" then (walk fullPath) else [ fullPath ];
    in
      builtins.concatLists (builtins.attrValues (builtins.mapAttrs walkEntry entries));
in
walk target-folder