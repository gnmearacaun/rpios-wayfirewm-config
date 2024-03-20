This is a summary of my approach.

Start at the wiki https://github.com/WayfireWM/wayfire/wiki

They link an example wayfire.ini that you can use to customize your shortcuts in ~/.config/wayfire.ini. You can thereby override sections of /etc/wayfire/defaults.ini and /etc/wayfire/template.ini

To add plugins, you'd want to copy [core] in it's entirety and then add to it. Same with [expo] and [grid]. Take care not to mess with anything rpi-customized. [autostart] [autostart-static] come to mind. RPiOS sets `autostart_wf_shell = false` for example and has it's own jiggery pokery involving `wf-panel-pi`, `pcmanfm --desktop --profile LXDE-pi` and `lxsession-xdg-autostart` instead.

Copy the [command] section from template.ini and make your command/binding line-pairs. Available keys are here: https://github.com/alexherbo2/wayfire-resources/blob/453eee535c409e9502ac9dbd28d9867453f9789d/docs/keys.txt 

Certain plugins have default bindings that are available when listed in your plugins. No further configuration is necessary. See here: 
https://github.com/WayfireWM/wayfire/wiki/Bindings-available-by-default

- Note: not all the default bindings work, some may have been disabled by RPiOS 

Gotta say, this new desktop by the Raspberry Pi Foundation is a thing of beauty with the pivot to Wayland, pipewire and networkManager. So smooth and efficient on resources. <3
