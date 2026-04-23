hostname:
let
  # Create a sha256 hash of the hostname
  hash = builtins.hashString "sha256" hostname;
  # Take the first 12 characters of the hash
  s = builtins.substring 0 12 hash;
  # Format into a MAC address string
  # We force the first byte to '02' to ensure it's a "Locally Administered Address"
  mac = "02:${builtins.substring 2 2 s}:${builtins.substring 4 2 s}:${builtins.substring 6 2 s}:${builtins.substring 8 2 s}:${builtins.substring 10 2 s}";
in
  mac
