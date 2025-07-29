_: {
  programs = {
    # Terminal file manager
    yazi = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        manager = {
          layout = [
            1
            4
            3
          ];
          sort_by = "natural";
          sort_sensitive = false;
          sort_reverse = false;
          sort_dir_first = true;
          linemode = "size_and_mtime";
          show_hidden = true;
          show_symlink = true;
        };
        preview = {
          image_filter = "lanczos3";
          image_quality = 90;
          tab_size = 1;
          max_width = 600;
          max_height = 900;
          cache_dir = "";
          ueberzug_scale = 1;
          ueberzug_offset = [
            0
            0
            0
            0
          ];
        };
        tasks = {
          micro_workers = 5;
          macro_workers = 10;
          bizarre_retry = 5;
        };
      };
    };
  };
}
