{
  description = "Dev shell for Jekyll (GitHub Pages) site";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        # Use Ruby 3.4 as requested
        ruby = pkgs.ruby_3_4;
        # Ruby gems resolved by bundix (Gemfile.lock + gemset.nix)
        rubyEnv = pkgs.bundlerEnv {
          name = "jekyll-gems";
          inherit ruby;
          gemfile = ./Gemfile;
          lockfile = ./Gemfile.lock;
          gemset = ./gemset.nix;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            ruby
            rubyEnv
            bundler
            bundix
            git
            pkg-config
            openssl
            zlib
            libxml2
            libxslt
            libffi
            libyaml
            cacert
          ];

          # Use gems from Nix (bundlerEnv) instead of running `bundle install`.
          shellHook = ''
            export PATH="${ruby}/bin:$PATH"
            export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt

            # Point Bundler to system gems provided by Nix
            export BUNDLE_PATH=system
            # Add bundlerEnv gems to Ruby's search path (derive API version from ruby)
            RUBY_API=$(ruby -rrbconfig -e 'print RbConfig::CONFIG["ruby_version"]')
            export GEM_PATH="${rubyEnv}/lib/ruby/gems/$RUBY_API''${GEM_PATH:+:$GEM_PATH}"

            echo "Ruby:     $(ruby -v)"
            echo "Bundler:  $(bundle -v)"
            echo "GEM_PATH: $GEM_PATH"
            echo "Ready: use 'bundle exec jekyll serve --livereload' (no bundle install)"
          '';
        };
      });
}
