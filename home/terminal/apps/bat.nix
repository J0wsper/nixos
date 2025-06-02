{config, pkgs, lib, inputs, ...}:

# TODO: Set this theme to Tokyo Night
{
    programs.bat = {
        enable = true;
        themes = {
            catppuccin-mocha = {
                src = inputs.catppuccin-bat;
                file = "themes/Catppuccin Mocha.tmTheme";
            };
        };
        config.theme = "catppuccin-mocha";
    };
}
