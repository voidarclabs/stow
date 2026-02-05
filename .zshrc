# Add carapace autocomplete
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# init oh my posh with theme from stow
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/zen.toml)"

# custom aliases
alias ls="lsd -l"
alias pa="sudo pacman" # compat
alias v="nvim"
alias lg="lazygit"
alias nsh="nix-shell -p"
alias vif="nvim ~/.nixos/flake.nix"
alias vic="nvim ~/.nixos/configs/common.nix"
alias vimod="nvim --cmd 'cd ~/.dotfiles/.nixos'"

source ~/.zshrc-local
