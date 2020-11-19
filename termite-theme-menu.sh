#!/bin/bash
# Brings up a menu themes for termite and changes bg transparency.

function show_menu {
    # pipes ls into rofi to make a menu of the themes from favethemes folder storing the selection
    selection=$(ls $HOME/.config/termite/favethemes | rofi -dmenu -l 20 -width 25 -p "Enter 0-100 or 'All' or Select theme") 

    if [[ $selection =~ ^[Aa]([Ll]{2})?$ ]]; then
        all_themes_menu

    elif [[ $selection =~ ^(100|[0-9]?[0-9])$ ]]; then
        change_transparency

    else
        # check for valid input
        if [[ ! $(ls $HOME/.config/termite/favethemes) =~ $selection ]]; then
            echo "$selection is not for hunks!" | rofi -dmenu -l 2 -width 20 -p "Just hunks"
            exit
        fi

        # exit the script if empty selection
        if [[ -z $selection ]] ; then
            exit
        fi

        # this adds the file path to the selected theme
        theme=$HOME/.config/termite/favethemes/$selection
        change_theme
    fi
}


function all_themes_menu {
    # bring up menu of all themes and store selection
    theme=$(ls $HOME/.config/termite/base16-termite/themes | rofi -dmenu -l 40 -width 25 -p "Select terminal theme") 
    if [[ !  $(ls $HOME/.config/termite/base16-termite/themes) =~ $theme ]]; then
        echo "$theme is not for hunks!" | rofi -dmenu -l 2 -width 20 -p "Just hunks"
        exit
    fi

    # exit script if empty input
    if [[ -z $theme ]] ; then
        exit
    fi

    # add full file path to selection
    theme=$HOME/.config/termite/base16-termite/themes/$theme
    change_theme
}


function change_transparency {
    alpha=$selection
    export alpha

    # format the alpha value so it is .00 through 1
    if [[ $alpha =~ 100 ]]; then
      alpha=1
    elif [[ $alpha =~ ^[0-9]$ ]]; then
      alpha=.0$alpha
    else
      alpha=.$alpha
    fi

    # use perl search and replace to edit only the alpha value in the config file
    perl -pi -e 's/(background = rgba\(\d+, \d+, \d+,).*/$1 $ENV{alpha})/g;' $HOME/.config/termite/config
    # reload all termites
    killall -USR1 termite
}


function change_theme {
    config_file=$HOME/.config/termite/config
    # 'cuts' all lines from [colors] to the end of the config file
    sed -i '/\[colors\]/Q' $config_file

    cat $theme >> $config_file
    bghex=$(egrep "^background\s+=" $theme | awk '{print substr($3, 2)}')

    # Generates transparent background and pastes at bottom of config file. 
    echo -e "\n# background color with transparency" >> $config_file
    printf "background = rgba(%d, %d, %d, 0.85)" 0x${bghex:0:2} 0x${bghex:2:2} 0x${bghex:4:2} >> $config_file
    echo -e "\n" >> $config_file

    # This reloads all termite instances in place so that new colors take effect
    killall -USR1 termite
}


# main loop exits on an error or by closing rofi via escape with no selection
while true; do
    show_menu
done
