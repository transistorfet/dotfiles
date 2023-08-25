
Programs I Use
--------------

On Debian (desktop):
    - i3 (window manager)
    - i3status-rust (desktop status line)
    - nitrogen (x background setter)
    - rofi (on-screen menu)
    - dolphin (file manager)
    - konsole (terminal emulator)
    - firefox
    - gvim
    - bash
    - xmms2 (music player)
    - pavucontrol (audio volumes and input switching)

Remote:
    - tmux

On Mac (for work):
    - iTerm2 (terminal emulator)
    - Hex Fiend (hex editor)
    - LICEcap (screen recorder for demos)

Fonts:
    - Incosolata (konsole)
    - Overpass Mono (gvim)

Additional Tools:
    - kicad (schematic and PCB editor)
    - okteta (hex editor)
    - tigervnc-standalone-server (remote gui)
    - tigervnc-viewer
    - deluge (torrents)
    - vlc (video player)
    - wireshark


Installing
----------

On Debian
```
apt-get install i3 i3status rofi dolphin konsole vim-gtk3 vim-scripts neovim neovim-qt nitrogen net-tools netcat python3-serial tmux gxmms2 xmms2 jq
apt-get install gcc-m68k-linux-gnu gcc-arm-none-eabi gdb-multiarch ocaml opam
apt-get install kicad kicad-libraries iverilog yosys nextpnr-generic nextpnr-ice40-qt gtkwave
apt-get install fontconfig fonts-agave fonts-ancient-scripts fonts-anonymous-pro fonts-courier-prime fonts-dejavu fonts-dejavu-extra fonts-elusive-icons fonts-ferrite-core fonts-font-awesome fonts-fork-awesome fonts-glasstty fonts-hack fonts-hermit fonts-ibm-plex fonts-inconsolata fonts-lato fonts-lobster fonts-lyx fonts-material-design-icons-iconfont fonts-materialdesignicons-webfont fonts-monofur fonts-monoid fonts-noto fonts-noto-cjk fonts-noto-cjk-extra fonts-noto-color-emoji fonts-noto-core fonts-noto-extra fonts-noto-hinted fonts-noto-mono fonts-noto-ui-core fonts-noto-ui-extra fonts-noto-unhinted fonts-opensymbol fonts-powerline fonts-proggy fonts-quicksand fonts-sil-gentium fonts-spleen fonts-staypuft fonts-symbola fonts-terminus
mkdir ~/.vimundo
```
- install rust and rust-analyzer from rustup: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- install i3status-rust from source
- manually install Firefox and Signal binaries

On Mac
```
brew install bash bash-completion@2
brew install binutils nvm ocaml opam
brew install --cask iterm2 hex-fiend licecap macvim
brew install --cask tigervnc-viewer wireshark
brew install --cask font-azeret-mono font-b612-mono font-cousine font-incosolata
```


Alternate Programs To Try
-------------------------

Terminal Emulators:
    * kitty
        - fonts don't match other programs, but I haven't set it up properly
    * alactritty
    * stterm
        - it doesn't support scrollback without a patch, and that's a critical feature for me

Editors:
    * neovim
        - last time I tried it, neovim-qt was better
        - I still can't use the same fonts as gvim, or if I can, they look different

Shells:
    * zsh
        - I don't like the double tab autofill behaviour and haven't tried configuring it differently
    * fish
        - it tries to do too much for me and can be distracting

