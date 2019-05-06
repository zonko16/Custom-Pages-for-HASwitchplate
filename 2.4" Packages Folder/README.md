If you're using the 2.4" Nextion panel copy this directory into your already existing '/config/packages/' folder. 

This will replace your previous settings for page 3,6 and 8. Backup your existing files if you ever need them again. 

You'll need a [Darksky API](https://darksky.net/dev) to use the weather component. Place your API key into ```hasp_plate01_00_components.yaml```. 

For the **Toggles Page** you'll need to set up your entities. Lines commented with **"Set name for b(*)"** in **hasp_plate01_p6_toggles.yaml** are for setting the title of each toggle. For each toggle you can either set to have a lightbulb or a I/O button. Search for the lines with **# Toggle colors on p[3].b[*] when light1 changes**. There you will find: 
```
- service: mqtt.publish
  data_template:
    topic: 'hasp/plate01/command/p[6].b[*].pic'
    payload_template: >-
      {% if states.your_entity.state == "on" -%}
        {{ 6 }}
      {%- else -%}
        {{ 7 }}
      {%- endif %}
```
The first payload stands for the **On state** the second for the **Off state**.
Just changed the payload to your liking.
```
Lightbulb on = 6
Lightbulb off = 7
I/O Button On = 8
I/O Button Off = 9
```
