{ inputs, lib, pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    (pkgs.writeShellScriptBin "qtileway" ''
        export NIXOS_OZONE_WL="1"
        export _JAVA_AWT_WM_NONREPARENTING="1"
        export GDK_BACKEND="wayland,x11"
        export MOZ_ENABLE_WAYLAND="1"
        export MOZ_DBUS_REMOTE="1"
        export MOZ_USE_XINPUT2="1"
        export XDG_SESSION_TYPE="wayland"
        export XDG_CURRENT_DESKTOP="qtile"
        ${pkgs.dbus}/bin/dbus-run-session ${config.services.xserver.windowManager.qtile.finalPackage}/bin/qtile start -b wayland
        '')
        ];

        programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

        services = {
            dbus.enable = true;
            gnome.gnome-keyring.enable = true;
            xserver = {
            enable = true;
            displayManager.startx.enable = true;
            windowManager.qtile = {
                enable = true;
                extraPackages = python3Packages: with python3Packages; [
                    qtile-extras
                ];
            };
            };
            libinput.enable = true;
            greetd = {
            enable = true;
            settings = {
                default_session = {
                command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd qtileway";
                user = "greeter";
                };
            };
            };
        };

        systemd.services.greetd.serviceConfig = {
            Type = "idle";
            StandardInput = "tty";
            StandardOutput = "tty";
            StandardError = "journal"; # Without this errors will spam on screen
            # Without these bootlogs will spam on screen
            TTYReset = true;
            TTYVHangup = true;
            TTYVTDisallocate = true;
        };

        programs.light.enable = true;

        security.pam.services.swaylock = {};

        xdg.portal = {
        enable = true;
            extraPortals = [
            pkgs.xdg-desktop-portal-wlr
            pkgs.xdg-desktop-portal-gtk
            ];
            config = {
            qtile.default = ["wlr" "gtk"];
            };
        };
}