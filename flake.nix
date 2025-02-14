{
  description = "Description for the project";

  inputs = {
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    devenv.url = "github:cachix/devenv";
    nix2container.url = "github:nlewo/nix2container";
    nix2container.inputs.nixpkgs.follows = "nixpkgs";
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = inputs@{ flake-parts, devenv-root, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devenv.flakeModule
      ];
      systems = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
        packages.default = pkgs.hello;

        devenv.shells.default = {
          devenv.root =
            let
              devenvRootFileContent = builtins.readFile devenv-root.outPath;
            in
            pkgs.lib.mkIf (devenvRootFileContent != "") devenvRootFileContent;

          name = "pintelier";

          imports = [
            # This is just like the imports in devenv.nix.
            # See https://devenv.sh/guides/using-with-flake-parts/#import-a-devenv-module
            # ./devenv-foo.nix
          ];

          # https://devenv.sh/reference/options/
          packages = [ 
            config.packages.default
            pkgs.elixir-ls
            pkgs.imagemagick
          ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [ pkgs.inotify-tools ];

          languages.elixir.enable = true;

          services.postgres = {
            enable = true;
            initialScript = ''
              CREATE ROLE postgres WITH LOGIN PASSWORD 'postgres' SUPERUSER;
            '';
            initialDatabases = [{ name = "pintelier_dev"; }];
          };

          processes.phoenix.exec = "mix phx.server";

          enterShell = ''
            mkdir -p "''${DEVENV_ROOT:-.}/.nix-mix" "''${DEVENV_ROOT:-.}/.nix-hex"
            export MIX_HOME="''${DEVENV_ROOT:-.}/.nix-mix"
            export HEX_HOME="''${DEVENV_ROOT:-.}/.nix-hex"
            # make hex from Nixpkgs available
            # `mix local.hex` will install hex into MIX_HOME and should take precedence
            export PATH=$MIX_HOME/bin:$HEX_HOME/bin:$PATH
            export LANG=C.UTF-8
            # keep your shell history in iex
            export ERL_AFLAGS="-kernel shell_history enabled"
          '';

        };

      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}
