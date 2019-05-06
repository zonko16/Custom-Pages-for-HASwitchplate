If you're using the 2.4" Nextion panel copy this directory into your already existing ```/config/packages/``` folder. 

**Important:** If you renamed your HASP Node and therefore isn't called *plate01* you have to change every MQTT topic in the config files manually.

This will replace your previous settings for page 3,6 and 8. Backup your existing files if you ever need them again. 

**_Page 3 Weather Setup_**

You'll need a [Darksky API](https://darksky.net/dev) to use the weather component. Place your API key into ```hasp_plate01_00_components.yaml```. 


**_Page 6 Toggles Setup_**

For the **Toggles Page** you'll need to set up your entities. You have to replace every the ```switch.your_entity``` by your **own entities**.

Lines commented with ```#Change payload (b*) to the name for b*```  are for setting the title of each toggle. Starting with **_b4_** in the **_top left_**, **_b5_** at **_top right_** and so on. For each toggle you can either set to have a lightbulb or a I/O button. Search for the lines with **# Toggle colors on p[3].b[*] when light1 changes**. There you will find: 
```
- service: mqtt.publish
  data_template:
    topic: 'hasp/plate01/command/p[6].b[*].pic'
    payload_template: >-
      {% if states.your_entity.state == "on" -%}
        {{ 23 }}
      {%- else -%}
        {{ 22 }}
      {%- endif %}
```
The first payload stands for the **On state** the second for the **Off state**.
Just changed the payload to your liking.
```
Lightbulb off = 22
Lightbulb on = 23
I/O Button Off = 24
I/O Button On = 25
```

More toggle options to come in the future
