#!/bin/bash

filename="/home/paulfantom/.bin/drinks"

function show_drink
{
	if [ -z "$drinkName" ]; then
		echo "Enter name of a drink or leave blank"
		read drinkName
		clear
		echo
	fi
	if [ "$drinkName" ];then
        re='^[0-9]+$'
        if [[ "$drinkName" =~ $re ]]; then
            line=$drinkName
        else
    		line=$(cat $filename | grep -in "NAME: " | grep -in "$drinkName" | tail -n 1 | awk -F ":" '{print $2}')
        fi
		line3=$(($line + 3))
		if [ $line ]; then
			exec cat $filename  | sed -n "$line","$line3"p  \
							| sed "s|NAME: ||" \
							| sed "s|GLASS: | Serve in |" \
							| sed "s|INGRIDIENTS: |  Using |" \
							| sed "s|PREPARATION: |    |"

		else
			echo "There is no drink with this name in database"
		fi
		drinkName=
	fi
}

function match_ingridients
{
	clear
	echo "Up to 10 ingridients"
	for ingNumber in {1..10}
	do
		echo "Enter name of ingridient no.$ingNumber or press ENTER to continue"
		read ingArray[$ingNumber]
		if [ -z ${ingArray[$ingNumber]} ]; then
			break
		fi
	done

	clear
	cat $filename | grep -n -i -e "TAGS: \(.*\) ${ingArray[1]}" | grep -i "${ingArray[2]}" \
			| grep -i "${ingArray[3]}" | grep -i "${ingArray[4]}" \
			| grep -i "${ingArray[5]}" | grep -i "${ingArray[6]}" \
			| grep -i "${ingArray[7]}" | grep -i "${ingArray[8]}" \
			| grep -i "${ingArray[9]}" | grep -i "${ingArray[10]}" \
			| awk -F ":" '{print $1 $3} {print "     " $NF}'
# 	TODO:
# 	if only one drink in output then display it without prompting for a name
	echo
	echo "Which one (number or name)?"
	drinkName=
	show_drink
	
}

function new_drink
{
	clear
	echo "   Enter name of a drink"
	read name
	name=$(echo $name | tr " " "\n" \
		| awk ' { out = out" "toupper(substr($0,1,1))substr($0,2) } END{ print substr(out,2) } ')
	echo
	
	echo "   In what glass type $name is served?"
	echo "   Long/Short/Coctail/Shot or a different type (what?)"
	read glassType
	glassType=$(echo $glassType | tr " " "\n" \
		| awk ' { out = out" "toupper(substr($0,1,1))substr($0,2) } END{ print substr(out,2) } ')
	echo

	echo "   Enter ingridients separated with comma"
	read ingridients

	OLD_IFS="$IFS"
	IFS=","
	ingArray=($ingridients)
	IFS="$OLD_IFS"

	ingridientsWithAmount=

	for i in "${!ingArray[@]}"
	do
		echo
		echo "How much of ${ingArray[$i]}?"
		read amount
		ingridientsWithAmount+="$amount ${ingArray[$i]}, "
	done

	echo
	echo "Enter preparation method"
	read preparation

	clear
	echo "TAGS: $name: $ingridients" 
	echo "NAME: $name"
	echo "GLASS: $glassType"
	echo "INGRIDIENTS: $ingridientsWithAmount"
	echo "PREPARATION: $preparation"
	echo
	echo "Is this correct (y/n)?"
	read yesNo
	if [ $yesNo == 'y' ]; then
		echo " " >> $filename
		echo "TAGS: $name: $ingridients" >> $filename
		echo "NAME: $name" >> $filename
		echo "GLASS: $glassType glass" >> $filename
		echo "INGRIDIENTS: $ingridientsWithAmount" >> $filename
		echo "PREPARATION: $preparation" >> $filename
	fi
	echo
}

function show_drinks_names
{
	j=0
	i=0
	line=2
	letter=0
	clear
	echo "Enter first letter of a drink or type 'all'"
	read letter
	letter=$( echo $letter | tr [:lower:] [:upper:])

#	drinksNumber=$( exec cat $filename | grep "NAME:" | wc -l)
	drinksNumber=$( exec cat $filename | grep -c "NAME:" )
	
	while [ $j -le $drinksNumber ]; do
		drinksCheck=$( exec cat $filename | sed -n "$line"p | sed "s|NAME: ||" )
		if [ $letter == "ALL" ]; then
			drinks[$j]=$drinksCheck
		elif [ "${drinksCheck:0:1}" == "$letter" ]; then
			drinks[$i]=$drinksCheck
			i=`expr $i + 1`
		fi
		j=`expr $j + 1`
		line=`expr $line + 6`
	done
	
	readarray -t drinks< <(for a in "${drinks[@]}"; do echo "$a"; done | sort )
	
	clear
	for a in "${drinks[@]}"; do echo "$a"; done
	unset drinks
}

function random_drink
{
	j=0
	line=2
#	drinksNumber=$( exec cat $filename | grep "NAME:" | wc -l)
	drinksNumber=$( exec cat $filename | grep -c "NAME:" )
	while [ $j -le $drinksNumber ]; do
		drinks[$j]=$( exec cat $filename | sed -n "$line"p | sed "s|NAME: ||" )
		j=`expr $j + 1`
		line=`expr $line + 6`
	done
	number=$( exec shuf -i 0-$drinksNumber -n 1 )
	drinkName=${drinks[$number]}
	clear
	show_drink
}

#MAIN
clear
	echo "              Let's start"
	echo
while true
do
	echo "***************************************"
	echo "*| Match ingridients with drinks (i) |*"
	echo "*| Find drink by name            (d) |*"
	echo "*| Random drink                  (r) |*"
	echo "*| List all drinks               (l) |*"
	echo "*| Add new drink                 (n) |*"
	echo "***************************************"
	echo "            Enter i/d/r/l/n"
	read chooser
	
	if   [ $chooser == 'i' ]; then
		match_ingridients
		echo
	elif [ $chooser == 'n' ]; then
		new_drink
	elif [ $chooser == 'l' ]; then
		show_drinks_names
		echo
	elif [ $chooser == 'r' ]; then
		random_drink
		echo
	elif [ $chooser == 'd' ]; then
		clear
		show_drink
		echo
 	else
		echo "Wrong key pressed"
# 		clear
# 		show_drink
# 		echo
	fi

	echo "Do you want to try again (y/n)?"
	read yesNo
	if [ $yesNo != 'y' ]; then
		break
	fi
	clear
done

exit 0
