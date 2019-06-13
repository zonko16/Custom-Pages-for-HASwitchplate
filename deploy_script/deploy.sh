input_node_name = "$@"

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

if [ "$input_node_name" == "" ]
then
  read -e -p "Enter your HASP device name(Only lower case, numbers and _ allowed)" -i "plate01" input_node_name
fi

hasp_node = `echo "$input_node_name"

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
fi

if [ "$input_toggle_1_name" == "" ]
  read -e -p "Enter toggle_1 name:" -i "DUMMY" input_toggle_1_name
fi

if [ "$input_toggle_2"" == "" ]
  read -e -p "Enter toggle_2" entity id:" -i "DUMMY" input_toggle_2"
fi

if [ "$input_toggle_2_name" == "" ]
  read -e -p "Enter toggle_2 name:" -i "DUMMY" input_toggle_3_name
fi

if [ "$input_toggle_3" == "" ]
  read -e -p "Enter toggle_3 entity id:" -i "DUMMY" input_toggle_3
fi

if [ "$input_toggle_3_name" == "" ]
  read -e -p "Enter toggle_3 name:" -i "DUMMY" input_toggle_3_name
fi

if [ "$input_toggle_4" == "" ]
  read -e -p "Enter toggle_4 entity id:" -i "DUMMY" input_toggle_4
fi

if [ "$input_toggle_4_name" == "" ]
  read -e -p "Enter toggle_4 name:" -i "DUMMY" input_toggle_4_name
fi

if [ "$input_toggle_5" == "" ]
  read -e -p "Enter toggle_5 entity id:" -i "DUMMY" input_toggle_5
fi

if [ "$input_toggle_5_name" == "" ]
  read -e -p "Enter toggle_5 name:" -i "DUMMY" input_toggle_5_name
fi

if [ "$input_toggle_6" == "" ]
  read -e -p "Enter toggle_6 entity id:" -i "DUMMY" input_toggle_6
fi

if [ "$input_toggle_6_name" == "" ]
  read -e -p "Enter toggle_6 name:" -i "DUMMY" input_toggle_6_name
fi

if [ "$input_toggle_7" == "" ]
  read -e -p "Enter toggle_7 entity id:" -i "DUMMY" input_toggle_7
fi

if [ "$input_toggle_7_name" == "" ]
  read -e -p "Enter toggle_7 name:" -i "DUMMY" input_toggle_7_name
fi

if [ "$input_toggle_8" == "" ]
  read -e -p "Enter toggle_8 entity id:" -i "DUMMY" input_toggle_8
fi

if [ "$input_toggle_8_name" == "" ]
  read -e -p "Enter toggle_8 name:" -i "DUMMY" input_toggle_8_name
fi

# Add user input to variables
toggle_1 = `echo "input_toggle_1"`
toggle_1_name = `echo "input_toggle_1_name"`
toggle_2 = `echo "input_toggle_2"`
toggle_2_name = `echo "input_toggle_2_name"`
toggle_3 = `echo "input_toggle_3"`
toggle_3_name = `echo "input_toggle_3_name"`
toggle_4 = `echo "input_toggle_4"`
toggle_4_name = `echo "input_toggle_4_name"`
toggle_5 = `echo "input_toggle_5"`
toggle_5_name = `echo "input_toggle_5_name"`
toggle_6 = `echo "input_toggle_6"`
toggle_6_name = `echo "input_toggle_6_name"`
toggle_7 = `echo "input_toggle_7"`
toggle_7_name = `echo "input_toggle_7_name"`
toggle_8 = `echo "input_toggle_8"`
toggle_8_name = `echo "input_toggle_8_name"`

#Create temporary folder
hasp_temp_dir = `mkdir -d`

#

sed -i -- 's/TOGGLE1_DUMMY/' "$toggle_1"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE2_DUMMY/' "$toggle_2"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE3_DUMMY/' "$toggle_3"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE4_DUMMY/' "$toggle_4"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE5_DUMMY/' "$toggle_5"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE6_DUMMY/' "$toggle_6"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE7_DUMMY/' "$toggle_7"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE8_DUMMY/' "$toggle_8"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE1/' "$toggle_1_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE2/' "$toggle_2_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE3/' "$toggle_3_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE4/' "$toggle_4_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE5/' "$toggle_5_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE6/' "$toggle_6_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE7/' "$toggle_7_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
sed -i -- 's/TOGGLE8/' "$toggle_8_name"'/g' $hasp_temp_dir/packages/plate01/hasp_plate01_p6_toggles.yaml
