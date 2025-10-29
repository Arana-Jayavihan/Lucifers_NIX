{ ... }:

let
  inherit (import ../../options.nix) userHome;
in {

  services.ollama = {
    enable = true;
    #home = "${userHome}";
    #models = "${userHome}/Ollama/Models";
    acceleration = "cuda";
    #user = "lucifer";
    #group = "users";
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

