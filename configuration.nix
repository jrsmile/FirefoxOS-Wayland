{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "enigma";
  time.timeZone = "Africa/Casablanca";
  system.stateVersion = "25.11";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      open = true;
    };
  };

  networking.networkmanager.enable = true;
  security.rtkit.enable = true;
  services = {
    dbus = {
      enable = true;
      implementation = "dbus";
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    seatd.enable = true;
    xserver.videoDrivers = [ "nvidia" ];
  };

  fonts = {
    packages = with pkgs; [ jetbrains-mono inter ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrains Mono" ];
        sansSerif = [ "Inter" ];
        serif = [ "Inter" ];
      };
    };
  };

  users.users.codotaku = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "seat" "input" ];
  };

  environment.systemPackages = with pkgs; [
    nixpkgs-fmt
    nixd
    direnv
    gpu-screen-recorder
    mpv
  ];

  programs = {
    firefox.enable = true;
    gpu-screen-recorder.enable = true;
    git = {
      enable = true;
      config = {
        user.name = "CodesOtakuYT";
        user.email = "taouaouilyas@gmail.com";
        init.defaultBranch = "main";
      };
    };
  };

  services = {
    cage = {
      enable = true;
      user = "codotaku";
      program = "${pkgs.firefox}/bin/firefox --kiosk http://127.0.0.1:8080";
    };
    code-server = {
      enable = true;
      host = "127.0.0.1";
      port = 8080;
      auth = "none";
      user = "codotaku";
      extraEnvironment = {
        XDG_RUNTIME_DIR = "/run/user/1000";
        WAYLAND_DISPLAY = "wayland-0";
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ 
      xdg-desktop-portal-wlr 
      xdg-desktop-portal-gtk 
    ];
    config.common.default = "*";
  };
}