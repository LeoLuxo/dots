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

      # To query the filetype of files
      file

      # To visualize images directly in the terminal
      viu

      (scriptBin.size { })
      (scriptBin.cheat { })
      (scriptBin.fuck { })
      (scriptBin.extract { })
      (scriptBin.q { })
    ];
  };
}
