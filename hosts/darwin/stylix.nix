{ pkgs, ... }:

{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    opacity.terminal = 0.9;
    targets.yazi.enable = true;
  };
}
