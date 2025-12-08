#!/bin/bash

# Test script to verify API route caching behavior on Launch
# This script tests if API routes without explicit cache headers are cached by default

API_URL="https://astro-example-starter.devcontentstackapps.com/api-test-no-cache"

echo "=========================================="
echo "API Route Caching Test"
echo "=========================================="
echo ""
echo "Testing: $API_URL"
echo ""

echo "=== Test 1: First Request ==="
echo "Making first request..."
RESPONSE1=$(curl -s "$API_URL")
TIMESTAMP1=$(echo "$RESPONSE1" | grep -o '"timestamp":"[^"]*"' | cut -d'"' -f4)
RANDOM1=$(echo "$RESPONSE1" | grep -o '"randomNumber":[0-9]*' | cut -d':' -f2)

echo "Response:"
echo "$RESPONSE1" | jq '.' 2>/dev/null || echo "$RESPONSE1"
echo ""
echo "Timestamp: $TIMESTAMP1"
echo "Random Number: $RANDOM1"
echo ""

echo "=== Test 2: Second Request (Immediate) ==="
echo "Making second request immediately..."
sleep 1
RESPONSE2=$(curl -s "$API_URL")
TIMESTAMP2=$(echo "$RESPONSE2" | grep -o '"timestamp":"[^"]*"' | cut -d'"' -f4)
RANDOM2=$(echo "$RESPONSE2" | grep -o '"randomNumber":[0-9]*' | cut -d':' -f2)

echo "Response:"
echo "$RESPONSE2" | jq '.' 2>/dev/null || echo "$RESPONSE2"
echo ""
echo "Timestamp: $TIMESTAMP2"
echo "Random Number: $RANDOM2"
echo ""

echo "=== Test 3: Cache Headers ==="
echo "Checking cache headers..."
HEADERS=$(curl -I -s "$API_URL")
echo "$HEADERS" | grep -iE "cache|cf-cache|age"
echo ""

echo "=== Analysis ==="
if [ "$TIMESTAMP1" = "$TIMESTAMP2" ] && [ "$RANDOM1" = "$RANDOM2" ]; then
    echo "❌ RESULT: API route IS CACHED (values are identical)"
    echo "   - This means API routes ARE cached by default"
    echo "   - Documentation needs to be updated"
else
    echo "✅ RESULT: API route IS NOT CACHED (values are different)"
    echo "   - This means API routes are NOT cached by default"
    echo "   - Documentation is correct"
fi
echo ""

CF_CACHE_STATUS=$(echo "$HEADERS" | grep -i "cf-cache-status" | cut -d':' -f2 | tr -d ' ')
if [ "$CF_CACHE_STATUS" = "HIT" ]; then
    echo "⚠️  cf-cache-status: HIT (served from cache)"
elif [ "$CF_CACHE_STATUS" = "MISS" ]; then
    echo "ℹ️  cf-cache-status: MISS (not from cache)"
elif [ "$CF_CACHE_STATUS" = "BYPASS" ]; then
    echo "ℹ️  cf-cache-status: BYPASS (cache bypassed)"
else
    echo "ℹ️  cf-cache-status: $CF_CACHE_STATUS"
fi

echo ""
echo "=========================================="

