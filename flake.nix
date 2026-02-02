{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      forSystem = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
      ];
      pkgsFor = forSystem (system :
        import nixpkgs { inherit system; }
      );
    in
    
    {
      devShells = forSystem
        (system:
          let
            pkgs = pkgsFor."${system}";
          in
            {
              default = pkgs.mkShell {
                buildInputs = with pkgs;
                  [
                    zsh
                    ruby_4_0
                    bundler
                    rubyPackages_4_0.jekyll
                  ];
                shellHook = ''
                     export SHELL=${pkgs.zsh}/bin/zsh
                     exec ${pkgs.zsh}/bin/zsh --login
                '';
              };
            }
        );
    };
}
