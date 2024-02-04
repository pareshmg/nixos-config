{
  description = "My Personal Secrets";
  inputs = { };

  outputs = { self, ... } @inputs:
    let
      user = "yourname";
      name = "Your Name";
      email = "your@email.com";
    in
    {
      #cmt = (import ./cmt-secrets/default.nix {});
      #per = (import ./secrets/default.nix {});
      profile = {
        per = {
          inherit user name email;
          identityPaths = [
            "/home/${user}/.ssh/id_ed25519"
            "/Users/${user}/.ssh/id_ed25519"
          ];
        };
        vm = {
          ip = "192.168.1.3";
          macAddress = "aabbccdd";
        };
        nervasion = {
          networking = {
            defaultGateway = "192.168.1.1";
            nameservers = [ "4.4.4.4" ];
          };
        };
        test = {
          inherit user name email;
          identityPaths = [ ];
          # additionalPackages = ({ pkgs }: [ pkgs.scrcpy ]);
          # hashedPassword = "YourHashedPassword";
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
              "/Users/${user}/.ssh/work_id_rsa"
            ];
          };
      };
    };
}
