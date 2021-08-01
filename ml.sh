#!/bin/bash

unset parameterA parameterB

helpFunction()
{
   echo ""
   echo "Usage: $0 -i Page_Inicial -f Page_Final"
   echo -e "\t-i Inicial"
   echo -e "\t-f Final "
   #echo -e "\t-c Description of what is parameterC"
   #exit 1 # Exit script after printing help
   return
}

workFunction() {
A=(https://mx.mileroticos.com/masajes-eroticos/aguascalientes/?p= https://mx.mileroticos.com/escorts/aguascalientes/aguascalientes/?p=)

echo de "$parameterA a: $parameterB"
echo "$(date +"%m-%d-%Y %H:%M:%S") Run Script All_2 ML " >> LogScript01.log
Body=()

for h in "${A[@]}"; do 

for (( p = $parameterA ; p <= $parameterB ; p++ ))
do  

	if (( $p < 31 )) ;
	
	then
		echo "$h$p"
		echo "$(date +"%m-%d-%Y %H:%M:%S") ALL calling: $h$p" >> LogScript01.log
		curl -s -iL --max-redirs -1 "$h$p" > inicial_all
	else 
		echo "https://mx.mileroticos.com/listajax/escorts/aguascalientes/?p=$p"
		echo "$(date +"%m-%d-%Y %H:%M:%S") ALL calling: https://mx.mileroticos.com/listajax/escorts/aguascalientes/?p=$p" >> LogScript01.log
		curl -s -iL --max-redirs -1 "https://mx.mileroticos.com/listajax/escorts/aguascalientes/?p=$p" > inicial_all
	fi
	
	BASEURL='https://mx.mileroticos.com'
	
	IDS2=()
	IDS2=( $( grep -io '<a href=['"'"'"][^"'"'"']*['"'"'"]' inicial_all | sed -e 's/^<a href=["'"'"']//i' -e 's/["'"'"']$//i' | grep -E '\/[0-9]+\/' | grep -v -f pattern))
	b=1
	for i in "${IDS2[@]}"; do 
	echo "----> $(printf "%02d" $b)-"$BASEURL$i >> LogScript01.log
	
	let "b=b+1"
	done

	#echo ${IDS[*]} 
	#echo ${IDS[*]}
	#IDS[0]=Hola

	for i in "${IDS2[@]}"; do 
		TEL=""
		WHATS=""
		ID_M=""
		WEB=""
		FECHA=""
		DESC=""
		
		curl -s $BASEURL$i > curl_temp

		echo $i | grep -Eo '\/[0-9]+\/' | sed 's/^\///;s/\///g' >> pattern #Agrega ID A pattern
		
		echo $i 

		ID_M=$(echo $i | grep -Eo '\/[0-9]+\/' | sed 's/^\///;s/\///g')
		TEL=$(grep -m 1 -oP "tel:\K\d+" curl_temp)
		WHATS=$(grep -m 1 -oP "phone=52\K\d+" curl_temp)
		DESC=$(grep description-ad curl_temp | sed -e 's/<[^>]*>//g')


		if [ -z "$TEL" ]
		then
		TEL="null"
		fi
		
		if [ -z "$WHATS" ]
		then
		WHATS="null"
		fi	
		
		FOUND1=$(grep -E "${TEL}|${WHATS}" pattern_tel)
		FOUND2=$(echo "${DESC}" | grep -o -f pattern_tel)

		if [ -z "$FOUND1" ] && [ -z "$FOUND2" ]
		
			then
			WEB=$(echo $BASEURL$i)
			FECHA=$(grep -m1 " 2020"  curl_temp | sed -e 's/<[^>]*>//g' | tr -d '[:space:]')
			IMGS=($(grep "data-srcset" curl_temp |  grep -o "http*.*jpg" | sed -n -e 's/^.*w, //p'))
			
			c=1
			for i in "${IMGS[@]}"; do
			TMSTP=$(date +"%Y%m%d_%H%M%S")
			echo ""$TMSTP"-W-"$WHATS"_T-"$TEL"-"$ID_M"-$(printf "%02d" $c).jpg"
			FN=""$TMSTP"-W-"$WHATS"_T-"$TEL"-"$ID_M"-$(printf "%02d" $c).jpg"
			wget -q -O $FN $i
			let "c=c+1"
			done
			
			echo "---------------------" $(date +"%m-%d-%Y %H:%M:%S") >> nuevos
			echo "$WEB" >> nuevos #WEB
			echo "$DESC" >> nuevos #DESC
			echo "Whats:      $WHATS" >> nuevos #WHATS
			echo "TEL:        $TEL" >> nuevos 
			echo "Date Publi: $FECHA" >> nuevos #FECHA
			
			if [ "$TEL" = "null" ] ;
			then
				if [ "$WHATS" != "null" ]
				then
					echo $WHATS	>> pattern_tel #Agrega Telefono WA a Pattern Tel
				fi
			else
				echo $TEL >> pattern_tel #Agrega Telefono Normal a Pattern Tel
			fi
			
			Body+=($WEB)
			
		fi
		
		R=$(($RANDOM%8))
		echo "Waiting $R Seconds"
		sleep $R

	done
	sleep 10
done

done

if [ ${#Body[@]} -eq 0 ]; then
echo "No email to send..."
else
sendmail
fi

}
#shift "$(($OPTIND -1))"

sendmail()
{
echo "Sending Mail..."
printf '%s\n' "${Body[@]}" | mailx -r "NuevosAction <wallachete@gmail.com>" -s "NuevoValor" torreyes.magos@gmail.com
}


while getopts "i:f:p:" opt;
do
   case "$opt" in
      i ) parameterA="$OPTARG" ;;
      f ) parameterB="$OPTARG" ;;
      p ) parameterC="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done


# Print helpFunction in case parameters are empty
if [ -z "$parameterA" ] || [ -z "$parameterB" ] 
then
   echo "Some or all of the parameters are empty";
   helpFunction
else
workFunction
fi


