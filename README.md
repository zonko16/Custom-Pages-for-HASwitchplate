# Custom-Pages-for-HASwitchplate
Custom pages for [HASwitchplate](https://github.com/aderusha/HASwitchPlate) created by @aderusha

Changelog
====

#### UPDATE 0.3
- **Alternative Theme** now available.
  Replace the firmware with the new one according to your panel. Nothing else has to be changed. The firmwares with the new theme end with ```_alternate_theme_*.yaml```.

- New Pages added
  There is a set of new Pages added to HASP.
  Pressing button 1 on the Date/Weather page will open up a menu where you can access further functions
  The extended funcionalty will only work with the alternate theme for now. Follow Instructions to get the new Pages working

#### UPDATE 0.2:  
- Your now able to switch between two pages on Page 6 (Toggles) by pressing the toggles button in the Navigation Bar again.
- Simplified setting up entities for Page6 (Toggles). See Step 4 in Quick start.

Preview
===
**Standard Theme**
![alt text](https://raw.githubusercontent.com/zonko16/Custom-Pages-for-HASwitchplate/master/Preview.png)

**Alternative Theme**

![alt text](https://raw.githubusercontent.com/zonko16/Custom-Pages-for-HASwitchplate/beta/preview_alternate_theme.png)


QUICK START
=====

1. Install HASP as usual but use the [HASwitchplate_2.4.tft](https://github.com/zonko16/Custom-Pages-for-HASwitchplate/blob/master/Nextion%20HMI/HASwitchPlate_2.4.tft) provided by this repository instead. 

2. Replace the yaml files in ```config/packages/plate01``` with the ones provided in this repository.
    - For the **2.4" Panel** use .yamls in [packages_2.4in/](https://github.com/zonko16/Custom-Pages-for-HASwitchplate/tree/master/packages_2.4in) 
    - For the **3.2" Panel** use .yamls in [packages_3.2in/](https://github.com/zonko16/Custom-Pages-for-HASwitchplate/tree/master/packages_3.2in)

  **Update 0.3:** You can access a Menu with extra pages using the new **alternative Theme**.
  Coming from previous release add/replace ```hasp_plate01_p0_pages.yaml```, ```hasp_plate01_p1_menu.yaml```, ```hasp_palte01_p2_scripts.yaml```, ```hasp_plate01_p4_sliders.yaml```, ```hasp_plate01_p7_playlist.yaml´``
  It's recommended to deactivate any colorconfig.yaml as colors are already set in the firmware.

3. Replace YOUR_API_KEY in ```hasp_plate01_00_components.yaml``` with your own Darksky API 

4. Replace the entities and names to your liking for every page in the different YAML files.
Entities that need to be changed are called like **switch.YOUR_ENTITY**, **senor.YOUR_TEMPERATURE** and so on.
**IMPORTANT UPDATE:** This step hast been considerably simplified for page 6. 
- Open ```hasp_plate01_p6_entities.yaml```
- In there you'll find 
```
hasp_plate01_p6_toggle1-12(16):
  name: Toggle 1-12(16)
  entities:
  - switch.DUMMY
```
- replace **switch.DUMMY** with the component you are using for ever single button and set the name for your toggle.

5. (3.2" users skip this step) If you're using a **second temperature/humidity** and want to switch between In and  Out by clicking on the displayed temperature uncomment lines 280 to 288 in ```hasp_plate01_p0_pages.yaml```:

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




**_Page 3 Weather Setup_**

You'll need a [Darksky API](https://darksky.net/dev) to use the weather component. Place your API key into ```hasp_plate01_p3_weather.yaml```. 

Special thanks to **@aderusha** for creating HASwitchPlate and **@madrian** for spending hours of beta testing with me. 



