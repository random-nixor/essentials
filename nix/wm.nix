{ config, pkgs, ... }:

{
  fonts = {
    fonts = with pkgs; [
      font-awesome-ttf
    ];
  };

  environment.systemPackages = with pkgs; [
    bar-xft                            # Lightweight xcb based bar
    compton                            # Windowing system for niceness
    dmenu                              # Application launcher
    feh                                # Wallpaper manager
    python27Packages.udiskie
    unclutter                          # Mouse hider
    xlaunch                            # Manual starting of X
    xlibs.xmodmap                      # Keyboard reconfiguration
    xmonad-with-packages               # Tiling window manager
    xorg.xbacklight                    # Backlight modification utility
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    font-awesome-ttf = pkgs.font-awesome-ttf.overrideDerivation (attrs: {
      name = "font-awesome-4.5.0";
      src = pkgs.fetchurl {
        url = "https://github.com/FortAwesome/Font-Awesome/archive/v4.5.0.zip";
        sha256 = "04jp213iwpc8bfn0vgkf36pwafwcgx65gvam7wfd36522l19ldy6";
      };
    });
  };

  security.setuidPrograms = [ "xlaunch" ];

  services = {
    # Disk mounting
    udisks2.enable = true;

    # Enable the X11 windowing system.
    xserver = {
      enableTCP = false;
      exportConfiguration = false;
      enable = true;
      layout = "us";
      xkbOptions = "caps:escape";

      # Setup daemons for composting and wallpaper
      displayManager = {
        sessionCommands = ''
          xset r rate 300 30
          unclutter -grab &
          udiskie &
          compton --config /dev/null &
          feh --randomize --bg-fill ~/Pictures/Wallpapers/* &
        '';
      };

      # Disable default stuff
      desktopManager = {
        xterm.enable = false;
        xfce.enable = false;
      };

      # Enable xmonad
      windowManager = {
        xmonad.enable = true;
        xmonad.enableContribAndExtras = true;
        default = "xmonad";
      };
    };
  };
}