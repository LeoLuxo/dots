{
  pkgs,
  config,
  ...
}:

{
  imports = [
    ./deepl-linux-electron.nix

    # (mkGlobalKeybind {
    #   name = "Instant translate";
    #   binding = "<Super>d";
    #   command = "dialect --selection";
    # })
  ];

  ext.packages = with pkgs; [
    deepl-linux-electron
  ];
}
