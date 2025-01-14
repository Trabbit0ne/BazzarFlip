#!/bin/bash

# Clear temp_list.txt
echo "" > temp_list.txt
clear

# Function to fetch the buy price and XP for a single item
fetch_info() {
    local item="$1"
    local response=$(curl -s "https://sky.coflnet.com/api/item/price/$item/current")
    
    # Check if the response is valid
    if [[ $? -ne 0 ]]; then
        echo "Failed to fetch data for $item"
        return
    fi

    local price=$(echo "$response" | jq -r '.buy')
    local available=$(echo "$response" | jq -r '.available')

    # Fetch XP from the HTML content
    local xp=$(curl -s https://wiki.hypixel.net/Museum#Armor_ | \
        grep -A 2 "$item" | \
        grep -oP '<td style="text-align:center"><span class="color-aqua">\K[^<]+' | \
        head -n 1)

    # Check for price and availability
    if [[ "$price" == "0.0" || "$available" -le 0 || "$xp" == "" ]]; then
        echo "$item: No valid data"
        return 1  # Skip this item
    fi

    # Remove .0 from the price
    price=${price%.0}
    xp=${xp//[[:space:]]/}  # Remove any whitespace

    # Calculate price per XP
    local price_per_xp=$(echo "scale=2; $price / $xp" | bc)

    # Print the item, its price, XP, and price per XP
    printf "%-30s %-15s %-15s %-15s\n" "$item" "$price Coins" "     $xp" "$price_per_xp Coins"
}

# Fetch armor item names from the Hypixel Wiki Armor section
item_tags=$(curl -s https://wiki.hypixel.net/Museum#Armor_ | \
awk '/<div id="Armor_"/,/<\/div>/' | \
grep -oP '<a [^>]*title="\K[^"]*' | \
sort | uniq | sed 's/ /_/g')

# Print header
printf "%-30s %-15s %-15s %-15s\n" "Item" "Buy Price" "SkyBlock XP" "Price per XP"
printf "%-30s %-15s %-15s %-15s\n" "------------------------------" "--------------" "--------------" "--------------"

# Use a loop to fetch info for each item
for item in $item_tags; do
    fetch_info "$item"
done
