The Wayfire Wiki https://github.com/WayfireWM/wayfire/wiki links an example wayfire.ini that you can use to customize your shortcuts in ~/.config/wayfire.ini. You can thereby override sections of `/etc/wayfire/defaults.ini` and `/etc/wayfire/template.ini`. To add plugins to the Raspberry Pi, you'd want to copy [core] in it's entirety and then add to it. Same with [expo] and [grid]. Copy the [command] section from template.ini and make your command/binding line-pairs.

- Take note of sections and customized for the Pi, like [autostart] [autostart-static]. RPiOS sets `autostart_wf_shell = false` for example and has it's own jiggery pokery involving `wf-panel-pi`, `pcmanfm --desktop --profile LXDE-pi` and `lxsession-xdg-autostart` instead. Any options you set should respect the defaults.

Available keys for mapping: https://github.com/alexherbo2/wayfire-resources/blob/453eee535c409e9502ac9dbd28d9867453f9789d/docs/keys.txt 

Certain plugins work ootb when listed in your plugins. No further configuration is necessary (however some don't seem to function on the Pi): 
https://github.com/WayfireWM/wayfire/wiki/Bindings-available-by-default

