{ lib, ... }:

rec {
  # https://gist.github.com/udf/4d9301bdc02ab38439fd64fbda06ea43
  mkMergeTopLevel =
    names: attrs:
    lib.getAttrs names (
      lib.mapAttrs (k: v: lib.mkMerge v) (lib.foldAttrs (n: a: [ n ] ++ a) [ ] attrs)
    );

  # mkSmartMerge =
  #   path2: minExtract2: attrList2:
  #   let
  #     path = lib.traceValSeq (lib.trace "path" path2);
  #     minExtract = lib.traceValSeq (lib.trace "minExtract" minExtract2);
  #     attrList = lib.traceValSeq (lib.trace "attrList" attrList2);

  #     pathHead = lib.head path;
  #     pathTail = lib.tail path;

  #     mkSmartMergeAttr =
  #       attrs:
  #       if attrs ? "_type" then
  #         # Recursive/passthrough cases, where we find a mkIf/mkMerge etc
  #         if attrs ? "content" then
  #           # 'content' means mkIf / ..., and is attrs, so call mkSmartMergeAttr
  #           attrs // { content = mkSmartMergeAttr attrs.content; }

  #         else if attrs ? "contents" then
  #           # 'contents' means mkMerge / ..., and is a list, so call mkSmartMerge
  #           attrs // { contents = mkSmartMerge path attrs.contents; }

  #         else
  #           lib.traceVal (lib.warn "SmartMerge: found _type, but found no attribute to recurse in!" attrs)

  #       else if attrs ? pathHead || minExtract > 0 then
  #         # We found the first element of the path,
  #         { }
  #       else
  #         { };

  #     out = lib.map mkSmartMergeAttr attrList;

  #   in
  #   lib.traceSeq (lib.trace "out" out) { };
}
