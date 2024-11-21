{
  home = {
    activation = {
      podmanSetupBase = ''
        if ! /run/current-system/sw/bin/podman machine ls --format "{{.Name}}" | grep -q "podman-machine-default"; then
          echo "No default podman machine found, initializing one..."
          /run/current-system/sw/bin/podman machine init
        fi
        /run/current-system/sw/bin/podman machine start
      '';
    };
  };
}
