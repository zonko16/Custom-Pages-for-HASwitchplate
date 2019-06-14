#!/usr/bin/env bash

#Basic device information
hasp_input_name="$@"

if [ ! -f configuration.yaml ]
then
  echo "WARNING: 'configuration.yaml' not found in current directory."
  echo "Searching for Home Assistant 'configuration.yaml'..."
  configfile=$(find / -name configuration.yaml 2>/dev/null)
  count=$(echo "$configfile" | wc -l)
  if [ $count == 1 ]
  then
    configdir=$(dirname "${configfile}")
    cd $configdir
    echo "INFO: configuration.yaml found under: $configdir"
  else
    echo "ERROR: Failed to locate the active 'configuration.yaml'"
    echo "       Please run this script from the homeassistant"
    echo "       configuration folder for your environment."
    exit 1
  fi
fi

# Check for write access to configuration.yaml
if [ ! -w configuration.yaml ]
then
  echo "ERROR: Cannot write to 'configuration.yaml'."
  exit 1
fi

# Check that a new device name has been supplied and ask the user if we're missing

if [ "$hasp_input_name" == "" ]
then
  read -e -p "Enter the new HASP device name (lower case letters, numbers, and '_' only): " -i "plate01" hasp_input_name
fi

# If it's still empty just pout and quit
if [ "$hasp_input_name" == "" ]
then
  echo "ERROR: No device name provided"
  exit 1
fi

# Santize the requested devicename to work with hass
hasp_device=`echo "$hasp_input_name" | tr '[:upper:]' '[:lower:]' | tr ' [:punct:]' '_'`

# Warn the user if we had rename anything
if [[ "$hasp_input_name" != "$hasp_device" ]]
then
  echo "WARNING: Sanitized device name to \"$hasp_device\""
fi

# Ask user to provide the panel size
echo "Please provide the size of your Nextion panel."
read -e -p "Options: (2.4 / 3.2)" -i "2.4" panel_size

# Check to see if packages are being included
if ! grep "^  packages: \!include_dir_named packages" configuration.yaml > /dev/null
then
  if grep "^  packages: " configuration.yaml > /dev/null
  then
    echo "==========================================================================="
    echo "WARNING: Conflicting packages definition found in 'configuration.yaml'."
    echo "         Please add the following statement to your configuration:"
    echo ""
    echo "homeassistant:"
    echo "  packages: !include_dir_named packages"
    echo "==========================================================================="
  else
    sed -i 's/^homeassistant:.*/homeassistant:\n  packages: !include_dir_named packages/' configuration.yaml
  fi
fi

# Enable recorder if not enabled to persist relevant values
if ! grep "^recorder:" configuration.yaml > /dev/null
then
  echo "recorder:" >> configuration.yaml
fi

# Warn if MQTT is not enabled
if ! grep "^mqtt:" configuration.yaml > /dev/null
then
  echo "==========================================================================="
  echo "WARNING: Required MQTT broker configuration not setup in configuration.yaml"
  echo "HASP WILL NOT FUNCTION UNTIL THIS HAS BEEN CONFIGURED!  The embedded option"
  echo "offered my Home Assistant is buggy, so deploying Mosquitto is recommended."
  echo ""
  echo "Home Assistant MQTT configuration: https://www.home-assistant.io/docs/mqtt/broker/#run-your-own"
  echo "Install Mosquitto: sudo apt-get install mosquitto mosquitto-clients"
  echo "==========================================================================="
fi

# Hass has a bug where packaged automations don't work unless you have at least one
# automation manually created outside of the packages.  Attempt to test for that and
# create a dummy automation if an empty automations.yaml file is found.
if grep "^automation: \!include automations.yaml" configuration.yaml > /dev/null
then
  if [ -f automations.yaml ]
  then
    if [[ $(< automations.yaml) == "[]" ]]
    then
      echo "WARNING: empty automations.yaml found, creating DUMMY automation for package compatibility"
      echo "- action: []" > automations.yaml
      echo "  id: DUMMY" >> automations.yaml
      echo "  alias: DUMMY Can Be Deleted After First Automation Has Been Added" >> automations.yaml
      echo "  trigger: []" >> automations.yaml
    fi
  fi
fi


############################################
# Page 2 scripts setup
echo -e -n "Do you want to configure the \e[1mScripts \e[0mPage?(y/n) "
read -r p2_answer
if [ "$p2_answer" != "${p2_answer#[Yy]}" ]
then
  echo ""
  echo "================================================="
  echo "           Page 2: Scripts Setup"
  echo ""
  echo "Enter script entity IDs (i.e. script.living_room)"
  echo "Script 1: bottom - Script_5: top"
  echo "================================================="
  echo ""

# User Input for script entities
  read -e -p "Enter script_1:" -i "script.SCRIPT_1" scene_1
  read -e -p "Enter script_2:" -i "script.SCRIPT_2" scene_2
  read -e -p "Enter script_3:" -i "script.SCRIPT_3" scene_3
  read -e -p "Enter script_4:" -i "script.SCRIPT_4" scene_4
  read -e -p "Enter script_5:" -i "script.SCRIPT_5" scene_5
else
  echo "Continue setup without customizing Script page"
fi

############################################
# Weather/Time Page configuration
echo -e -n "Do you want to configure the \e[1mWeather Page\e[0m?(y/n) "
read -r p3_answer
if [ "$p3_answer" != "${p3_answer#[Yy]}" ]
then
  echo "================================================================"
  echo "For weather forecast you will need an Dark Sky API"
  echo ""
  echo "If you have a temperature sensor you can customize your entity here."
  echo "The sensor can be accessed by pressing the actual temperature on the display"
  echo "3.2in users can use an additional sensor."
  echo "================================================================"
  
  read -e -p "Enter your Darksky API Token:" -i "YOUR_API_TOKEN" dark_sky_api
  read -e -p "Enter \e[1mtemperature sensor \e[0mentity_id:" -i "sensor.INDOOR_TEMP_DUMMY" in_temp
  read -e -p "Enter \e[1mhumidity sensor \e[0mentity_id:" -i "sensor.INDOOR_HUMIDITY_DUMMY" in_humidity
  if [[ "$panel_size" == "$panel_size#3.2" ]]
  then
    read -e -p "Enter second temperature sensor entity_id:" -i "sensor.TEMP_2" indoor_temp_2
    read -e -p "Enter second humidity sensor entity_id." -i "sensor.HUMIDITY_2" indoor_humidity_2
  fi
fi


############################################
# Thermostat Page Configuration
echo -e -n "Do you want to configure the \e[1mThermostat Page\e[0m?(y/n)"
read -r p5_answer
if [ "$p5_answer" != "${p5_answer#[Yy]}" ]
then
  echo "================================="
  echo "Page 5: Thermostat configuration"
  echo "================================="
  echo ""
  read -e -p "Enter your thermostat entity_id:" -i "climate.DUMMY" climate  
fi
############################################
#Toggles Page Configuration
echo -e -n "Do you want to configure the \e[1mTOGGLES Page\e[0m?(y/n) "
read -r p6_answer
if [ "$p6_answer" != "${p6_answer#[Yy]}" ]
then
  echo "Page 6: Toggles Setup"
  echo ""
  echo "Enter entity IDs and names for each switch."
  echo "The switches will be ordered using following schema:"
  echo ""
  echo "\e[1mtoggle_1 - toggle_2"
  echo "\e[1mtoggle_3 - toggle_4"
  echo "\e[1mtoggle_5 - toggle_6"
  echo "\e[1mtoggle_6 - toggle_7"
  echo ""
  read -e -p "Enter toggle_1 entity id:" -i "DUMMY" toggle_1
  read -e -p "Enter toggle_1 name:" -i "DUMMY" toggle_1_name
  read -e -p "Enter toggle_2 entity id:" -i "DUMMY" toggle_2
  read -e -p "Enter toggle_2 name:" -i "DUMMY" toggle_3_name
  read -e -p "Enter toggle_3 entity id:" -i "DUMMY" toggle_3
  read -e -p "Enter toggle_3 name:" -i "DUMMY" toggle_3_name
  read -e -p "Enter toggle_4 entity id:" -i "DUMMY" toggle_4
  read -e -p "Enter toggle_4 name:" -i "DUMMY" toggle_4_name
  read -e -p "Enter toggle_5 entity id:" -i "DUMMY" toggle_5
  read -e -p "Enter toggle_5 name:" -i "DUMMY" toggle_5_name
  read -e -p "Enter toggle_6 entity id:" -i "DUMMY" toggle_6
  read -e -p "Enter toggle_6 name:" -i "DUMMY" toggle_6_name
  
  #Setup additional switches for 3.2in users
  if [[ "$panel_size"  == "3.2" ]]
  then
    read -e -p "Enter toggle_7 entity id:" -i "DUMMY" toggle_7
    read -e -p "Enter toggle_7 name:" -i "DUMMY" toggle_7_name
    read -e -p "Enter toggle_8 entity id:" -i "DUMMY" toggle_8
    read -e -p "Enter toggle_8 name:" -i "DUMMY" toggle_8_name
  fi
fi


# Setup Media Player
echo -e "Do you want to configure the \e[1mMedia Player Page\e[0m?"
echo -e "(y/n):"
read -r p8_answer
if [ "$p8_answer" != "${p8_answer#[Yy]}" ]
then
  read -e -p "Enter your Media Player entity:" -i "media_player.spotify" media_player

  if [[ "$panel_size" == "3.2" ]]
  then
    echo -e "On the 3.2in panel you can select two media player sources"
    read -e -p "Enter \e[1mSource 1\e[0m:" media_source_1
    read -e -p "Enter a \e[1mName \e[0mfor source 1:" media_source_1_name
    read -e -p "Enter \e[1mSource 2\e[0m:" media_source_2
    read -e -p "Enter a \e[1mName \e[0mfor source 2:" media_source_2_name
  fi
fi


# Create temporary folder
hasp_temp_dir=`mktemp -d`

# Download the necessary files
wget -q -P $hasp_temp_dir https://github.com/zonko16/Custom-Pages-for-HASwitchplate/raw/dev/packages_3.2in/3.2_packages.tar.gz
tar -zxf $hasp_temp_dir/3.2_packages.tar.gz -C $hasp_temp_dir
rm $hasp_temp_dir/3.2_packages.tar.gz

# Write SCRIPTS config to file if it was set up by user
if [ "$p2_answer" != "${p2_answer#[Yy]}" ]
then
  sed -i -e 's/script.SCRIPT_1/'"$scene_1"'/g' -e 's/script.SCRIPT_2/'"$scene_2"'/g' -e  's/script.SCRIPT_3/'"$scene_3"'/g' -e 's/script.SCRIPT_4/'"$scene_4"'/g' -e 's/script.SCRIPT_5/'"$scene_5"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p2_scripts.yaml
fi

# Write WEATHER config to file if it was set up by user
if [ "$p3_answer" != "${p3_answer#[Yy]}" ]
then
  sed -i -- 's/YOUR_DARKSKY_API/'"$dark_sky_api"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_*.yaml
  sed -i -e 's/sensor.YOUR_TEMPERATURE_SENSOR/'"$in_temp"'/g' -e 's/sensor.YOUR_HUMIDITY_/'"$in_humidity"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p3_weather.yaml
  if [[ "$panel_size" == "3.2" ]]
  then
    sed -i -e 's/sensor.YOUR_TEMPERATURE_SENSOR2/'"$in_temp_2"'/g' -e 's/sensor.YOUR_HUMIDITY_SENSOR2/'"$in_humidity_2"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p3_weather.yaml
  fi
fi
    
# Write WEATHER config to file if it was set up by user
if [ "$p5_answer" != "${p5_answer#[Yy]}" ]
then
  sed -i -- 's/climate.DUMMY/'"$climate"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p5_thermostat.yaml
fi

# Write Toggles Page variables to yaml
if [ "$p6_answer" != "${p6_answer#[Yy]}" ]
then
  sed -i -- 's/TOGGLE1_DUMMY/'"$toggle_1_entity"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
  sed -i -- 's/TOGGLE2_DUMMY/'"$toggle_2_entity"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
  sed -i -- 's/TOGGLE3_DUMMY/'"$toggle_3_entity"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
  sed -i -- 's/TOGGLE4_DUMMY/'"$toggle_4_entity"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
  sed -i -- 's/TOGGLE5_DUMMY/'"$toggle_5_entity"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
  sed -i -- 's/TOGGLE6_DUMMY/'"$toggle_6_entity"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
  sed -i -- 's/TOGGLE1/'"$toggle_1_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
  sed -i -- 's/TOGGLE2/'"$toggle_2_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
  sed -i -- 's/TOGGLE3/'"$toggle_3_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
  sed -i -- 's/TOGGLE4/'"$toggle_4_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
  sed -i -- 's/TOGGLE5/'"$toggle_5_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
  sed -i -- 's/TOGGLE6/'"$toggle_6_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
  if [[ "$panel_size" == "3.2" ]]
  then
    sed -i -- 's/TOGGLE7_DUMMY/'"$toggle_7_entity"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
    sed -i -- 's/TOGGLE8_DUMMY/'"$toggle_8_entity"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
    sed -i -- 's/TOGGLE7/'"$toggle_7_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
    sed -i -- 's/TOGGLE8/'"$toggle_8_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
  fi
fi


if [ "$p8_answer" != "${p8_answer#[Yy]}" ]
then
  sed -i -e 's/media_player.spotify/'"$media_player"'/g' -e 's/MEDIA_SOURCE1/'"$media_source_1"'/g' -e 's/SOURCE1/'"$media_source_1_name"'/g' -e 's/MEDIA_SOURCE2/'"$media_source_2"'/g' -e 's/SOURCE2/'"$media_source_2_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p8_media.yaml
fi



#################################################################################
#################################################################################
# Copy files from tempdir to packages
# Rename things if we are calling it something other than plate01
if [[ "$hasp_input_name" != "plate01" ]]
then
  # rename text in contents of files
  sed -i -- 's/plate01/'"$hasp_device"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_*.yaml
  sed -i -- 's/plate01/'"$hasp_device"'/g' $hasp_temp_dir/hasp-examples/plate01/hasp_plate01_*.yaml

  # rename files and folder - thanks to @cloggedDrain for this loop!
  mkdir $hasp_temp_dir/packages/$hasp_device
  for file in $hasp_temp_dir/packages/plate01/*
  do
    new_file=`echo $file | sed s/plate01/$hasp_device/g`
    if [ -f $file ]
    then
      mv $file $new_file
      if [ $? -ne 0 ]
      then
        echo "ERROR: Could not copy $file to $new_file"
        exit 1
      fi
    fi
  done
  rm -rf $hasp_temp_dir/packages/plate01
  # do it again for the examples
  mkdir $hasp_temp_dir/hasp-examples/$hasp_device
  for file in $hasp_temp_dir/hasp-examples/plate01/*
  do
    new_file=`echo $file | sed s/plate01/$hasp_device/g`
    if [ -f $file ]
    then
      mv $file $new_file
      if [ $? -ne 0 ]
      then
        echo "ERROR: Could not copy $file to $new_file"
        exit 1
      fi
    fi
  done
  rm -rf $hasp_temp_dir/hasp-examples/plate01
fi

# Check to see if the target directories already exist
if [[ -d ./packages/$hasp_device ]] || [[ -d ./hasp-examples/$hasp_device ]]
then
  echo "==========================================================================="
  echo "WARNING: This device already exists.  You have 3 options:"
  echo "  [r] Replace - Delete existing device and replace with new device [RECOMMENDED]"
  echo "  [u] Update  - Overwrite existing device with new configuration, retain any additional files created"
  echo "  [c] Canel   - Cancel the process with no changes made"
  echo ""
  read -e -p "Enter overwrite action [r|u|c]: " -i "r" hasp_overwrite_action
  if [[ "$hasp_overwrite_action" == "r" ]] || [[ "$hasp_overwrite_action" == "R" ]]
  then
    echo "Deleting existing device and creating new device"
    rm -rf ./packages/$hasp_device
    rm -rf ./hasp-examples/$hasp_device
    cp -rf $hasp_temp_dir/* .
    rm -rf $hasp_temp_dir
  elif [[ "$hasp_overwrite_action" == "u" ]] || [[ "$hasp_overwrite_action" == "U" ]]
  then
    echo "Overwriting existing device with updated files"
    cp -rf $hasp_temp_dir/* .
    rm -rf $hasp_temp_dir
  else
    echo "Exiting with no changes made"
    rm -rf $hasp_temp_dir
    exit 1
  fi
else
  # Copy everything over and burn the evidence
  cp -rf $hasp_temp_dir/* .
  rm -rf $hasp_temp_dir
fi

echo "==========================================================================="
echo "SUCCESS! Restart Home Assistant to enable HASP device $hasp_device"