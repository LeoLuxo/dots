final: prev: {
  vesktop = prev.vesktop.overrideAttrs (oldAttrs: {
    desktopItems = (
      prev.makeDesktopItem {
        name = "vesktop";
        desktopName = "Discord";
        exec = "vesktop %U";
        icon = "vesktop";
        startupWMClass = "Discord";
        genericName = "Internet Messenger";
        keywords = [
          "discord"
          "vencord"
          "vesktop"
          "electron"
          "chat"
        ];
        categories = [
          "Network"
          "InstantMessaging"
          "Chat"
        ];
      }
    );
  });
}
