{
  user,
  ...
}:

let
  theme = ./themes/peppy.omp.json;
in
{
  home-manager.users.${user} = {
    programs.oh-my-posh = {
      enable = true;
      # settings = builtins.fromJSON (builtins.readFile theme);
      useTheme = "catpuccin_frappe";
    };
  };
}
