{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/refs/tags/22.05.tar.gz") {} }:

with pkgs;

mkShell rec {
  venvDir = "./.VENV";
  buildInputs = [
    cairo
    zlib
    poetry
    python310.pkgs.venvShellHook
  ];
  postShellHook = ''
    export PS1="\$(__git_ps1) $PS1"
    export LD_LIBRARY_PATH=${stdenv.cc.cc.lib}/lib/:${cairo}/lib/:${zlib}/lib:$LD_LIBRARY_PATH
    poetry install
    poetry install -E doc
    spacy validate | grep en_core_web_sm || poetry run pip install https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-3.3.0/en_core_web_sm-3.3.0.tar.gz
  '';
}
