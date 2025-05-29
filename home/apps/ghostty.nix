{ config, pkgs, lib, ...}:

{
    programs.ghostty = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        settings = {
            theme = "Tomorrow Night Bright";
        };
    };
}
