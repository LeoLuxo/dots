{
  "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
  blocks = [
    {
      alignment = "left";
      newline = true;
      segments = [
        {
          background = "transparent";
          foreground = "p:highlight";
          style = "plain";
          template = "┏";
          type = "text";
        }
        {
          background = "p:sapphire";
          foreground = "p:textb";
          leading_diamond = "";
          powerline_symbol = "";
          properties = {
            linux = "";
            macos = "";
            ubuntu = "";
            windows = "";
          };
          style = "diamond";
          template = "{{.Icon}}{{if .WSL}} (WSL){{end}}⠀";
          type = "os";
        }
        {
          background = "p:lavender";
          foreground = "p:textd";
          powerline_symbol = "";
          style = "powerline";
          template = "  {{.Shell}}{{if .Root}} (ADMIN){{end}}⠀";
          type = "text";
        }
        {
          background = "p:pink";
          foreground = "p:textd";
          powerline_symbol = "";
          style = "powerline";
          template = "  {{.HostName}}<b>{{.UserName}}</b>⠀";
          type = "session";
        }
        {
          background = "p:maroon";
          foreground = "p:textd";
          powerline_symbol = "";
          properties = {
            branch_icon = " ";
            cherry_pick_icon = " ";
            commit_icon = " ";
            fetch_stash_count = true;
            fetch_status = true;
            fetch_upstream_icon = true;
            fetch_worktree_count = true;
            merge_icon = " ";
            no_commits_icon = " ";
            rebase_icon = " ";
            revert_icon = " ";
            tag_icon = " ";
          };
          style = "powerline";
          template = " {{ .UpstreamIcon }}{{ .HEAD }}{{if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }}  {{ .Working.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Staging.Changed }}  {{ .Staging.String }}{{ end }}{{ if gt .StashCount 0 }}  {{ .StashCount }}{{ end }} ";
          type = "git";
        }
        {
          background = "p:flamingo";
          foreground = "p:textd";
          powerline_symbol = "";
          properties = {
            fetch_package_manager = true;
            npm_icon = " <#cc3a3a></> ";
            yarn_icon = " <#348cba></>";
          };
          style = "powerline";
          template = "  {{ if .PackageManagerIcon }}{{ .PackageManagerIcon }} {{ end }}{{ .Full }}";
          trailing_diamond = " ";
          type = "node";
        }
        {
          background = "p:flamingo";
          foreground = "p:textd";
          powerline_symbol = "";
          style = "powerline";
          template = "  {{ if .Error }}{{ .Error }}{{ else }}{{ if .Venv }}{{ .Venv }} {{ end }}{{ .Full }}{{ end }}";
          trailing_diamond = " ";
          type = "python";
        }
        {
          background = "p:flamingo";
          foreground = "p:textd";
          powerline_symbol = "";
          style = "powerline";
          template = "  {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }}";
          trailing_diamond = " ";
          type = "java";
        }
        {
          background = "p:flamingo";
          foreground = "p:textd";
          powerline_symbol = "";
          style = "powerline";
          template = "  {{ if .Unsupported }}{{ else }}{{ .Full }}{{ end }}";
          trailing_diamond = " ";
          type = "dotnet";
        }
        {
          background = "p:flamingo";
          foreground = "p:textd";
          powerline_symbol = "";
          style = "powerline";
          template = "  {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }}";
          trailing_diamond = " ";
          type = "go";
        }
        {
          background = "p:flamingo";
          foreground = "p:textd";
          powerline_symbol = "";
          style = "powerline";
          template = "  {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }}";
          trailing_diamond = " ";
          type = "rust";
        }
      ];
      type = "prompt";
    }
    {
      alignment = "right";
      segments = [
        {
          background = "transparent";
          foreground = "p:highlight";
          properties = {
            style = "austin";
            threshold = 0;
          };
          style = "plain";
          template = " {{.FormattedMs}}";
          type = "executiontime";
        }
        {
          background = "transparent";
          foreground = "p:textb";
          style = "plain";
          template = " · ";
          type = "text";
        }
        {
          background = "transparent";
          foreground = "p:highlight";
          properties = {
            time_format = "15:04:05";
          };
          style = "plain";
          template = " {{.CurrentDate | date .Format}}";
          type = "time";
        }
      ];
      type = "prompt";
    }
    {
      alignment = "left";
      newline = true;
      segments = [
        {
          background = "transparent";
          foreground = "p:highlight";
          style = "plain";
          template = "┗";
          type = "text";
        }
        {
          background = "transparent";
          foreground = "p:textb";
          properties = {
            folder_icon = "<p:highlight> …</>";
            folder_separator_template = "<p:highlight>  </>";
            hide_root_location = false;
            home_icon = "";
            max_depth = 4;
            style = "agnoster_short";
          };
          style = "plain";
          template = "<p:highlight></> {{.Path}} <p:highlight></>";
          type = "path";
        }
      ];
      type = "prompt";
    }
    {
      alignment = "left";
      newline = true;
      segments = [
        {
          background = "transparent";
          foreground_templates = [
            "{{if eq .Code 0}}p:green{{else}}p:red{{end}}"
          ];
          properties = {
            always_enabled = true;
          };
          style = "plain";
          template = "<f>{{if eq .Code 0}}{{else}}{{end}}</f>";
          type = "status";
        }
      ];
      type = "prompt";
    }
  ];
  console_title_template = "{{if .Root}}[root] {{end}}{{.Shell}} in <{{.Folder}}>";
  final_space = true;
  palette = {
    os = "#acb0be";
    white = "#ffffff";
    textd = "#45495e";
    textb = "#e8edff";
    highlight = "p:sapphire";
    success = "p:green";
    failure = "p:red";
    rosewater = "#f4dbd6";
    flamingo = "#f0c6c6";
    pink = "#f5bde6";
    mauve = "#c6a0f6";
    red = "#ed8796";
    maroon = "#ee99a0";
    peach = "#f5a97f";
    yellow = "#eed49f";
    green = "#a6da95";
    teal = "#8bd5ca";
    sky = "#91d7e3";
    sapphire = "#7dc4e4";
    blue = "#8aadf4";
    lavender = "#b7bdf8";
  };
  transient_prompt = {
    background = "transparent";
    foreground = "p:textb";
    template = "<i>{{now | date \"15:04:05\"}}</i> ❯ ";
  };
  version = 2;
}
