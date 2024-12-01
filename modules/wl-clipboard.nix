{
  pkgs,
  user,
  writeScriptWithDeps,
  ...
}:
{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      wl-clipboard

      (writeScriptWithDeps {
        name = "copy";
        text = ''wl-copy $@'';
        deps = [ wl-clipboard ];
      })

      (writeScriptWithDeps {
        name = "paste";
        text = ''wl-paste $@'';
        deps = [ wl-clipboard ];
      })
    ];
  };
}
