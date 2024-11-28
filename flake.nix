{
  outputs = { self }: {
    homeConfigs.vim = import ./vim.nix;
    homeConfigs.zsh = import ./zsh.nix;
  };
}
