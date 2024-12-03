{
  pkgs,
  user,
  scriptBin,
  ...
}:
{
  home-manager.users.${user} = {
    home.packages = with pkgs; [

      # To query the filetype of files
      file

      # Because of the way '!!' works in bash, it's easier to make please a script rather than an alias
      (scriptBin.please { })
      (scriptBin.size { })
      (scriptBin.cheat { deps = [ curl ]; })

      (scriptBin.extract {
        # All the archive extractors used in the script
        deps = [
          gnutar
          rar
          unzip
          p7zip
          gzip
        ];
      })

      (scriptBin.q {
        deps = [
          # To highlight source code
          highlight

          # To query the filetype of files
          file

          # To visualize images directly in the terminal
          viu
        ];
      })
    ];

    # Add aliases
    home.shellAliases = {
      pls = "please";
    };
  };

}
