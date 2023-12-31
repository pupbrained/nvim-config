# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  alternate-toggler-nvim = {
    pname = "alternate-toggler-nvim";
    version = "fe798aa9e4af26c9e33ca1add9d255209d03b108";
    src = fetchFromGitHub {
      owner = "rmagatti";
      repo = "alternate-toggler";
      rev = "fe798aa9e4af26c9e33ca1add9d255209d03b108";
      fetchSubmodules = false;
      sha256 = "sha256-7t0UJ5pIa4BAECf09EodyrXqii9nYsq2n7NDKCoXw78=";
    };
    date = "2023-08-17";
  };
  buffer-manager-nvim = {
    pname = "buffer-manager-nvim";
    version = "4fa47504a23d9a94216f02b1d84f7b0a2dbe2b72";
    src = fetchFromGitHub {
      owner = "j-morano";
      repo = "buffer_manager.nvim";
      rev = "4fa47504a23d9a94216f02b1d84f7b0a2dbe2b72";
      fetchSubmodules = false;
      sha256 = "sha256-a0REAPs0rJIWLvRNZ04ULwjNzH64hYGhrV/+i/9w/TA=";
    };
    date = "2023-11-02";
  };
  conceal-nvim = {
    pname = "conceal-nvim";
    version = "1aff9fc5d1157aef1c7c88b6df6d6db21268d00a";
    src = fetchFromGitHub {
      owner = "Jxstxs";
      repo = "conceal.nvim";
      rev = "1aff9fc5d1157aef1c7c88b6df6d6db21268d00a";
      fetchSubmodules = false;
      sha256 = "sha256-4Nhcjk89WD0Kw9iD0YsZ202tRTWlhFHxhVp2kyoju/Y=";
    };
    date = "2023-12-05";
  };
  hlchunk-nvim = {
    pname = "hlchunk-nvim";
    version = "882d1bc86d459fa8884398223c841fd09ea61b6b";
    src = fetchFromGitHub {
      owner = "shellRaining";
      repo = "hlchunk.nvim";
      rev = "882d1bc86d459fa8884398223c841fd09ea61b6b";
      fetchSubmodules = false;
      sha256 = "sha256-fvFvV7KAOo7xtOCjhGS5bDUzwd10DndAKs3++dunED8=";
    };
    date = "2023-12-11";
  };
  hoverhints-nvim = {
    pname = "hoverhints-nvim";
    version = "86fad985b91fe454469108924c1cdb378cbae1ce";
    src = fetchFromGitHub {
      owner = "soulis-1256";
      repo = "hoverhints.nvim";
      rev = "86fad985b91fe454469108924c1cdb378cbae1ce";
      fetchSubmodules = false;
      sha256 = "sha256-QQ+ISmwY6NnvzsnY2GZVxXh/2V6LYaXIjD7evScq4HQ=";
    };
    date = "2023-11-23";
  };
  lsp-lens-nvim = {
    pname = "lsp-lens-nvim";
    version = "48bb1a7e271424c15f3d588d54adc9b7c319d977";
    src = fetchFromGitHub {
      owner = "VidocqH";
      repo = "lsp-lens.nvim";
      rev = "48bb1a7e271424c15f3d588d54adc9b7c319d977";
      fetchSubmodules = false;
      sha256 = "sha256-zj/Gn/40jnDNh05OFc23LNNuFn1PnIAUDfPquEWpAlk=";
    };
    date = "2023-12-07";
  };
  modes-nvim = {
    pname = "modes-nvim";
    version = "4035a46aaabe43faf1b54740575af9dd5bb03809";
    src = fetchFromGitHub {
      owner = "mvllow";
      repo = "modes.nvim";
      rev = "4035a46aaabe43faf1b54740575af9dd5bb03809";
      fetchSubmodules = false;
      sha256 = "sha256-Kd2hf5obrPvCVLtRcFjLd75byyrB2o3uYCSEMW6IeCc=";
    };
    date = "2023-12-10";
  };
  satellite-nvim = {
    pname = "satellite-nvim";
    version = "acb185e1475a19e2538ee517fb540b82db629887";
    src = fetchFromGitHub {
      owner = "lewis6991";
      repo = "satellite.nvim";
      rev = "acb185e1475a19e2538ee517fb540b82db629887";
      fetchSubmodules = false;
      sha256 = "sha256-ouxwJP1phzC2JVOWsC7zslkrb1rmBetMvr6fVfMo284=";
    };
    date = "2023-12-28";
  };
  savior-nvim = {
    pname = "savior-nvim";
    version = "9c7df9cf02a6dd54d0ec300c0a9a7152740400b2";
    src = fetchFromGitHub {
      owner = "willothy";
      repo = "savior.nvim";
      rev = "9c7df9cf02a6dd54d0ec300c0a9a7152740400b2";
      fetchSubmodules = false;
      sha256 = "sha256-ZUJrjHDvN4Mde4D6437kjXNx4YhdXWCda+nxkwPEpr8=";
    };
    date = "2023-12-21";
  };
  statusline-lua = {
    pname = "statusline-lua";
    version = "398881da0a6dad3a5fe0f0d3fbafe1280cb1ec43";
    src = fetchFromGitHub {
      owner = "pupbrained";
      repo = "statusline.lua";
      rev = "398881da0a6dad3a5fe0f0d3fbafe1280cb1ec43";
      fetchSubmodules = false;
      sha256 = "sha256-F6VurC1Ukd3CwSdnTZX/9zjIL2VqojnqCnEDAJWn+os=";
    };
    date = "2023-10-31";
  };
  surround-ui-nvim = {
    pname = "surround-ui-nvim";
    version = "65c25088e8dbd1e098245de007498b93c694afb0";
    src = fetchFromGitHub {
      owner = "roobert";
      repo = "surround-ui.nvim";
      rev = "65c25088e8dbd1e098245de007498b93c694afb0";
      fetchSubmodules = false;
      sha256 = "sha256-7RrfLC1pEXstizHb1e0xy9WZS+YkcGnnEIQmh2TFZgk=";
    };
    date = "2023-09-09";
  };
  ultimate-autopair-nvim = {
    pname = "ultimate-autopair-nvim";
    version = "4f01418547c7e27c3aa779da8cc30c9998dc6843";
    src = fetchFromGitHub {
      owner = "altermo";
      repo = "ultimate-autopair.nvim";
      rev = "4f01418547c7e27c3aa779da8cc30c9998dc6843";
      fetchSubmodules = false;
      sha256 = "sha256-LQWKn122+aAflzrGzMhuUxHjkY6L5VzcfMfi3HQ7KSU=";
    };
    date = "2023-12-28";
  };
  veil-nvim = {
    pname = "veil-nvim";
    version = "88d5fd48e178a9996985e534cdeded0b2a421881";
    src = fetchFromGitHub {
      owner = "willothy";
      repo = "veil.nvim";
      rev = "88d5fd48e178a9996985e534cdeded0b2a421881";
      fetchSubmodules = false;
      sha256 = "sha256-nvYU6CWt9O45yQvDxqcXpwVVK4AsRiG/iu7U4twhEMY=";
    };
    date = "2023-12-25";
  };
}
