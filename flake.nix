{
  outputs = { self }: {
    homeConfigs.screen = import ./configs/screen.nix;
    homeConfigs.vim = import ./configs/vim.nix;
    homeConfigs.zsh = import ./configs/zsh.nix;
  };
}
