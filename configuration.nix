{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "0";
      };
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [ 
      "idle=nomwait" 
      "processor.max_cstate=1" 
      "rcu_nocbs=0-11" 
    ];
    plymouth.enable = true;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Kyiv";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "uk_UA.UTF-8";
      LC_IDENTIFICATION = "uk_UA.UTF-8";
      LC_MEASUREMENT = "uk_UA.UTF-8";
      LC_MONETARY = "uk_UA.UTF-8";
      LC_NAME = "uk_UA.UTF-8";
      LC_NUMERIC = "uk_UA.UTF-8";
      LC_PAPER = "uk_UA.UTF-8";
      LC_TELEPHONE = "uk_UA.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
    };
    
    displayManager = {
      sddm.enable = true;
      autoLogin = {
        enable = true;
        user = "gurov";
      };
    };
    
    desktopManager.plasma6.enable = true;
    printing.enable = true;
    flatpak.enable = true;
    
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
    
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };

  security.rtkit.enable = true;

  users.users.gurov = {
    isNormalUser = true;
    description = "Gurov";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      ayugram-desktop
      telegram-desktop
      viber
      spotify
      obs-studio
      clang
      llvm
      mold
      jdk
      prismlauncher
      vlc
      easyeffects
      corefonts
      nerd-fonts.hack
      (discord-canary.override { 
        withOpenASAR = true; 
        withVencord = true; 
      })
    ];
  };

  programs = {
    firefox.enable = true;
    gamemode.enable = true;
    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [ kdePackages.breeze ];
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      neovim
      git
      fastfetch
      ripgrep
      wl-clipboard
      unrar
      p7zip
      calf
      eza
      aria2
      zoxide
    ];
    
    plasma6.excludePackages = with pkgs.kdePackages; [
      khelpcenter
      elisa
    ];
  };

  nixpkgs.config.allowUnfree = true;
  
  virtualisation.waydroid.enable = true;
  zramSwap.enable = true;
  
  nix.settings.experimental-features = [ 
    "nix-command" 
    "flakes" 
  ];

  system.stateVersion = "25.05";
}
