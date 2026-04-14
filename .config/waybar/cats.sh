#!/usr/bin/env bash

CAT_LIST=(
  "  /•᷅‎‎•᷄\੭  "
  " (•˕ •マ.ᐟ "
  "  ฅ^._.^ฅ  "
  "≽ ^⎚ ˕ ⎚^ ≼"
  "(˵◝ ⩊  ◜˵マ"
  "  ₍^. .^₎Ⳋ "
)

count=${#CAT_LIST[@]}
index=$((RANDOM % count))
echo "${CAT_LIST[$index]}"
