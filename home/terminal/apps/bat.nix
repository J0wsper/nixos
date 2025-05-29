{config, pkgs, lib, inputs, ...}:

{
    programs.bat = {
        enable = true;
        themes = {
            tomorrow-night-bright = {
                src = inputs.tomorrow-bat;
                file = "Tomorrow Night Bright.tmTheme";
            };
        };
        config.theme = "tomorrow-night-bright";
    };
}
