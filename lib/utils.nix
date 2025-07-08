{ lib, ... }:

{
  sanitizePath =
    path:
    builtins.path {
      inherit path;
      name = lib.strings.sanitizeDerivationName (builtins.baseNameOf path);
    };

  notNullOr = value: fallback: if value != null then value else fallback;

  writeFile =
    {
      path,
      text,
      force ? false,
    }:
    ''
      ${if force then "rm -f ${path}" else ""}

      mkdir --parents "$(dirname "${path}")"
      cat >"${path}" <<-EOF
      ${text}
      EOF
    '';
}
