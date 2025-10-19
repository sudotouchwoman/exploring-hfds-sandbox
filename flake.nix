{
  # run "nix develop .#shell-name" in this directory to build and enter dev shell
  description = "Nix Flake for python project";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        common-pkgs = import inputs.nixpkgs { inherit system; };

        build-inputs-list = pkgs-set: with pkgs-set; [
          # last buildable python and uv for package management
          python312Packages.uv
          python312
        ];

        build-inputs = build-inputs-list common-pkgs;
      in
      {
        devShells.default = common-pkgs.mkShell {
          name = "python-env";
          buildInputs = build-inputs;

          # in order for prebuild binaries like python wheels and other packages
          # to operate, we need to patch the env a bit, including paths to runtime libs
          LD_LIBRARY_PATH = "${common-pkgs.lib.makeLibraryPath build-inputs}";
        };

        # formatting configuration for nix fmt
        formatter = common-pkgs.nixpkgs-fmt;
      }
    );
}
