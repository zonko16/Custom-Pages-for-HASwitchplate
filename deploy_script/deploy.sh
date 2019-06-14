#!/usr/bin/env bash

hasp_name = "$@"
# Page 2 Scripts
input_script_1 = "$@"
input_script_2 = "$@"
input_script_3 = "$@"
input_script_4 = "$@"
input_script_5 = "$@"

# Page 3 Weather/Time input variables

input_in_temp = "$@"
input_in_humidity = "$@"
input_out_temp = "$@"
input_out_humidity = "$@"

# Page 5 Thermostat
input_thermostat = "$@"

# Page 6 variables
input_toggle_1 = "$@"
input_toggle_2 = "$@"
input_toggle_3 = "$@"
input_toggle_4 = "$@"
input_toggle_5 = "$@"
input_toggle_6 = "$@"
input_toggle_7 = "$@"
input_toggle_8 = "$@"

input_toggle_1_name = "$@"
input_toggle_2_name = "$@"
input_toggle_3_name = "$@"
input_toggle_4_name = "$@"
input_toggle_5_name = "$@"
input_toggle_6_name = "$@"
input_toggle_7_name = "$@"
input_toggle_8_name = "$@"

# Page 7 Playlists
input_playlist_1 = "$@"
input_playlist_2 = "$@"
input_playlist_3 = "$@"
input_playlist_4 = "$@"
input_playlist_5 = "$@"
input_playlist_6 = "$@"

# Page 8 Media
input_media_player = "$@"

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
hasp_input_name="$@"

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

# Page 2 scripts setup
echo "================================================="
echo "Page 2: Scripts Setup"
echo ""
echo "Enter script entity IDs (i.e. script.living_room)"
echo "Script 1: bottom - Script_5: top"
echo ""
echo "================================================="

if [ "$input_script_1" == "" ]
then
  read -e -p "Enter script_1:" -i "script.SCRIPT_1" input_script_1
fi

if [ "$input_script_2" == "" ]
then
  read -e -p "Enter script_2:" -i "script.SCRIPT_2" input_script_2
fi

if [ "$input_script_3" == "" ]
then
  read -e -p "Enter script_3:" -i "script.SCRIPT_3" input_script_3
fi

if [ "$input_script_4" == "" ]
then
  read -e -p "Enter script_4:" -i "script.SCRIPT_4" input_script_4
fi

if [ "$input_script_5" == "" ]
then 
  read -e -p "Enter script_5:" -i "script.SCRIPT_5" input_script_5
fi

script_1 =`echo "$input_script_1" | tr '[:upper:]' '[:lower:]' | tr ' [:punct:]' '_'`
script_2 =`echo "$input_script_2"`
script_3 =`echo "$input_script_3"`
SCRIPT_4 =`echo "$input_script_4"`
SCRIPT_5 =`echo "$input_script_5"`



if [ "$input_toggle_1" == "" ]
then
  echo "Page 6: Toggles Setup"
  echo ""
  echo "Enter entity IDs and names for each switch."
  echo "The switches will be ordered using following schema:"
  echo ""
  echo "toggle_1 - toggle_2"
  echo "toggle_3 - toggle_4"
  echo "toggle_5 - toggle_6"
  echo "toggle_6 - toggle_7"
  echo ""
  read -e -p "Enter toggle_1 entity id:" -i "DUMMY" input_toggle_1
  read -e -p "Enter toggle_1 name:" -i "DUMMY" input_toggle_1_name
  read -e -p "Enter toggle_2 entity id:" -i "DUMMY" input_toggle_2
  read -e -p "Enter toggle_2 name:" -i "DUMMY" input_toggle_3_name
  read -e -p "Enter toggle_3 entity id:" -i "DUMMY" input_toggle_3
  read -e -p "Enter toggle_3 name:" -i "DUMMY" input_toggle_3_name
  read -e -p "Enter toggle_4 entity id:" -i "DUMMY" input_toggle_4
  read -e -p "Enter toggle_4 name:" -i "DUMMY" input_toggle_4_name
  read -e -p "Enter toggle_5 entity id:" -i "DUMMY" input_toggle_5
  read -e -p "Enter toggle_5 name:" -i "DUMMY" input_toggle_5_name
  read -e -p "Enter toggle_6 entity id:" -i "DUMMY" input_toggle_6
  read -e -p "Enter toggle_6 name:" -i "DUMMY" input_toggle_6_name
  read -e -p "Enter toggle_7 entity id:" -i "DUMMY" input_toggle_7
  read -e -p "Enter toggle_7 name:" -i "DUMMY" input_toggle_7_name
  read -e -p "Enter toggle_8 entity id:" -i "DUMMY" input_toggle_8
  read -e -p "Enter toggle_8 name:" -i "DUMMY" input_toggle_8_name
fi

# Add user input to variables
toggle_1_entity =`echo "input_toggle_1" `
toggle_1_name =`echo "input_toggle_1_name" `
toggle_2_entity =`echo "input_toggle_2" `
toggle_2_name =`echo "input_toggle_2_name"`
toggle_3_entity =`echo "input_toggle_3"`
toggle_3_name =`echo "input_toggle_3_name"`
toggle_4_entity =`echo "input_toggle_4"`
toggle_4_name =`echo "input_toggle_4_name"`
toggle_5_entity =`echo "input_toggle_5"`
toggle_5_name =`echo "input_toggle_5_name"`
toggle_6_entity =`echo "input_toggle_6"`
toggle_6_name =`echo "input_toggle_6_name"`
toggle_7_entity =`echo "input_toggle_7"`
toggle_7_name =`echo "input_toggle_7_name"`
toggle_8_entity =`echo "input_toggle_8"`
toggle_8_name =`echo "input_toggle_8_name"`


# Create temporary folder
hasp_temp_dir =`mkdir -d`


# Download the necessary files
wget -q -P $hasp_temp_dir https://github.com/zonko16/Custom-Pages-for-HASwitchplate/raw/dev/packages_3.2in/3.2_packages.tar.gz
tar -zxf $hasp_temp_dir/packages.tar.gz -C $hasp_temp_dir
rm $hasp_temp_dir/packages.tar.gz

# Write Scripts Variables to yaml
sed -i -- 's/script.SCRIPT_1/' "$SCRIPT_1"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p2_scripts.yaml
sed -i -- 's/script.SCRIPT_2/' "$SCRIPT_2"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p2_scripts.yaml
sed -i -- 's/script.SCRIPT_3/' "$SCRIPT_3"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p2_scripts.yaml
sed -i -- 's/script.SCRIPT_4/' "$SCRIPT_4"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p2_scripts.yaml
sed -i -- 's/script.SCRIPT_5/' "$SCRIPT_5"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p2_scripts.yaml

# Write Toggles Page variables to yaml
sed -i -- 's/TOGGLE1_DUMMY/' "$toggle_1_entity"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE2_DUMMY/' "$toggle_2_entity"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE3_DUMMY/' "$toggle_3_entity"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE4_DUMMY/' "$toggle_4_entity"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE5_DUMMY/' "$toggle_5_entity"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE6_DUMMY/' "$toggle_6_entity"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE7_DUMMY/' "$toggle_7_entity"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE8_DUMMY/' "$toggle_8_entity"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE1/' "$toggle_1_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE2/' "$toggle_2_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE3/' "$toggle_3_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE4/' "$toggle_4_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE5/' "$toggle_5_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE6/' "$toggle_6_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE7/' "$toggle_7_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE8/' "$toggle_8_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
