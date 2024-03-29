The Wayfire Wiki https://github.com/WayfireWM/wayfire/wiki links an example wayfire.ini that you can use to customize your shortcuts in ~/.config/wayfire.ini. You can add to and override sections of `/etc/wayfire/defaults.ini` and `/etc/wayfire/template.ini`. 

- Take note of sections and customized for the Pi, like [autostart] [autostart-static]. RPiOS sets `autostart_wf_shell = false` for example and has it's own jiggery pokery involving `wf-panel-pi`, `pcmanfm --desktop --profile LXDE-pi` and `lxsession-xdg-autostart` instead. Any options you set should respect the defaults.

To add plugins to Raspberry Pi OS, you'd want to incorporate and extend [core], adding the names to the list of plugins. Certain plugins work ootb when listed in your plugins. See [default keybindings](https://github.com/WayfireWM/wayfire/wiki/Bindings-available-by-default). Some of the default keybinds don't seem to work and it may be that some plugins need to be sourced from https://github.com/seffs/wayfire-plugins-extra-raspbian instead. 

Available keys for mapping: https://github.com/alexherbo2/wayfire-resources/blob/453eee535c409e9502ac9dbd28d9867453f9789d/docs/keys.txt 

