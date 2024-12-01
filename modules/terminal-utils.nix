{
  pkgs,
  user,
  scriptBin,
  ...
}:
{
  home-manager.users.${user} = {
    home.packages = with pkgs; [

      file

      (scriptBin.size { })
      (scriptBin.fuck { })
      (scriptBin.cheat { deps = [ curl ]; })

      (scriptBin.extract {
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
  };
}
