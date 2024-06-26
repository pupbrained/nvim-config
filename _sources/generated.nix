# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  alternate-toggler-nvim = {
    pname = "alternate-toggler-nvim";
    version = "819800304d3e8e575fd6aa461a8bcf2217e1cfb6";
    src = fetchFromGitHub {
      owner = "rmagatti";
      repo = "alternate-toggler";
      rev = "819800304d3e8e575fd6aa461a8bcf2217e1cfb6";
      fetchSubmodules = false;
      sha256 = "sha256-+UXbgVRki1CGRDHRNrnXOIvzr+0lCAftzGsGVzVQwL4=";
    };
    date = "2024-06-04";
  };
  buffer-manager-nvim = {
    pname = "buffer-manager-nvim";
    version = "fd36131b2b3e0f03fd6353ae2ffc88cf920b3bbb";
    src = fetchFromGitHub {
      owner = "j-morano";
      repo = "buffer_manager.nvim";
      rev = "fd36131b2b3e0f03fd6353ae2ffc88cf920b3bbb";
      fetchSubmodules = false;
      sha256 = "sha256-abe9ZGmL7U9rC+LxC3LO5/bOn8lHke1FCKO0V3TZGs0=";
    };
    date = "2024-05-07";
  };
  comment-box-nvim = {
    pname = "comment-box-nvim";
    version = "06bb771690bc9df0763d14769b779062d8f12bc5";
    src = fetchFromGitHub {
      owner = "LudoPinelli";
      repo = "comment-box.nvim";
      rev = "06bb771690bc9df0763d14769b779062d8f12bc5";
      fetchSubmodules = false;
      sha256 = "sha256-fbuN2L8M6AZRvIiKy9ECLgf3Uya6g5znfDaCgVF3XKA=";
    };
    date = "2024-02-03";
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
  glow-hover = {
    pname = "glow-hover";
    version = "16be926f16e72fe9e3b137d9c261a805e0eec3ca";
    src = fetchFromGitHub {
      owner = "Arian8j2";
      repo = "glow-hover.nvim";
      rev = "16be926f16e72fe9e3b137d9c261a805e0eec3ca";
      fetchSubmodules = false;
      sha256 = "sha256-8oVw/4JjtS6wIzXvnqt97BUBx+TmnYvRS5pzK9prexM=";
    };
    date = "2024-06-04";
  };
  hover-nvim = {
    pname = "hover-nvim";
    version = "4339cbbcb572b1934c53dcb66ad4bf6a0abb7918";
    src = fetchFromGitHub {
      owner = "lewis6991";
      repo = "hover.nvim";
      rev = "4339cbbcb572b1934c53dcb66ad4bf6a0abb7918";
      fetchSubmodules = false;
      sha256 = "sha256-Q1k4ddyMlPSp2rX5CjxS70JJmRDbBHCowlu2CTuq0No=";
    };
    date = "2024-06-12";
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
    version = "326cff3282419b3bcc745061978c1e592cae055d";
    src = fetchFromGitHub {
      owner = "mvllow";
      repo = "modes.nvim";
      rev = "326cff3282419b3bcc745061978c1e592cae055d";
      fetchSubmodules = false;
      sha256 = "sha256-z1XD0O+gG2/+g/skdWGC64Zv4dXvvhWesaK/8DcPF/E=";
    };
    date = "2024-06-06";
  };
  neotab-nvim = {
    pname = "neotab-nvim";
    version = "6c6107dddaa051504e433608f59eca606138269b";
    src = fetchFromGitHub {
      owner = "kawre";
      repo = "neotab.nvim";
      rev = "6c6107dddaa051504e433608f59eca606138269b";
      fetchSubmodules = false;
      sha256 = "sha256-bSFKbjj8fJHdfBzYoQ9l3NU0GAYfdfCbESKbwdbLNSw=";
    };
    date = "2024-02-23";
  };
  rustaceanvim = {
    pname = "rustaceanvim";
    version = "54908384f1b7932576a92caa645681026d8b84e1";
    src = fetchFromGitHub {
      owner = "mrcjkb";
      repo = "rustaceanvim";
      rev = "54908384f1b7932576a92caa645681026d8b84e1";
      fetchSubmodules = false;
      sha256 = "sha256-dDtdRV9NPb/hf/yhH6X+2KItYAzzJFA0KzvIfnKXIrs=";
    };
    date = "2024-06-21";
  };
  savior-nvim = {
    pname = "savior-nvim";
    version = "b5ab8a692ab1b9ed911b7e43237f84d294fd6df3";
    src = fetchFromGitHub {
      owner = "willothy";
      repo = "savior.nvim";
      rev = "b5ab8a692ab1b9ed911b7e43237f84d294fd6df3";
      fetchSubmodules = false;
      sha256 = "sha256-rlcX7Tkc/yUBD4ZZ0Zx3ywC2GU8W+Rf4B9G4EA5HENo=";
    };
    date = "2024-04-24";
  };
  ultimate-autopair-nvim = {
    pname = "ultimate-autopair-nvim";
    version = "035d92eab05ac1390afef7204e3fcad9a50fa443";
    src = fetchFromGitHub {
      owner = "altermo";
      repo = "ultimate-autopair.nvim";
      rev = "035d92eab05ac1390afef7204e3fcad9a50fa443";
      fetchSubmodules = false;
      sha256 = "sha256-+gnrKGjmILCwTsZ/RbdB0f2DRKcg6mlY6dRCSrOr1CA=";
    };
    date = "2024-06-10";
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
  vgit-nvim = {
    pname = "vgit-nvim";
    version = "8caecf06c8fede4857568f64ff4349b6945362f0";
    src = fetchFromGitHub {
      owner = "tanvirtin";
      repo = "vgit.nvim";
      rev = "8caecf06c8fede4857568f64ff4349b6945362f0";
      fetchSubmodules = false;
      sha256 = "sha256-HLKC4tHiRNXq158JV0gArCnGGHdyfApC21p7jLjKhdU=";
    };
    date = "2024-06-06";
  };
  wezterm-nvim = {
    pname = "wezterm-nvim";
    version = "f73bba23ab4becd146fa2d0a3a16a84b987eeaca";
    src = fetchFromGitHub {
      owner = "willothy";
      repo = "wezterm.nvim";
      rev = "f73bba23ab4becd146fa2d0a3a16a84b987eeaca";
      fetchSubmodules = false;
      sha256 = "sha256-FeM5cep6bKCfAS/zGAkTls4qODtRhipQojy3OWu1hjY=";
    };
    date = "2024-06-01";
  };
  wtf-nvim = {
    pname = "wtf-nvim";
    version = "51c6bc3fa0d60434bae610c969400e656ce2faaa";
    src = fetchFromGitHub {
      owner = "pupbrained";
      repo = "wtf.nvim";
      rev = "51c6bc3fa0d60434bae610c969400e656ce2faaa";
      fetchSubmodules = false;
      sha256 = "sha256-3icb5uhA7tyZgtSGljEPROQ373LRYz9KJHXXmYrjtfI=";
    };
    date = "2024-04-24";
  };
}
