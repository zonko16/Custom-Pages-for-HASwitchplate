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
echo ""
echo "\e[1mPlease provide the size of your Nextion panel.\e[0m"
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


##############################################################################################################################
# Page 2 scripts setup
echo -e -n "Do you want to configure the \e[1mScripts \e[0mPage?(y/n) "
read -r p2_answer
if [ "$p2_answer" != "${p2_answer#[Yy]}" ]
then
  echo -e ""
  echo -e "\e[1m================================================="
  echo -e "           Page 2: Scripts Setup"
  echo -e ""
  echo -e "Enter script entity IDs (i.e. script.living_room)"
  echo -e "Script 1: bottom - Script_5: top"
  echo -e "=================================================\e[0m"
  echo -e ""

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
echo -e "Do you want to configure the \e[1mWeather Page\e[0m?(y/n) "
read -r p3_answer
if [ "$p3_answer" != "${p3_answer#[Yy]}" ]
then
  echo -e "\e[1m================================================================"
  echo -e "For weather forecast you will need an Dark Sky API"
  echo -e ""
  echo -e "If you have a temperature sensor you can customize your entity here."
  echo -e "The sensor can be accessed by pressing the actual temperature on the display"
  echo -e "3.2in users can use an additional sensor."
  echo -e "================================================================\e[0m"
  
  read -e -p "Enter your Darksky API Token:" -i "YOUR_API_TOKEN" dark_sky_api
  read -e -p "Enter temperature sensor entity_id:" -i "sensor.INDOOR_TEMP_DUMMY" in_temp
  read -e -p "Enter humidity sensor entity_id:" -i "sensor.INDOOR_HUMIDITY_DUMMY" in_humidity
  if [[ "$panel_size" == "3.2" ]]
  then
    read -e -p "Enter second temperature sensor entity_id:" -i "sensor.TEMP_2" indoor_temp_2
    read -e -p "Enter second humidity sensor entity_id." -i "sensor.HUMIDITY_2" indoor_humidity_2
  fi
fi


############################################
# Thermostat Page Configuration
echo -e "Do you want to configure the \e[1mThermostat Page\e[0m?(y/n)"
read -r p5_answer
if [ "$p5_answer" != "${p5_answer#[Yy]}" ]
then
  echo -e "\e[1m================================="
  echo -e "Page 5: Thermostat configuration"
  echo -e "=================================\e[0m"
  echo -e ""
  read -e -p "Enter your thermostat entity_id:" -i "climate.DUMMY" climate  
fi


############################################
#Toggles Page Configuration
echo -e -n "Do you want to configure the \e[1mToggles Page\e[0m?(y/n):"
read -r p6_answer
if [ "$p6_answer" != "${p6_answer#[Yy]}" ]
then
  echo -e "===================================================="
  echo -e "Page 6: Toggles Setup"
  echo -e ""
  echo -e "Enter entity IDs and names for each switch."
  echo -e "The switches will be ordered using following schema:"
  echo -e ""
  echo -e "\e[1mtoggle_1 - toggle_2"
  echo -e "toggle_3 - toggle_4"
  echo -e "toggle_5 - toggle_6"
  echo -e "toggle_6 - toggle_7\e[0m"
  echo -e "===================================================="
  echo -e ""
  read -e -p "Enter toggle_1 entity id:" -i "DUMMY" toggle1
  read -e -p "Enter toggle_1 name:" -i "DUMMY" toggle_1_name
  read -e -p "Enter toggle_2 entity id:" -i "DUMMY" toggle2
  read -e -p "Enter toggle_2 name:" -i "DUMMY" toggle_2_name
  read -e -p "Enter toggle_3 entity id:" -i "DUMMY" toggle3
  read -e -p "Enter toggle_3 name:" -i "DUMMY" toggle_3_name
  read -e -p "Enter toggle_4 entity id:" -i "DUMMY" toggle4
  read -e -p "Enter toggle_4 name:" -i "DUMMY" toggle_4_name
  read -e -p "Enter toggle_5 entity id:" -i "DUMMY" toggle5
  read -e -p "Enter toggle_5 name:" -i "DUMMY" toggle_5_name
  read -e -p "Enter toggle_6 entity id:" -i "DUMMY" toggle6
  read -e -p "Enter toggle_6 name:" -i "DUMMY" toggle_6_name
  
  if [[ "$panel_size" == "2.4"]]
  then
    echo ""
    echo -e "You can use a second Page of toggles by pressing the Toggles Page button again"
    echo -e -n "Do you want to configure a \e[1mSECOND Toggles Page\e[0m?(y/n):"
    read -r 24_p6_p2_answer
    if [ "$24_p6_p2_answer" != "${24_p6_p2_answer#[Yy]}" ]
    then
      read -e -p "Enter toggle_7 entity id:" -i "DUMMY" toggle7
      read -e -p "Enter toggle_7 name:" -i "DUMMY" toggle_7_name
      read -e -p "Enter toggle_8 entity id:" -i "DUMMY" toggle8
      read -e -p "Enter toggle_8 name:" -i "DUMMY" toggle_8_name
      read -e -p "Enter toggle_9 entity id:" -i "DUMMY" toggle9
      read -e -p "Enter toggle_9 name:" -i "DUMMY" toggle_9_name
      read -e -p "Enter toggle_10 entity id:" -i "DUMMY" toggle10
      read -e -p "Enter toggle_10 name:" -i "DUMMY" toggle_10_name
      read -e -p "Enter toggle_11 entity id:" -i "DUMMY" toggle11
      read -e -p "Enter toggle_11 name:" -i "DUMMY" toggle_11_name
      read -e -p "Enter toggle_12 entity id:" -i "DUMMY" toggle12
      read -e -p "Enter toggle_12 name:" -i "DUMMY" toggle_12_name
    fi
  
  #Setup additional switches for 3.2in users
  elif [[ "$panel_size"  == "3.2" ]]
  then
    read -e -p "Enter toggle_7 entity id:" -i "DUMMY" toggle7
    read -e -p "Enter toggle_7 name:" -i "DUMMY" toggle_7_name
    read -e -p "Enter toggle_8 entity id:" -i "DUMMY" toggle8
    read -e -p "Enter toggle_8 name:" -i "DUMMY" toggle_8_name
    echo ""
    echo -e "You can use a second Page of toggles by pressing the Toggles Page button again"
    echo -e -n "Do you want to configure a \e[1mSECOND Toggles Page\e[0m?(y/n):"
    read -r 32_p6_p2_answer
    if [ "$32_p6_p2_answer" != "${32_p6_p2_answer#[Yy]}" ]
    then
      read -e -p "Enter toggle_9 entity id:" -i "DUMMY" toggle10
      read -e -p "Enter toggle_9 name:" -i "DUMMY" toggle_10_name
      read -e -p "Enter toggle_10 entity id:" -i "DUMMY" toggle10
      read -e -p "Enter toggle_10 name:" -i "DUMMY" toggle_10_name
      read -e -p "Enter toggle_11 entity id:" -i "DUMMY" toggle11
      read -e -p "Enter toggle_11 name:" -i "DUMMY" toggle_11_name
      read -e -p "Enter toggle_12 entity id:" -i "DUMMY" toggle12
      read -e -p "Enter toggle_12 name:" -i "DUMMY" toggle_12_name
      read -e -p "Enter toggle_13 entity id:" -i "DUMMY" toggle13
      read -e -p "Enter toggle_13 name:" -i "DUMMY" toggle_13_name
      read -e -p "Enter toggle_14 entity id:" -i "DUMMY" toggle14
      read -e -p "Enter toggle_14 name:" -i "DUMMY" toggle_14_name
      read -e -p "Enter toggle_15 entity id:" -i "DUMMY" toggle15
      read -e -p "Enter toggle_15 name:" -i "DUMMY" toggle_15_name
      read -e -p "Enter toggle_16 entity id:" -i "DUMMY" toggle16
      read -e -p "Enter toggle_16 name:" -i "DUMMY" toggle_16_name
    fi
  fi
fi

# Setup Media Player
echo ""
echo -e -n "Do you want to configure the \e[1mMedia Player Page\e[0m?(y/n):"
read -r p8_answer
if [ "$p8_answer" != "${p8_answer#[Yy]}" ]
then
  echo -e "\e[1m=============================================================="
  echo -e "                     Media Player Setup"
  echo -e "==============================================================\e[0m"
  echo -e ""
  read -e -p "Enter your Media Player entity:" -i "media_player.spotify" media_player

  if [[ "$panel_size" == "3.2" ]]
  then
    echo -e "On the 3.2in panel you can select two media player sources"
    read -e -p "Enter Source 1:" media_source_1
    read -e -p "Enter a Name for source 1:" media_source_1_name
    read -e -p "Enter Source 2:" media_source_2
    read -e -p "Enter a Name for source 2:" media_source_2_name
  fi
  echo -e -n "Do you want to configure the \e[1mPlaylist Page\e[0m?(y/n):"
  read -r p7_answer
  if [ "$p7_answer" != "${p7_answer#[Yy]}" ]
  then
    echo -e ""
    echo -e "\e[1m=============================================================="
    echo -e "                    Media Playlists"
    echo -e "==============================================================\e[0m"
    echo -e ""
    read -e -p "Enter Playlist 1:" -i "script.1" playlist1
    read -e -p "Enter Playlist 2:" -i "script.2" playlist2
    read -e -p "Enter Playlist 3:" -i "script.3" playlist3
    read -e -p "Enter Playlist 4:" -i "script.4" playlist4
    read -e -p "Enter Playlist 5:" -i "script.5" playlist5
    read -e -p "Enter Playlist 6:" -i "script.6" playlist6
  fi
fi

echo -e -n "Do you want to configure the \e[1m3D Printer Page\e[0m?(y/n): "
read -r p9_answer
if [ "$p9_answer" != "${p9_answer#[Yy]}" ]
then
  echo -e "\e[1m======================================================="
  echo -e "                3D Printer Page \e[0mSetup"
  echo -e ""
  echo -e "       The sensors for the 3d printer look like:"
  echo -e "      \e[1msensor.octoprint_actual_bed_temp\e[0m"
  echo -e "Provide only the part of custom part of your sensor."
  echo -e "               In this case: octoprint"
  echo -e "\e[1m=======================================================\e[0m"
  echo -e ""

  read -e -p "Enter 3D Printer ON/OFF switch entity:" -i "switch.printer" octoSwitch
  read -e -p "Enter your 3d printer sensor:" -i "octoprint" octoSensor
fi

##############################################################################################################################
# Create temporary folder
hasp_temp_dir=`mktemp -d`
echo ""

# Download the necessary files
if [[ "$panel_size"  == "3.2" ]]
then
  echo "Download 3.2in packages"
  wget -q -P $hasp_temp_dir https://github.com/zonko16/Custom-Pages-for-HASwitchplate/raw/beta/packages_3.2in/3.2_packages.tar.gz
  tar -zxf $hasp_temp_dir/3.2_packages.tar.gz -C $hasp_temp_dir
  rm $hasp_temp_dir/3.2_packages.tar.gz
elif [[ "$panel_size"  == "2.4" ]]
then
  echo "Download 2.4in packages"
  wget -q -P $hasp_temp_dir https://github.com/zonko16/Custom-Pages-for-HASwitchplate/raw/beta/packages_2.4in/2.4_packages.tar.gz
  tar -zxf $hasp_temp_dir/2.4_packages.tar.gz -C $hasp_temp_dir
  rm $hasp_temp_dir/2.4_packages.tar.gz
fi

##############################################################################################################################
# Write SCRIPTS config to file if it was set up by user
if [ "$p2_answer" != "${p2_answer#[Yy]}" ]
then
  sed -i -e 's/script.SCRIPT_1/'"$scene_1"'/g' -e 's/script.SCRIPT_2/'"$scene_2"'/g' -e  's/script.SCRIPT_3/'"$scene_3"'/g' -e 's/script.SCRIPT_4/'"$scene_4"'/g' -e 's/script.SCRIPT_5/'"$scene_5"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p2_scripts.yaml
fi

# Write WEATHER config to file if it was set up by user
if [ "$p3_answer" != "${p3_answer#[Yy]}" ]
then
  sed -i -- 's/YourAPIKey/'"$dark_sky_api"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_*.yaml
  sed -i -e 's/sensor.TEMPERATURE1/'"$in_temp"'/g' -e 's/sensor.HUMIDITY1/'"$in_humidity"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p3_weather.yaml
  if [[ "$panel_size" == "3.2" ]]
  then
    sed -i -e 's/sensor.TEMPERATURE2/'"$in_temp_2"'/g' -e 's/sensor.HUMIDITY2/'"$in_humidity_2"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p3_weather.yaml
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
  #Entities
  sed -i -e 's/domain.TOGGLEI/'"$toggle1"'/g' -e 's/domain.TOGGLE2/'"$toggle2"'/g' -e 's/domain.TOGGLE3/'"$toggle3"'/g' -e 's/domain.TOGGLE4/'"$toggle4"'/g' -e 's/domain.TOGGLE5/'"$toggle5"'/g' -e 's/domain.TOGGLE6/'"$toggle6"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
  sed -i -e 's/toggleNameI/'"$toggle_1_name"'/g' -e 's/toggleName2/'"$toggle_2_name"'/g' -e 's/toggleName3/'"$toggle_3_name"'/g' -e 's/toggleName4/'"$toggle_4_name"'/g' -e 's/toggleName5/'"$toggle_5_name"'/g' -e 's/toggleName6/'"$toggle_6_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml

  if [ "$24_p6_p2_answer" != "${24_p6_p2_answer#[Yy]}" ]
  then
    sed -i -e 's/domain.TOGGLE7/'"$toggle7"'/g' -e 's/domain.TOGGLE8/'"$toggle8"'/g' -e 's/domain.TOGGLE9/'"$toggle9"'/g' -e 's/domain.TOGGLE10/'"$toggle10"'/g' -e 's/domain.TOGGLE11/'"$toggle11"'/g' -e 's/domain.TOGGLE12/'"$toggle12"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
    sed -i -e 's/toggleName7/'"$toggle_7_name"'/g' -e 's/toggleName8/'"$toggle_8_name"'/g' -e 's/toggleName9/'"$toggle_9_name"'/g' -e 's/toggleName10/'"$toggle_10_name"'/g' -e 's/toggleName11/'"$toggle_11_name"'/g' -e 's/toggleName12/'"$toggle_12_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml

  elif [[ "$panel_size" == "3.2" ]]
  then
    sed -i -e 's/domain.TOGGLE7/'"$toggle7"'/g' -e 's/domain.TOGGLE8/'"$toggle8"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
    sed -i -e 's/toggleName7/'"$toggle_7_name"'/g' -e 's/toggleName8/'"$toggle_8_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
    
    if [ "$32_p6_p2_answer" != "${32_p6_p2_answer#[Yy]}" ]
    then
      sed -i -e 's/domain.TOGGLE9/'"$toggle9"'/g' -e 's/domain.TOGGLE10/'"$toggle10"'/g' -e 's/domain.TOGGLE11/'"$toggle11"'/g' -e 's/domain.TOGGLE12/'"$toggle12"'/g' -e 's/domain.TOGGLE13/'"$toggle13"'/g' -e 's/domain.TOGGLE14/'"$toggle14"'/g' -e 's/domain.TOGGLE15/'"$toggle15"'/g' -e 's/domain.TOGGLE16/'"$toggle16"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
      sed -i -e 's/toggleName9/'"$toggle_9_name"'/g' -e 's/toggleName10/'"$toggle_10_name"'/g' -e 's/toggleName11/'"$toggle_11_name"'/g' -e 's/toggleName12/'"$toggle_12_name"'/g' -e 's/toggleName13/'"$toggle_13_name"'/g' -e 's/toggleName14/'"$toggle_14_name"'/g' -e 's/toggleName15/'"$toggle_15_name"'/g' -e 's/toggleName16/'"$toggle_16_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
  fi
fi


if [ "$p8_answer" != "${p8_answer#[Yy]}" ]
then
  sed -i -e 's/media_player.spotify/'"$media_player"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p8_media.yaml
  sed -i -e 's/MediaSource1/'"$media_source_1"'/g' -e 's/MediaSource2/'"$media_source_2"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p8_media.yaml
  sed -i -e 's/Source1/'"$media_source_1_name"'/g' -e 's/Source2/'"$media_source_2_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p8_media.yaml
fi

if [ "$p7_answer" != "${p7_answer#[Yy]}" ]
then
  sed -i -e 's/script.PLAYLIST1/'"$playlist1"'/g' -e 's/script.PLAYLIST2/'"$playlist2"'/g' -e 's/script.PLAYLIST3/'"$playlist3"'/g' -e 's/script.PLAYLIST4/'"$playlist4"'/g' -e 's/script.PLAYLIST5/'"$playlist5"'/g' -e 's/script.PLAYLIST6/'"$playlist6"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p7_playlists.yaml
fi

if [ "$p9_answer" != "${p9_answer#[Yy]}" ]
then
  sed -i -e 's/switch.printer/'"$octoSwitch"'/g' -e 's/octoprint/'"$octoSensor"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p9_3dprinter.yaml
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