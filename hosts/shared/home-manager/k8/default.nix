{ pkgs, lib, ... }: {
  ##HELM
  programs.helm = {
    enable = lib.mkDefault true;
    repositories = {
      stable.url = "https://charts.helm.sh/stable";
    };
  };
}
