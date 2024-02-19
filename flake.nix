{
  description = "Flake for RareSkills ZK Bootcamp";

  inputs = {
    nixpkgs.url = "github:glottologist/nixpkgs/master";
    fenix.url = "github:nix-community/fenix";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
    jupyenv.url = "github:tweag/jupyenv";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  nixConfig = {
    extra-substituters = [
      "https://tweag-jupyter.cachix.org"
      "https://devenv.cachix.org"
    ];
    extra-trusted-public-keys = [
      "tweag-jupyter.cachix.org-1:UtNH4Zs6hVUFpFBTLaA4ejYavPo5EFFqgd7G7FxGW9g="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    fenix,
    jupyenv,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devenv.flakeModule
      ];

      systems = inputs.nixpkgs.lib.systems.flakeExposed;

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        inherit (jupyenv.lib.${system}) mkJupyterlabNew;
        jupyterlab = mkJupyterlabNew ({...}: {
          nixpkgs = inputs.nixpkgs;
          imports = [(import ./kernels.nix)];
        });
      in rec
      {
        packages = {inherit jupyterlab;};
        packages.default = jupyterlab;
        apps.default.program = "${jupyterlab}/bin/jupyter-lab";
        apps.default.type = "app";

        devenv.shells.default = {
          name = "Trading view to IG shell";
          env.GREET = "devenv for the TVIG";
          packages = with pkgs; [
            git
            slither-analyzer
            solc
            python311Packages.numpy
            python311Packages.scipy
            python311Packages.sympy
            python311Packages.ecpy
            python311Packages.py-ecc
            python311Packages.web3
            nodePackages.ganache
          ];
          enterShell = ''
            git --version
            nix --version
            solc --version
          '';
          scripts.sol.exec = ''
            solc --abi -o output/ --overwrite --bin $1
          '';
          languages = {
            nix.enable = true;
            python.enable = true;
          };
          dotenv.enable = true;
          devcontainer.enable = true;
          difftastic.enable = true;
          pre-commit.hooks = {
            alejandra.enable = true;
            commitizen.enable = true;
            prettier.enable = true;
          };
        };
      };
    };
}
