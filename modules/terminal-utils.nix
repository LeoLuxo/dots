{
  pkgs,
  user,
  scriptBin,
  ...
}:
{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      # To highlight source code
      highlight

      (scriptBin.size { })
      (scriptBin.cheat { })
      (scriptBin.fuck { })
      (scriptBin.extract { })
      (scriptBin.q { })
    ];
  };
}
