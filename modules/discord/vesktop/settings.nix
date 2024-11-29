{
  user,
  ...
}:
{

  # home-manager.users.${user} = {
  # home.file."${home.config.xdg.configHome}/lf"  = {};
  # };

  # .xdg.configFile = {
  #   "vesktop/settings.json".text = builtins.toJSON {
  #     discordBranch = "stable";
  #     minimizeToTray = true;
  #     arRPC = true;
  #     splashColor = "rgb(198, 208, 245)";
  #     splashBackground = "rgb(48, 52, 70)";
  #     spellCheckLanguages = [ ];
  #   };

  #   "vesktop/settings/settings.json".text = builtins.toJSON {
  #     autoUpdate = false;
  #     autoUpdateNotification = false;
  #     useQuickCss = true;
  #     themeLinks = [
  #       "https://catppuccin.github.io/discord/dist/catppuccin-frappe-blue.theme.css"
  #     ];
  #     enabledThemes = [ ];
  #     enableReactDevtools = false;
  #     frameless = false;
  #     transparent = false;
  #     winCtrlQ = false;
  #     disableMinSize = false;
  #     winNativeTitleBar = false;
  #     plugins = {
  #       CommandsAPI = {
  #         enabled = true;
  #       };
  #       MessageAccessoriesAPI = {
  #         enabled = true;
  #       };
  #       UserSettingsAPI = {
  #         enabled = true;
  #       };
  #       CrashHandler = {
  #         enabled = true;
  #       };
  #       WebKeybinds = {
  #         enabled = true;
  #       };
  #       WebScreenShareFixes = {
  #         enabled = true;
  #       };
  #       NoTrack = {
  #         enabled = true;
  #         disableAnalytics = true;
  #       };
  #       WebContextMenus = {
  #         enabled = true;
  #         addBack = true;
  #       };
  #       Settings = {
  #         enabled = true;
  #         settingsLocation = "aboveNitro";
  #       };
  #     };
  #     notifications = {
  #       timeout = 5000;
  #       position = "bottom-right";
  #       useNative = "not-focused";
  #       logLimit = 50;
  #     };
  #     cloud = {
  #       authenticated = false;
  #       url = "https://api.vencord.dev/";
  #       settingsSync = false;
  #       settingsSyncVersion = 1730282253502;
  #     };
  #   };
  # };
}
