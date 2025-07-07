{ lib, ... }:

{
  # https://gist.github.com/udf/4d9301bdc02ab38439fd64fbda06ea43
  mkMergeTopLevel =
    names: attrs:
    lib.getAttrs names (
      lib.mapAttrs (k: v: lib.mkMerge v) (lib.foldAttrs (n: a: [ n ] ++ a) [ ] attrs)
    );
}
