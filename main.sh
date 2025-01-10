#!/bin/bash

# Clear the screen
clear

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# VARIABLES
api_url="https://sky.coflnet.com/api/flip/bazaar/spread"

use_api() {
    # Fetch the data from the API and parse it with jq, formatting it into a table
    curl -s "$api_url" | jq -r '.[] | select(.flip.buyPrice != null and .flip.sellPrice != null and .flip.profitPerHour != null) | [.itemName, .flip.buyPrice, .flip.sellPrice, .flip.profitPerHour] | @tsv' | \
    while IFS=$'\t' read -r itemName buyPrice sellPrice profitPerHour; do
        echo -e "${BLUE}$(printf "%-30s" "$itemName")${NC} ${GREEN}$(printf "%-15s" "$buyPrice")${NC} ${YELLOW}$(printf "%-15s" "$sellPrice")${NC} ${RED}$(printf "%-20s" "$profitPerHour")${NC}"
    done
}

main() {
    # Print header with colors
    echo -e "${BLUE}Item Name                      Buy Price      Sell Price     Profit Per Hour${NC}"
    echo "---------------------------------------------------------------"
    use_api
}

main
