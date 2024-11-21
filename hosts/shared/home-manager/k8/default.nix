{
  home.activation = {
    ## HELM
    helmSetup = ''
      /opt/homebrew/bin/helm repo add stable https://charts.helm.sh/stable
      /opt/homebrew/bin/helm repo update
    '';
  };
}
