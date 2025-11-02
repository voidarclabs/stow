{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  # Allow Nix command and flakes (ofc)
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; // you want this

# Allow unfree packages
  nixpkgs = { 
	  config = {
		  allowUnfree = true;
		  packageOverrides = pkgs: {
			  unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {}; #to install packages from unstable, put "unstable." before the package
		  };
	  };
  };

# Boot
  boot = {
    loader = {
	timeout = 2;
  	  efi = {
  		  canTouchEfiVariables = true; # allows dual booting windows i think
  	  };
  	  grub = {
  		  efiSupport = true;
  		  device = "nodev";
  		  theme = pkgs.catppuccin-grub; #nice grub theme
  	  };
    };
    plymouth = {
	enable = true;
      theme = "catppuccin-mocha"; # nice plymouth theme
      themePackages = with pkgs; [
        # By default we would install all themes
        (catppuccin-plymouth.override {
          variant = "mocha";
        })
      ];
    };
  };

# Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking settings
  networking.hostName = "mobile02"; # Define your hostname. #change this to whatever u want ur hostname to be (will kick you off wifi)
  networking.networkmanager.enable = true; #nmtui the goat

  # Enable bluetooth 
  hardware.bluetooth.enable = true;

  # Opengl and vulkan
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ # change if not intel graphics
      vaapiIntel
      vaapiVdpau
    ];
  };

  # Set your time zone.
  time.timeZone = "Europe/London"; # obvious

  # Locale
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Windowing Systems
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    theme = "catppuccin-mocha"; # login theme
    package = pkgs.kdePackages.sddm;
  };
  programs.hyprland.enable = true; # hyprland and io management
  security.polkit.enable = true;

  # Keymap
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };
  console.keyMap = "uk";

  # Enable CUPS to print documents. (idk why this is here)

  # Pipewire
  services.pulseaudio.enable = false; # fuck pulseaudio
  security.rtkit.enable = true;
  services.pipewire = { # my goat pipewire
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Local User
  users.users.user01 = { # change user01 to what u want ur username to be
    isNormalUser = true;
   shell = pkgs.zsh; # best shell ovs
    description = "user01"; # useless lol
    extraGroups = [ "input" "networkmanager" "docker" "wheel" ]; # docker not needed, but incase u want to install
    packages = with pkgs; [ # packages that are installed only for ur user (if you switch user then these wont be available)
        # Ricing
        bibata-cursors
        catppuccin-gtk
	# (builtins.getFlake "/etc/nixos/way-edges").packages.${pkgs.system}.default (ignore this)
	waybar
	swaynotificationcenter
	fuzzel
        swww # to set wallpapers, "swww img (path to img)
        oh-my-posh # terminal shell

        # Terminal
        carapace # better autocomplete
        kitty
        github-cli
        light
	bluetuith # bluetooth tui if u want it
        wget
	playerctl
        git
        fastfetch
        lsd # better ls
	# juce (ignore)
        stow # for config management
	fzf
	ripgrep # nvim stuff
        zsh-autocomplete
        # (if u want) nodejs
        lazygit
        tailscale

        # Thunar stuff
        xfce.thunar
        xfce.thunar-volman
        xfce.thunar-vcs-plugin
        xfce.thunar-archive-plugin

        # Apps
        pavucontrol
        firefox
        # tor-browser (if u want)
	# gotify-desktop (ignore this, it's useless)
	techmino
        mpv
        prismlauncher
        delfin
        libreoffice-qt6
        syncthing
	xremap
        blueman
    ];
  };

# Zsh
  programs.zsh = { # terminal config
	  enable = true;
	  enableCompletion = true;
	  enableBashCompletion = true;
	  autosuggestions.enable = true;
	  syntaxHighlighting.enable = true;
	  histSize = 10000;
	  ohMyZsh = {
		  enable = true;
		  plugins = [ "git" "dirhistory" "history" ];
	  };
  };

  # Ntfy Notifcations (doesnt work, feel free to delete)
  systemd.user.services.ntfy-listener = {
	  description = "NTFY listener for Hyprland notifications";
	  after = [ "network-online.target" ];
	  wants = [ "network-online.target" ];

	  serviceConfig = {
		  ExecStart = "/home/user01/.config/scripts/.venv/bin/python /home/user01/.config/scripts/notify.py";
		  Restart = "always";
		  RestartSec = 5;
		  Environment = "DISPLAY=:0 XDG_RUNTIME_DIR=/run/user/%U PATH=/run/current-system/sw/bin";
		  WorkingDirectory = "/home/user01"; # optional, but can help
	  };

	  wantedBy = [ "default.target" ];
  };

# User programs
  programs.steam.enable = true;

# User Services (disable some of these idk)
  services.gvfs.enable = true;
  services.tailscale.enable = true;
  services.printing.enable = true;
  services.upower.enable = true;
  services.openssh.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
	  nerd-fonts.fira-mono # best terminal font
  ];

  fonts.fontconfig.defaultFonts.serif = [ "Fira Mono Nerd Font" ];
   environment.systemPackages = with pkgs; [ # packages that are installed systemwide (dw u can still use user packages with sudo)

      # Catppuccin sddm theme
      (pkgs.catppuccin-sddm.override {
        flavor = "mocha";
        font = "Fira Mono Nerd Font";
        fontSize = "11";
        background = null;
      })
      # Terminal things
      (pkgs.symlinkJoin {
      name = "nvim-with-lsp";
      paths = [ pkgs.neovim ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/nvim \
          --prefix PATH : ${pkgs.lib.makeBinPath [ # put lsps and stuff in this list, won't be accessible to anything but nvim (need to precede with pkgs.)
            pkgs.lua-language-server
	    pkgs.vscode-langservers-extracted
	    pkgs.emmet-ls
	    pkgs.ripgrep
            pkgs.typescript-language-server
            pkgs.tailwindcss-language-server
	    pkgs.stylua
          ]}
      '';
    })
      vim # dont remove or u die (nano is always installed just in case)
      unzip
      python310 # Its python like come on

      # Graphics Drivers
      mesa
      vulkan-tools

      # FileSystem Dependancies
      gvfs

      # C copmpiler
      clang

      # XDG Desktop Portal Etc
      xdg-desktop-portal
      xdg-desktop-portal-hyprland

      # Other things (from gnome)
      glib
      gnutls
      appimage-run
      libnotify
      gsettings-desktop-schemas
   ];

  # The comment (don't ever change this number, its important)
  system.stateVersion = "25.05"; # Did you read the comment?

}
