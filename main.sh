#!/bin/bash

# Clear the screen
clear

# VARIABLES

# Colors
RED="\e[31m"        # Classic RED
GREEN="\e[32m"      # Classic GREEN
YELLOW="\e[33m"     # Classic YELLOW
BLUE="\e[34m"       # Classic BLUE
PURPLE="\e[35m"     # Classic PURPLE
CYAN="\e[36m"       # Classic CYAN
BOLD="\e[1m"        # Bold text
NE="\e[0m"          # No color

# Functions

print_header() {
    echo -e "${PURPLE}________                                ___________________         "
    echo -e "___  __ )_____ _________________ __________  ____/__  /__(_)_______ "
    echo -e "__  __  |  __ '/__  /__  /_  __ '/_  ___/_  /_   __  /__  /___  __ \\"
    echo -e "_  /_/ // /_/ /__  /__  /_/ /_/ /_  /   _  __/   _  / _  / __  /_/ /"
    echo -e "/_____/ \\__,_/ _____/____/\\__,_/ /_/    /_/      /_/  /_/  _  .___/ "
    echo -e "                                                           /_/      ${NE}"
    echo -e "{+}=============================================={+}"
    echo -e "${GREEN}       *** Created By Trabbit For Xavier *** ${NE}"
    echo -e "{+}=============================================={+}"
}

print_menu() {
    echo
    echo -e "    [${YELLOW}1${NE}] - Museum Weapons Datas"
    echo -e "    [${YELLOW}2${NE}] - Bazaar Items Datas"
    echo -e "    [${YELLOW}3${NE}] - Exit Menu"
    echo
    echo -e "{+}=============================================={+}"
}

MENU() {
    while true; do
        clear
        print_header
        print_menu
        echo
        local prompt=$(echo -e "${CYAN}[${RED}Xavier${YELLOW}@${GREEN}Minecraft]~${CYAN}#${NE} ")
        read -p "$prompt" input
        case $input in
            1)
                bash museum_weapons.sh
                read -p "Press Enter To Continue..."
                ;;
            2)
                bash bazzar.sh
                read -p "Press Enter To Continue..."
                ;;
            3)
                echo -e "${BOLD}${GREEN}Exiting the menu. Goodbye!${NE}"
                break
                ;;
            *)
                echo -e "${BOLD}${RED}ERROR:${NE} Invalid Choice! Please try again."
                read -p "Press Enter To Continue..."
                ;;
        esac
    done
}

# Main function
main() {
    MENU
}

# Call the main function
main
