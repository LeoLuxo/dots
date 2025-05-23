{
  directory = "/stuff/media/music";
  library = "/stuff/media/music/beets.db";

  plugins = [
    "fetchart"
    "lyrics"
    "lastgenre"
    "embedart"
    "inline"
    "deezer"
    "autobpm"
    "fetchartist"
    "info"
  ];

  threaded = "yes";

  ui.color = "yes";

  import = {
    write = "yes";
    move = "yes";
    autotag = "yes";
    resume = "ask";
    from_scratch = "no";
    duplicate_action = "ask";
    bell = "yes";
    languages = "en";
  };

  match.distance_weights = {
    missing_tracks = 0.2;
    unmatched_tracks = 1;
  };

  item_fields = {
    main_artist = ''
      import re
      return re.split('\\W+(feat(.?|uring)|ft\\.?)', albumartist, 1, flags=re.IGNORECASE)[0]
    '';
    smart_single = ''
      is_single = (disctotal == 1 and tracktotal == 1)
      if is_single:
        return f"{artist} - {title}"
      else
        return f"{album} ({year})/{track} - {title}"
    '';
  };

  paths = {
    default = "artists/$main_artist/$smart_single";
    singleton = "artists/$main_artist/$smart_single";
    "albumtype:soundtrack" = "soundtracks/$album ($year)/$track - $title";
    comp = "compilations/$album ($year)/$track - $artist - $title";
  };

  clutter = [
    ".DS_Store"
    "Thumbs.DB"
    "*.xml"
    "*.nfo"
    "*.lrc"
    "*.jpg"
    "*.png"
    ".txt"
  ];

  asciify_path = "yes";

  replace = {
    "[\\\\/]" = "";
    "^\\." = "";
    "[\\x00-\\x1f]" = "_";
    "[<>\"\\*\\|]" = "";
    "\\.$" = "";
    "\\s+$" = "";
    "^\\s+" = "";
    "^-" = "";
  };

  # Plugins
  lastgenre = {
    auto = "yes";
    force = "yes";
    keep_existing = "no";
    whitelist = "yes";
    count = 5;
  };

  lyrics = {
    auto = "yes";
    force = "yes";
    print = "no";
    sources = [ "lrclib" ];
    synced = "yes";
  };

  fetchart = {
    auto = "yes";
    high_resolution = "yes";
  };

  embedart = {
    auto = "yes";
    remove_art_file = "yes";
    ifempty = "no";
  };

  autobpm.auto = "yes";

  fetchartist.filename = "artist";

}
