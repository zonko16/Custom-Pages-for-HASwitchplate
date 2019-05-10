# Custom-Pages-for-HASwitchplate
Custom pages for [HASwitchplate](https://github.com/aderusha/HASwitchPlate) created by @aderusha

![alt text](https://raw.githubusercontent.com/zonko16/Custom-Pages-for-HASwitchplate/master/Preview.png)


Special thanks to @aderusha for creating HASwitchPlate and @madrian for spending hours of beta testing with me. 

**UPDATE:**  
The first version used two pages for switching the temperature displayed between In and Out. 
The new version does the same but only needs page 3 for the same outcome. If you already flashed your Nextion Panel before, reflash the ```HASwitchPlate_2.4.tft``` and replace ```hasp_plate01_p0_pages.yaml``` and  ```hasp_plate01_p3_weather.yaml``` with the new ones.

**QUICK START**

1. Install HASP as usual but use the [HASwitchplate_2.4.tft](https://github.com/zonko16/Custom-Pages-for-HASwitchplate/blob/master/Nextion%20HMI/HASwitchPlate_2.4.tft) provided by this repository instead. 

2. Replace the yaml files in ```config/packages/plate01``` with the ones provided in this repository.
    - For the **2.4" Panel** use .yamls in [packages_2.4in/](https://github.com/zonko16/Custom-Pages-for-HASwitchplate/tree/master/packages_2.4in) 
    - For the **3.2" Panel** use .yamls in [packages_3.2in/](https://github.com/zonko16/Custom-Pages-for-HASwitchplate/tree/master/packages_3.2in)
3. Replace YOUR_API_KEY in ```hasp_plate01_00_components.yaml``` with your own Darksky API 

4. Change the entities and Labels for Page 3,6 and 8 to your liking.
Entities that need to be changed are called like **switch.YOUR_ENTITY** **senor.YOUR_TEMPERATURE** and so on.

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

You'll need a [Darksky API](https://darksky.net/dev) to use the weather component. Place your API key into ```hasp_plate01_00_components.yaml```. 

~~**Important:** If you're not using two temperature sensors or you don't want you use two, flash your Nextion Panel with [HASwitchPlate_2.4.tft](https://github.com/zonko16/Custom-Pages-for-HASwitchplate/blob/master/Nextion%20HMI/HASwitchPlate_2.4.tft). If you want to use two sensors use [HASwitchPlate_ChangeTemperature.tft](https://github.com/zonko16/Custom-Pages-for-HASwitchplate/blob/master/Nextion%20HMI/HASwitchPlate_2.4_ChangeTemperature.tft).For Now it will use Page 3 and Page 4 to have two sensors in the "same place". This is just a workaround for now and will be changed in the future to only use one page.~~


**_Page 6 Toggles Setup_**

For the **Toggles Page** you'll need to set up your entities. You have to replace every ```switch.your_entity*``` in ```hasp_plate01_p6_toggles.yaml``` with your **own entities**.

Lines commented with ```#Change payload (b*) to the name for b*```  are for setting the title of each toggle. Starting with **_button4_** in the **_top left_**, **_button5_** at **_top right_** and so on.


