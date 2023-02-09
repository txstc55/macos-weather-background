#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd ) ## get the script's directory
callSCPT(){
    rm $SCRIPT_DIR/changeBG.scpt
    echo 'tell application "System Events"' >> $SCRIPT_DIR/changeBG.scpt
    echo '  tell every desktop' >> $SCRIPT_DIR/changeBG.scpt
    echo "        set picture to \"$1\"" >> $SCRIPT_DIR/changeBG.scpt
    echo '    end tell' >> $SCRIPT_DIR/changeBG.scpt
    echo 'end tell' >> $SCRIPT_DIR/changeBG.scpt ## run the script
    osascript $SCRIPT_DIR/changeBG.scpt
}


changeBGByWeather(){
    weather=$(curl -s 'wttr.in/?format="%C"') ## get the weather condition
    weather=$(echo $weather|tr -d '"'|tr '[:upper:]' '[:lower:]') ## remove the trailing ""
    if [[ $weather ]]
    then
        weather_pictures=()
        # echo "${weather_pictures[@]}"
        for dir in "$SCRIPT_DIR"/*; ## for each file/dir in this folder
        do
        	if [[ -d $dir ]] ## check if it is a folder
        		then
        			if [[ "$dir" == *"$weather"* ]] ## if the directory contains the 
        			then
                        ## first, we find all the files, then we grep the images, then we cut the images to a substring, then remove the extra characters
                        variable=$(find $dir -name '*' -exec file {} \; | grep -o -E '^.+: \w+ image' | grep -o -E '^.+:' | rev | cut -c2- |rev);
                        ## add the variable in picture list
                        weather_pictures+=($variable);
        			fi
        		fi
        done
        if [ ${#weather_pictures[@]} -eq 0 ]; 
            then
                if grep -Fxq $weather extra_weather_list.txt
                then
                    echo "Extra weather already in list";
                else
                    echo $weather >> $SCRIPT_DIR/extra_weather_list.txt;
                fi 
        else
            echo "Pictures found: ${weather_pictures[@]}";
            size=${#weather_pictures[@]}
            index=$(($RANDOM % $size))
            random_picture=$(realpath ${weather_pictures[$index]})
            callSCPT $random_picture
        fi
    else 
        $random_picture=$(realpath "./default/default.jpg")
        callSCPT $random_picture
        echo "Network not connected";
    fi
}

changeBGByWeather
