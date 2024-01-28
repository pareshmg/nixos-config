{
  description = "My Personal Secrets";
  inputs = { };

  outputs = { self, ... } @inputs:
    let
      user = "yourname";
      name = "Your Name";
    in
    {
      #cmt = (import ./cmt-secrets/default.nix {});
      #per = (import ./secrets/default.nix {});
      profile = {
        per = {
          inherit user name;
          email = "personal@email.com";
          identityPaths = [
            "/home/${user}/.ssh/id_ed25519"
            "/Users/${user}/.ssh/id_ed25519"
          ];
        };
        test = {
          inherit user name;
          email = "";
          identityPaths = [ ];
          additionalPackages = ({ pkgs }: [ pkgs.scrcpy ]);
          hashedPassword = "YourHashedPassword";
        };
        ubuntu = {
          inherit name;
          user = "ubuntu";
          email = "ubuntu@vm.com";
          identityPaths = [ ];
        };
        work =
          let
            email = "work@email.com";
          in
          {
            inherit user name email;
            cmt = {
              # Your work config
            };
            identityPaths = [
              "/Users/${user}/.ssh/cmt_id_rsa"
            ];
          };
      };
    };
}
