#!/bin/bash

# Check for dependencies
if ! command -v jq &> /dev/null; then
    echo "Please install 'jq' to run this script."
    exit 1
fi

# Check if user passed coins
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 bitcoin ethereum solana"
    exit 1
fi

echo ""
echo "📈 Crypto Prices (Powered by CoinGecko)"
echo "--------------------------------------"

# Loop through each argument (coin)
for coin in "$@"; do
    response=$(curl -s "https://api.coingecko.com/api/v3/simple/price?ids=$coin&vs_currencies=usd")

    # Check if coin exists
    price=$(echo "$response" | jq -r ".${coin}.usd")
    if [ "$price" != "null" ]; then
        symbol=$(curl -s "https://api.coingecko.com/api/v3/coins/$coin" | jq -r '.symbol' | tr '[:lower:]' '[:upper:]')
        echo "🪙 $(echo $coin | sed 's/.*/\u&/') ($symbol): \$$price"
    else
        echo "❌ $coin not found on CoinGecko."
    fi
done

echo "--------------------------------------"
echo ""
