{ ... }:

{
  home.file.".screenrc".text = ''
    caption always '%{= BW}%H%{-} %D, %d.%m.%Y %c:%s %= %-w  %{= d}%n %t%{-}%+w'
    defscrollback 100000
  '';
}
