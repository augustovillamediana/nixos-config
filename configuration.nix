# Archivo de configuración
# Aquí se define que se va a instalar en el sistema
# La ayuda se puede encontrar corriendo ‘nixos-help’.

{ config, pkgs, ... }:

{
  imports =
    [ # Se incluye los resultados del escaneo de hardware
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  ## Seccion de los Drivers Nvidia
  # OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Cargar los drivers para Xorg y Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Se requiere Modesetting.
    modesetting.enable = true;

  # Utiliza el módulo del núcleo de código abierto de NVidia (No confundir con el controlador de código abierto de terceros "nouveau").
  # El soporte está limitado a las arquitecturas Turing y posteriores. La lista completa de GPUs compatibles se encuentra en:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
  # Solo está disponible a partir del controlador 515.43.04 o posterior.
  # No lo deshabilites a menos que tu GPU no sea compatible o tengas una buena razón para hacerlo."
    open = false;

    # Activa el menu de opciones de nvidia, se accede corriendo: `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };  
  ## End of Nvidia Drivers

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  services.connman.enable = true;

  # Set your time zone.
  time.timeZone = "America/Argentina/Buenos_Aires";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_AR.UTF-8";
    LC_IDENTIFICATION = "es_AR.UTF-8";
    LC_MEASUREMENT = "es_AR.UTF-8";
    LC_MONETARY = "es_AR.UTF-8";
    LC_NAME = "es_AR.UTF-8";
    LC_NUMERIC = "es_AR.UTF-8";
    LC_PAPER = "es_AR.UTF-8";
    LC_TELEPHONE = "es_AR.UTF-8";
    LC_TIME = "es_AR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Enlightenment Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.enlightenment.enable = true;

  # Enable acpid
  services.acpid.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "es";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "es";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gus = {
    isNormalUser = true;
    description = "gus";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [

      # Internet
      firefox
      yt-dlp

      # Terminal
      neofetch
      vim

      # Multimedia
      gimp
      krita
      vlc
      libsForQt5.kdenlive
      obs-studio

      # Desarrollo
      git
      vscodium
      hugo

      # Juegos
      steam

      
      # Otros
      wineWowPackages.stable
      winetricks




    ];
  };


  

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "gus";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    libsForQt5.xp-pen-g430-driver
    lf
    p7zip
    conda
    htop
    python38Full
    #opentabletdriver
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  # Automatic Garbage Collection
  nix.gc = {
                automatic = true;
                dates = "weekly";
                options = "--delete-older-than 7d";
        };
  hardware.opentabletdriver.enable = true;

  # Esta seccion es para cargar los discos extras de linux y windows, la primera seccion es la de windows:

  fileSystems."windows" = {
  device = "/dev/sdc2";  # Este depende de cual sea el sitio en el que este, no por el ID del disco
  fsType = "ntfs-3g";   # Se requiere "ntfs-3g" para cargar el sistema de archivos NTFS
  mountPoint = "/home/gus/windows";  # El punto en el que se carga el disco
  };


home-manager.users.gus = { pkgs, ... }: {
  home.packages = [ pkgs.atool pkgs.httpie ];

programs.git = {
    enable = true;
    extraConfig = {
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
    };
  };


  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "23.05";
};

 
}

