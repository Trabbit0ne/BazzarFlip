#!/bin/bash

# Clear temp_list.txt
echo "" > temp_list.txt
clear

# Check for required dependencies
if ! command -v jq &> /dev/null || ! command -v parallel &> /dev/null; then
    echo "Dependencies jq and/or parallel are not installed."
    exit 1
fi

# Fetch item tags from the API and replace spaces with underscores
item_tags=$(curl -s https://wiki.hypixel.net/Museum | \
awk '/<div id="Weapons_"/,/<\/div>/' | \
grep -oP '<a [^>]*title="\K[^"]*' | \
sort | uniq | sed 's/ /_/g')

# Print header
printf "%-30s %-15s %-15s %-15s\n" "Item" "Buy Price" "SkyBlock XP" "Price per XP"
printf "%-30s %-15s %-15s %-15s\n" "------------------------------" "--------------" "--------------" "--------------"

# Function to fetch the buy price and XP for a single item
fetch_info() {
    local item="$1"
    local response=$(curl -s "https://sky.coflnet.com/api/item/price/$item/current")
    local price=$(echo "$response" | jq -r '.buy')
    local available=$(echo "$response" | jq -r '.available')

    # Fetch XP from the HTML content
    local xp=$(curl -s https://wiki.hypixel.net/Museum | \
        awk -v item="$item" '/<tr>/,/<\/tr>/' | \
        grep -A 2 "$item" | \
        grep -oP '<td style="text-align:center"><span class="color-aqua">\K[^<]+' | \
        head -n 1)

    # Check for price and availability
    if [[ "$price" == "0.0" || "$available" -le 0 || "$xp" == "" ]]; then
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

# Export the function for parallel processing
export -f fetch_info

# Use parallel to fetch prices and XP for all items concurrently
echo "$item_tags" | tr ' ' '\n' | parallel -j 1 fetch_info | tee temp_list.txt

# Sort and display the results
clear
cat temp_list.txt | sort -k4 -nr
