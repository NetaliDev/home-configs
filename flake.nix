{
  outputs = { self }: {
    homeConfigs.vim = import ./configs/vim.nix;
    homeConfigs.zsh = import ./configs/zsh.nix;
  };
}
