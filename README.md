# Custom-Pages-for-HASwitchplate
Custom pages for [HASwitchplate](https://github.com/aderusha/HASwitchPlate) created by @aderusha

Special thanks to @aderusha for creating HASwitchPlate and @madrian for spending hours of beta testing with me. 

**Important:** You need to go through the basic setup of [HASwitchPlate](https://github.com/aderusha/HASwitchPlate) from @aderusha to use these custom Pages. Instead of flashing the original HASwitchPlate.tft you can use the provided .tft in this repository. 
If you renamed your HASP Node and therefore isn't called *plate01* you have to change every MQTT topic in the config files manually.
This will replace your all your previous settings of page 3,(4),6 and 8. Backup your existing files if you ever need them again. 

Once finished setting up HASP copy the .yaml files from this repository into ```config/packages/plate01```. 
**Don't copy** ```hasp_plate01_p4_clock.yaml```, ```hasp_plate01_p4_weather.yaml``` and ```hasp_plate01_p4_colorconfig.yaml``` into your config if you're **NOT** using a second temperature sensor. 

[Final configurations steps]

**_Page 3/4 Weather Setup_**

You'll need a [Darksky API](https://darksky.net/dev) to use the weather component. Place your API key into ```hasp_plate01_00_components.yaml```. 

**Important:** If you're not using two temperature sensors or you don't want you use two, flash your Nextion Panel with [HASwitchPlate_2.4.tft](https://github.com/zonko16/Custom-Pages-for-HASwitchplate/blob/master/Nextion%20HMI/HASwitchPlate_2.4.tft). If you want to use two sensors use [HASwitchPlate_ChangeTemperature.tft](https://github.com/zonko16/Custom-Pages-for-HASwitchplate/blob/master/Nextion%20HMI/HASwitchPlate_2.4_ChangeTemperature.tft). For Now it will use Page 3 and Page 4 to have two sensors in the "same place". This is just a workaround for now and will be changed in the future to only use one page.

If you have a temperature and humidity sensor in your house, you can have the temperature change from Out to In by clicking on the actual temperature. 
To set this up you have to replace ```sensor.your_indoor_temp``` and ```sensor.your_indoor_humidity```with your own entities.
Additionally uncomment these lines in the ```hasp_plate01_p0_pages.yaml```:
```
#  - alias: hasp_plate01_p0_ChangeToTempInside
#    trigger:
#    - platform: mqtt
#      topic: 'hasp/plate01/state/p[3].b[6]'    
#    action:
#    - service: input_number.set_value
#      data_template:
#        entity_id: 'input_number.hasp_plate01_activepage'
#        value: '4'
#  
#  - alias: hasp_plate01_p0_ChangeToTempOutside
#    trigger:
#    - platform: mqtt
#      topic: 'hasp/plate01/state/p[4].b[6]'    
#    action:
#    - service: input_number.set_value
#      data_template:
#        entity_id: 'input_number.hasp_plate01_activepage'
#        value: '3'     
```



**_Page 6 Toggles Setup_**

For the **Toggles Page** you'll need to set up your entities. You have to replace every ```switch.your_entity*``` in ```hasp_plate01_p6_toggles.yaml``` with your **own entities**.

Lines commented with ```#Change payload (b*) to the name for b*```  are for setting the title of each toggle. Starting with **_button4_** in the **_top left_**, **_button5_** at **_top right_** and so on.


