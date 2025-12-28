{ pkgs }:

pkgs.writeShellApplication {
  name = "term-screen-off";
  runtimeInputs = with pkgs; [ util-linux ];
  text = ''TERM=linux setterm --blank force </dev/tty1'';
}
