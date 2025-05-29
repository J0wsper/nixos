{config, pkgs, lib, inputs, ...}:

{
    programs.btop = {
        enable = true;
        settings = {
            color_theme = "tomorrow-night";
            theme_background = true;
        };
    };
}
