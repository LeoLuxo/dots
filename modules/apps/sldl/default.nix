{
  pkgs,
  constants,
  ...
}:

let
  inherit (constants) user;
in

let
  package =
    { buildDotnetModule, fetchFromGitHub }:
    buildDotnetModule {
      pname = "sldl";
      version = "2.4.6";

      src = fetchFromGitHub {
        owner = "fiso64";
        repo = "slsk-batchdl";
        rev = "0259f7d86802127175a546ec88ccb6b4b0e84a31";
        hash = "";
      };

      projectFile = "slsk-batchdl.sln";

      nugetDeps = "";
    };
in

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      (callPackage package { })
    ];
  };
}
