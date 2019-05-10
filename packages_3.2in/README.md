If you're using the 2.4" Nextion panel paste this directory into your already existing ```/config/packages/plate01``` folder. 
Don't copy hasp_plate01_p4_clock.yaml, hasp_plate01_p4_weather.yaml and hasp_plate01_p4_colorconfig.yaml into your config if you're NOT using a second temperature sensor.

**Important:** You need to go through the basic setup of [HASwitchPlate](https://github.com/aderusha/HASwitchPlate) from @aderusha to use these custom Pages.

This will replace your all your previous settings of page 3,6 and 8. Backup your existing files if you ever need them again. 

**_Page 3 Weather Setup_**

You'll need a [Darksky API](https://darksky.net/dev) to use the weather component. Place your API key into ```hasp_plate01_00_components.yaml```. 





**_Page 6 Toggles Setup_**

**IMPORTANT UPDATE:** This step hast been considerably simplified for page 6. 
- Open ```hasp_plate01_p6_entities.yaml```
- In there you'll find 
```
hasp_plate01_p6_button1-16:
  name: Toggle 1-16
  entities:
  - switch.DUMMY
```
- replace **switch.DUMMY** with the component you are using for ever single button.


Lines commented with ```#Change payload (b*) to the name for b*```  are for setting the title of each toggle. Starting with **_button4_** in the **_top left_**, **_button5_** at **_top right_** and so on.


