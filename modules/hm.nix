{
  lib,
  users,
  config,
  ...
}:
{
  # Special module to map all instances of the `hm` (nixos) setting to all users in home-manager

  options.hm = lib.mkOption {
    default = { };
    # Steal the home manager module type (doesn' work, so currently `config.hm` can only accept attrSets)
    # type = options.home-manager.users.type.nestedTypes.elemType;
  };

  config = {
    home-manager.users = lib.concatMapAttrs (username: _: {
      ${username} = {
        imports = [
          config.hm
        ];
      };
    }) users;
  };
}
