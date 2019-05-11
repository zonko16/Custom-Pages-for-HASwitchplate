If you're using the 2.4" Nextion panel paste this directory into your already existing ```/config/packages/plate01``` folder. 

**Important:** You need to go through the basic setup of [HASwitchPlate](https://github.com/aderusha/HASwitchPlate) from @aderusha to use these custom Pages.

This will replace your all your previous settings of page 3,6 and 8. Backup your existing files if you ever need them again. 

**_Page 3 Weather Setup_**

You'll need a [Darksky API](https://darksky.net/dev) to use the weather component. Place your API key into ```hasp_plate01_00_components.yaml```. 



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

**IMPORTANT UPDATE:** This step hast been considerably simplified for page 6. 
- Open ```hasp_plate01_p6_entities.yaml```
- In there you'll find 
```
hasp_plate01_p6_toggle1-12:
  name: Toggle 1-12
  entities:
  - switch.DUMMY
  
```

- replace **switch.DUMMY** with the component you are using for ever single button and set corresponding nam



