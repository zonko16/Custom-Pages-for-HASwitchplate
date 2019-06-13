input_node_name = "$@"
# Page 2 Scripts
input_script_1 = "$@"
input_script_2 = "$@"
input_script_3 = "$@"
input_script_4 = "$@"
input_script_5 = "$@"

input_script_1_name = "§@"
input_script_2_name = "§@"
input_script_3_name = "§@"
input_script_4_name = "§@"
input_script_5_name = "§@"

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
input_media_player =




if [ "$input_node_name" == "" ]
then
  read -e -p "Enter your HASP device name(Only lower case, numbers and _ allowed)" -i "plate01" input_node_name
fi

hasp_node = `echo "$input_node_name"`


# Page 2 scripts setup
echo "Page 2: Scripts Setup"
echo ""
echo "Enter script entity IDs (i.e. script.living_room)"
echo "Script 1: bottom - Script_5: top"

if [ "$input_script_1" == ""]
then
  read -e -p "Enter script_1:" -i "script.SCRIPT_1" input_script_1
  read -e -p "Enter script_2:" -i "script.SCRIPT_2" input_script_2
  read -e -p "Enter script_3:" -i "script.SCRIPT_3" input_script_3
  read -e -p "Enter script_4:" -i "script.SCRIPT_4" input_script_4
  read -e -p "Enter script_5:" -i "script.SCRIPT_5" input_script_5
fi

SCRIPT_1 =`echo "input_script_1"`
SCRIPT_2 =`echo "input_script_2"`
SCRIPT_3 =`echo "input_script_3"`
SCRIPT_4 =`echo "input_script_4"`
SCRIPT_5 =`echo "input_script_5"`



echo "Page 6: Toggles Setup"
echo ""
echo "Enter entity IDs and names for each switch."
echo "The switches will be ordered using following schema:"
echo ""
echo "toggle_1 - toggle_2"
echo "toggle_3 - toggle_4"
echo "toggle_5 - toggle_6"
echo "toggle_6 - toggle_7"

if [ "$input_toggle_1" == "" ]
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
