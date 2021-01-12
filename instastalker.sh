#!/bin/bash

# Name: Insta Stalker
# Author: Arya Narotama (4WSec)
# Github: github.com/aryanrtm
# Instagram: instagram.com/aryanrtm_
# Give me the credits if you recode this tool. Don't be a SKID!
# Insta Stalker is made with <3 by Arya Narotama - 2020

# User Agents
useragents="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0";

# Color
PP='\033[95m' # purple
CY='\033[96m' # cyan
BL='\033[94m' # blue
GR='\033[92m' # green
YW='\033[93m' # yellow
RD='\033[91m' # red
NT='\033[97m' # netral
GY='\033[90m' # grey
O='\e[0m' # nothing
B='\e[5m' # blink
U='\e[4m' # underline

# Cookies Config
igdid_1=$(curl https://www.instagram.com/ -L -i -s | grep "ig_did" | cut -d "=" -f2 | cut -d ";" -f1);
csrftoken_2=$(curl https://www.instagram.com/ -L -i -s | grep "csrftoken" | cut -d "=" -f2 | cut -d ";" -f1);
mid_3=$(curl https://www.instagram.com/ -L -i -s | grep -Po '(?<=set-cookie: mid=).*?(?=;)');


function banner () {
	printf "\n\t${RD}ＩｎｓｔａＳｔａｌｋｅｒ ${NT}{ ${GY}Made by 4WSec ${NT}}\n\n"
}

function check_username () {
	local chk=$(curl -s -A "${useragents}" "https://www.instagram.com/${username}" -o /dev/null)
	if [[ $chk =~ 'is_private": true' ]]; then
		printf " ${NT}[${RD}✘${NT}] ${RD}Private account\n"
		exit 0
	elif [[ $chk =~ "Sorry, this page isn't available." ]]; then
		printf " ${NT}[${RD}✘${NT}] ${RD}Username not found\n"
		exit 0
	else
		printf " ${NT}[${GR}✔${NT}] ${GR}Username found ...\n"
	fi
}

function get_profile () {
	local get_short_code=$(curl -s "https://www.instagram.com/${username}/?__a=1" | \
	                       jq -r '.graphql | .user | .edge_owner_to_timeline_media.edges[0]' | \
	                       grep -c "GraphImage");
	if [[ $get_short_code =~ '0' ]]; then
		printf " ${NT}[${RD}✘${NT}] ${RD}Failed to get shortcode ...\n"
		exit 0
	else
		local short_code=$(curl -s "https://www.instagram.com/${username}/?__a=1" | jq -r '.graphql | .user | .edge_owner_to_timeline_media.edges[0]' | grep -Po '(?<="shortcode": ").*?(?=")')
	fi

	wget -q -O profile.json \
    'https://www.instagram.com/graphql/query/?query_hash=d5d763b1e2acf209d62d22d184488e57&variables={"shortcode":"'$short_code'","include_reel":true,"first":5}'

	if [[ $(cat profile.json) =~ 'invalid query_hash' ]]; then
		printf " ${NT}[${RD}✘${NT}] ${RD}Failed to get stalkers ...\n"
		exit 0
	elif [[ $(cat profile.json) =~ '"shortcode_media":null' ]]; then
		printf " ${NT}[${RD}✘${NT}] ${RD}Failed to get stalkers ...\n"
		exit 0
	else
		printf " ${NT}[${GR}✔${NT}] ${GR}Success to get stalkers ...\n\n"
		local get_username1=$(cat profile.json | grep -Po '(?<="username":").*?(?=")' | uniq | head -1 | tail -1);
		local get_username2=$(cat profile.json | grep -Po '(?<="username":").*?(?=")' | uniq | head -2 | tail -1);
		local get_username3=$(cat profile.json | grep -Po '(?<="username":").*?(?=")' | uniq | head -3 | tail -1);
		local get_id1=$(cat profile.json | grep -Po '(?<="id":").*?(?=")' | uniq | head -2 | tail -1)
		local get_id2=$(cat profile.json | grep -Po '(?<="id":").*?(?=")' | uniq | head -3 | tail -1)
		local get_id3=$(cat profile.json | grep -Po '(?<="id":").*?(?=")' | uniq | head -4 | tail -1)

		echo -ne " --- ＲＥＳＵＬＴ ---\n"
		printf " ${NT}1) ${YW}${get_username1} (${get_id1})\n"
		printf " ${NT}2) ${YW}${get_username2} (${get_id2})\n"
		printf " ${NT}3) ${YW}${get_username3} (${get_id3})\n"
		rm -f profile.json
	fi
}

clear
banner
echo -ne " ${NT}[${YW}ツ${NT}] Enter Username: ${YW}"; read username;
check_username
get_profile