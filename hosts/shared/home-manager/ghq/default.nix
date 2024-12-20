{
  ## GHQ -> This must run after the writeBoundary to make sure gitconfig with ghq settings is set
  home.activation = {
    ghqGetRepos = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ghq get https://github.com/ojsef39/commit-oracle
      ghq get https://github.com/ojsef39/nix-base
    '';
  };
}
