{
  lib,
  pkgs,
  inputs,
  ...
}:
/*
 let
  mylsp-ai = (pkgs.lsp-ai.overrideAttrs (oldAttrs: { buildFeatures = ["llama_cpp"];}));
in
*/
 {
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.system}.default;

    settings = {
      #theme = "catppuccin_frappe_transparent";
      keys.normal = {
        j = "move_char_left";
        k = "move_line_down";
        l = "move_line_up";
        "'" = "move_char_right";
      };
      keys.select = {
        "%" = "match_brackets";
      };
      editor = {
        color-modes = true;
        cursorline = true;
        mouse = false;
        idle-timeout = 1;
        bufferline = "always";
        true-color = true;
        lsp = {
          enable = true;
          display-messages = true;
          display-inlay-hints = true;
        };
        rulers = [80];
        indent-guides = {
          render = true;
        };
        gutters = ["diagnostics" "line-numbers" "spacer" "diff"];

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "block";
        };
      };
    };
    #themes = {
    #  catppuccin_frappe_transparent = {
    #    "inherits" = "catppuccin_frappe";
    #    "ui.backround" = "{}";
    #  };
    #};
    languages = {
      language = [
        {
          name = "cpp";
          auto-format = false;
          formatter = {
            command = "${pkgs.clang-tools}/bin/clang-format";
            args = ["-i"];
          };
        }
        {
          name = "css";
          auto-format = true;
        }
        {
          name = "go";
          auto-format = true;
          comment-token = "//";
          #formatter.command = "${pkgs.gotools}/bin/goimports";
          language-servers = [ "lsp-ai" "gopls" ];
        }
        {
          name = "javascript";
          auto-format = true;
        }
        {
          name = "markdown";
          language-servers = [ "lsp-ai" ];
        }
        {
          name = "rust";
          auto-format = false;
        }
        {
          name = "typescript";
          auto-format = true;
          formatter.command = "${pkgs.nodePackages.prettier}/bin/prettier";
        }
      ];
      language-server = {
        clangd = {
          command = "${pkgs.clang-tools}/bin/clangd";
          clangd.fallbackFlags = ["-std=c++2b"];
        };
        gopls = {
          command = "${pkgs.gopls}/bin/gopls";
          config = {
            gofumpt = true;
            local = "goimports";
            semanticTokens = true;
            staticcheck = true;
            usePlaceholders = true;
            completeUnimported = true;
            verboseOutput = true;
            /*
            analyses = {
              fieldalignment = true;
              nilness = true;
              unusuedparams = true;
              unusuedwrite = true;
              useany = true;
            };
            */
            hints = {
              assignVariableType = true;
              compositeLiteralFields = true;
              compositeLiteralTypes = true;
              constantValues = true;
              functionTypeParameters = true;
              parameterNames = true;
              rangeVariableTypes = true;
            };
          };
        };
        /*
        golangci-lint-langserver = {
          command = "${pkgs.golangci-lint-langserver}/bin/golangci-lint-langserver";
        };
        */
        lsp-ai = {
          command = "lsp-ai";
          config = {
            /*
            completion = {
              model = "completionModel";
              parameters = {
                max_tokens = 32;
                max_context = 1024;
                fim = {
                  start = "<fim_prefix>";
                  middle = "<fim_suffix>";
                  end = "<fim_middle>";
                };
              };
            };
            */
            memory = {
              file_store = { };
            };
            /*
            models = {
              completionModel = {
                type = "llama_cpp";
                repository = "stabilityai/stable-code-3b";
                name = "stable-code-3b-Q5_K_M.gguf";
                n_ctx = 2048;
                n_gpu_layers = 1000;
              };
              chatModel = {
                type = "llama_cpp";
                repository = "bartowski/DeepSeek-R1-Distill-Qwen-32B-GGUF";
                name = "DeepSeek-R1-Distill-Qwen-32B-IQ4_XS.gguf";
                n_ctx = 2048;
                n_gpu_layers = 1000;
              };
            };
            */
          };
        };
        nil = {
          command = lib.getExe pkgs.nil;
          config.nil.formatting.command = ["${lib.getExe pkgs.alejandra}" "-q"];
        };
        typescript-language-server = with pkgs.nodePackages; {
          command = "${typescript-language-server}/bin/typescript-language-server";
          args = ["--stdio" "--tsserver-path=${typescript}/lib/node_modules/typescript/lib"];
        };
      };
    };
  };
  home.packages = with pkgs; [
    # Dev tools
    black
    clang
    clang-tools
    delve
    gawk
    go
    golangci-lint-langserver
    gomodifytags
    gopkgs
    gotests
    gotools
    java-language-server
    kotlin-language-server
    ktlint
    #inputs.llama-cpp.packages.${pkgs.system}.default
    #llamaPackages.llama-cpp
    lldb
    lsp-ai
    rust-analyzer
    rustfmt
    selene
    shellcheck
    texlab
    uncrustify
    nodePackages.prettier
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.yaml-language-server
    nodePackages.yarn
    cargo
  ];
}
