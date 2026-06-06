{ lib, pkgs, opt, ... }:

lib.mkIf (opt.ollama == true) {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    environmentVariables = {
      HTTP_PROXY = "127.0.0.1:1090";
      HTTPS_PROXY = "127.0.0.1:1090";
      ALL_PROXY = "127.0.0.1:1090";
    };
  };

  services.nextjs-ollama-llm-ui = {
    enable = true;
    port = 3030;
  };
}
