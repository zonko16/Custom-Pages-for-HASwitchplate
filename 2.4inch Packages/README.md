If you're using the 2.4" Nextion panel paste this directory into your already existing ```/config/packages/plate01``` folder. 
Don't copy hasp_plate01_p4_clock.yaml, hasp_plate01_p4_weather.yaml and hasp_plate01_p4_colorconfig.yaml into your config if you're NOT using a second temperature sensor.

**Important:** You need to go through the basic setup of [HASwitchPlate](https://github.com/aderusha/HASwitchPlate) from @aderusha to use these custom Pages. If you renamed your HASP Node and therefore isn't called *plate01* you have to change every MQTT topic in the config files manually.

This will replace your all your previous settings of page 3,6 and 8. Backup your existing files if you ever need them again. 

**_Page 3 Weather Setup_**

You'll need a [Darksky API](https://darksky.net/dev) to use the weather component. Place your API key into ```hasp_plate01_00_components.yaml```. 

If you have a temperature and humidity sensor inside, you can have the temperature change from Out to In by clicking on the actual temperature. 
To set this up you have to replace ```sensor.your_indoor_temp``` and ```sensor.your_indoor_humidity```with your own entities.
Additionally uncomment lines 280 to 288 in ```hasp_plate01_p0_pages.yaml```:

```
####################################################################
# Toggles the Label and Temp/Humidity displayed on Page 3. Thanks @madrian
#  - alias: hasp_plate01_p0_ChangeToTempInOut
#    trigger:
#    - platform: mqtt
#      topic: 'hasp/plate01/state/p[3].b[6]'
#      payload: 'ON' 
#    action:
#    - service: input_boolean.toggle
#      entity_id: input_boolean.hasp_plate01_p3_temperatureswitch
```



**_Page 6 Toggles Setup_**

For the **Toggles Page** you'll need to set up your entities. You have to replace every ```switch.your_entity*``` in ```hasp_plate01_p6_toggles.yaml``` with your **own entities**.

Lines commented with ```#Change payload (b*) to the name for b*```  are for setting the title of each toggle. Starting with **_button4_** in the **_top left_**, **_button5_** at **_top right_** and so on.

