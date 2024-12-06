{
  pkgs,
  user,
  musnix,
  ...
}:
{
  imports = [ musnix.nixosModules.musnix ];

  musnix.enable = true;
  users.users.${user}.extraGroups = [ "audio" ];

  environment.systemPackages = with pkgs; [ wireplumber ];

  # services.pipewire.wireplumber = {
  #   enable = true;
  # };

}
