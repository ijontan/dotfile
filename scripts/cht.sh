#! /bin/bash

languages=`echo "c cpp typescript nodejs" | tr ' ' '\n'`
core_utils=`echo "xargs find mv sed awk" | tr ' ' '\n'`

selected=`printf "$languages\n$core_utils" | fzf`
read -p "query: " query

if printf $languages | grep -qs $selected; then
	curl cht.sh/$selected/`echo $query | tr ' ' '+'`
else
	curl cht.sh/$selected~$query
fi
