# Add carapace autocomplete
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# init oh my posh with theme from stow
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/zen.toml)"

# custom aliases
alias ls="lsd -l"
alias pa="sudo pacman"
alias v="nvim"
alias lg="lazygit"
alias n="nvim"
alias vinix="nvim ~/.nixos/configuration.nix"
alias vif="nvim ~/.nixos/flake.nix"
alias nrs="sudo nixos-rebuild switch --impure --flake ~/.nixos#mobile02"
