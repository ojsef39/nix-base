{ pkgs, lib, vars, ... }: {
  home.file.".config/nixp/config.conf".source = ./config.conf;
}
