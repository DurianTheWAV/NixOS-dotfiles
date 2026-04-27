{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    
    # Home Manager as a NixOS module (flake-based)
    #inputs.home-manager.nixosModules.home-manager
    ./modules/hyprland.nix
    ./fonts.nix
    ./gaming.nix
  ];
  ## -------------------------
  ## Bootloader
  ## -------------------------
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  ## ------------------------
  ## Kernel
  ## ------------------------
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  ## -------------------------
  ## Nix settings
  ## -------------------------
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    optimise.automatic = true;
  };
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    dates = "daily";
    allowReboot = false;
  };
  nixpkgs.config.allowUnfree = true;

  # systemd services for automatic updates with flakes enabled
  systemd.services.nixos-flake-update = {
    description = "Update NixOS flake inputs";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      WorkingDirectory = "/etc/nixos";
      ExecStart = "${pkgs.nixVersions.stable}/bin/nix flake update";
    };
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };
  systemd.timers.nixos-flake-update = {
    description = "Daily NixOS flake update timer";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "daily";
      OnBootSec = "15min";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
  };

  services.displayManager.sddm.autoNumlock = true;

  ## -------------------------
  ## Networking
  ## -------------------------
  networking.hostName = "WAV";
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  programs.mtr.enable = true;
  # Set your time zone.
  time.timeZone = "Europe/Zurich";

/* ## ----------------------
  ## FIREWALL
  ## ---------------------
  networking.firewall = {
    enable =true;
    allowPing = false;
    allowedTCPPorts = [ 22 ];
    trustedInterfaces = [ "lo"];
  }; */

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_CH.UTF-8";

  # Enable support for Korean locales
  i18n.extraLocales = [
    "ko_KR.UTF-8/UTF-8"
  ];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_CH.UTF-8";
    LC_IDENTIFICATION = "fr_CH.UTF-8";
    LC_MEASUREMENT = "fr_CH.UTF-8";
    LC_MONETARY = "fr_CH.UTF-8";
    LC_NAME = "fr_CH.UTF-8";
    LC_NUMERIC = "fr_CH.UTF-8";
    LC_PAPER = "fr_CH.UTF-8";
    LC_TELEPHONE = "fr_CH.UTF-8";
    LC_TIME = "fr_CH.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "ch";
    variant = "fr";
  };

  # Configure console keymap
  console.keyMap = "fr_CH";

  ## ------------------------------------
  ## Display
  ## ------------------------------------
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  ## ---------------------------------------
  ## Other Desktops
  ## ---------------------------------------
  programs.hyprland.enable = false;

  ## -------------------------
  ## Audio
  ## -------------------------
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  ## -------------------------
  ## GPU drivers
  ## -------------------------
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      vulkan-loader
      intel-compute-runtime
    ];
  };

  ## -------------------------
  ## Shells (for zsh)
  ## -------------------------
  programs.zsh.enable = true;

  ## -------------------------
  ## Users
  ## -------------------------
  users.users.durian = {
    isNormalUser = true;
    description = "Dorian Luyet";
    extraGroups = [ "networkmanager" "wheel" "docker" "kvm" ];
    shell = pkgs.zsh;
  };

  ## -------------------------
  ## System packages
  ## -------------------------
  environment.systemPackages = with pkgs; [
    wget
    kitty
    lsd
    zsh
    zsh-completions
    zsh-syntax-highlighting
    zsh-history-substring-search
    fastfetch
    python314
    nodejs_24
    vlc
    fzf
  ];

  # Allow Appimages
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # Enable Flatpak
  services.flatpak.enable = true;

  # Enable firmware updates
  services.fwupd.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable VMware
  virtualisation.vmware.host.enable = true;
  # Enable Docker
  virtualisation.docker.enable = true;

  # Enable Ollama
  services.ollama = {
    enable = true;
    loadModels = [ "llama3.2:3b" "gemma3:4b" ];
  };

  ## -------------------------
  ## Performance
  ## -------------------------
  zramSwap = {
    enable = true;
    algorithm = "lz4";
  };

  ## -------------------------
  ## NixOS release
  ## -------------------------
  system.stateVersion = "25.11"; # Did you read the comment?

}
