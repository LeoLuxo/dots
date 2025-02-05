{ ... }:

{
  services.ollama = {
    enable = true;
    loadModels = [
      "deepseek-r1:8b"
      "llava:7b"
      "deepseek-coder-v2:16b"

      # "llama3.2:3b"
      # "llama3.2-vision:11b"
      # "phi4:14b"
      # "dolphin3:8b"
      # "smallthinker:3b"
      # "nomic-embed-text"
    ];

    acceleration = "cuda";
  };

  services.open-webui = {
    enable = true;
    port = 11111;
    host = "127.0.0.1";
  };

  # environment.systemPackages = with pkgs; [
  # oterm
  # alpaca
  # aichat
  # aider-chat

  # tgpt
  # smartcat
  # nextjs-ollama-llm-ui
  # open-webui
  # ];
}
