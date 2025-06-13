{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    jekyll
    rubyPackages.jekyll-feed
  ];
}