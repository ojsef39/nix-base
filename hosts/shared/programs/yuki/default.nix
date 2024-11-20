{ pkgs, lib, vars, ... }: {
  home.file.".config/yuki/config.conf".text = ''
    # Path to linux system packages nix file 
    linux_packages_path ${vars.git.nix}/hosts/shared/apps.nix
    # Path to darwin system packages nix file 
    darwin_packages_path ${vars.git.nix}/hosts/darwin/apps.nix
    # Path to homebrew packages file
    homebrew_packages_path ${vars.git.nix}/hosts/darwin/homebrew.nix

    # Git setup
    # Automatically add a commit when installing or uninstalling packages
    auto_commit true
    auto_push false

    # Commit messages. Use <package> to insert the package name
    uninstall_message "chore(apps): removed <package> [yuki]"
    install_message "chore(apps): installed <package> [yuki]"

    # Commands that will be run after package operations
    install_command "update-nix"
    uninstall_command "update-nix"
    update_command "update-nix"
  '';
}
