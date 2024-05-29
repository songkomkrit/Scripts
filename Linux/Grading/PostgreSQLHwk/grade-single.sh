#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -s sleep -n sqlnum -p password -d dirpath"
   echo -e "\t-s Sleep time (in seconds)"
   echo -e "\t-n SQL homework number"	# for example, 1
   echo -e "\t-p Password"
   echo -e "\t-d Directory path"	# for example, hwk-01/submit-01/0000000000_FirstLast_As09
   exit 1 # Exit script after printing help
}

while getopts "s:n:p:d:" opt
do
   case "$opt" in
      s ) sleep="$OPTARG" ;;
      n ) sqlnum="$OPTARG" ;;
      p ) password="$OPTARG" ;;
      d ) dirpath="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$sleep" ] || [ -z "$sqlnum" ] || [ -z "$password" ] || [ -z "$dirpath" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct

export PGPASSWORD="$password"

info=$(basename -- "$dirpath")
id=$(echo $info | cut  -d'_' -f1)
fullname=$(echo $info | cut  -d'_' -f2)
firstname=$(echo $fullname | grep -oE '[A-Z]+[^A-Z]+?' | head -n1)
lastname=$(echo $fullname | grep -oE '[A-Z]+[^A-Z]+?' | tail -1)

str_sqlnum="$sqlnum"
[[ $sqlnum =~ ^[1-9]$ ]] && str_sqlnum="0$sqlnum"

asnum=$(($sqlnum + 8))
str_asnum="$asnum"
[[ $asnum =~ ^[1-9]$ ]] && str_asnum="0$asnum"

anstxtdir="hwk-${str_sqlnum}/result-${str_sqlnum}"
total_pts=0

# id, first, last, time, q1, ..., total, final
scorefile="hwk-${str_sqlnum}/score-${str_sqlnum}/score-${str_sqlnum}-run.csv"

echo "-----------------------------------------"
echo "GRADING ASSIGNMENT $str_asnum (SQL $str_sqlnum)"
echo "-----------------------------------------"
echo "STUDENT NAME: $firstname $lastname"
echo "STUDENT ID: $id"
echo "-----------------------------------------"

echo -n -e "\n$id,$firstname,$lastname,$(date +%T)," >> $scorefile

case $sqlnum in
	1) dbname="ordersystem" ;;
	2) dbname="banking" ;;
	3) dbname="osmall" ;;
esac

psql --quiet -c "drop database if exists $dbname;"
psql --quiet -c "create database ${dbname} with template ${dbname}0;"
echo
echo "-----------------------------------------"

# SQL 2
if [[ $sqlnum == 2 ]]; then
	fnameArr=("get_customers_with_sum_balance"
			  "get_all_customers_with_their_level"
			  "get_branches_assets_greater_than"
			  "address_audit")
			  
	for i in ${!fnameArr[@]}; do
		echo "QUESTION $(($i + 1)): ${fnameArr[i]}"
		psql $dbname -X -A -t --quiet < "$dirpath/${fnameArr[i]}.sql"
		case $i in
			0) query="select * from ${fnameArr[$i]}();" ;;
			1) query="select * from ${fnameArr[$i]}();" ;;
			2) query="select * from ${fnameArr[$i]}(100);" ;;
			3) query="select * from address_audit_log;" ;;
		esac
		psql $dbname -X -A -t --quiet -c "$query" | tee "tmp.txt"
		
		sleep $sleep
		yournumline=$(wc -l < tmp.txt)
		echo
		echo "COMPARE {YOUR QUERY} WITH {ANSWER QUERY}"
		echo
		
		ansnumline=$(wc -l < "$anstxtdir/result-${fnameArr[i]}.txt")
		diff -y -W 70 --suppress-common-lines "tmp.txt" "$anstxtdir/result-${fnameArr[i]}.txt"
		if [[ $? == "0" ]]
		then
		  echo "COMPARE RESULT: Same"
		  cur_status="CORRECT"
		  cur_pts=1
		else
		  echo "COMPARE RESULT: Different"
		  cur_status="INCORRECT"
		  cur_pts=0
		fi
		echo -n -e "$cur_pts," >> $scorefile
		total_pts=$(($total_pts + $cur_pts))

		rm tmp.txt
		echo
		echo "NUMBER OF LINES IN OUTPUT TEXT FILE"
		echo -e "\t YOUR QUERY: $yournumline"
		echo -e "\t ANSWER QUERY: $ansnumline"
		echo
		echo "YOUR ANSWER FOR QUESTION ${str_qnum}: ${cur_status} (${cur_pts} point)"
		echo
		echo "-----------------------------------------"		
	done


# SQL 1 or 3
elif [[ $sqlnum == 1 ]] || [[ $sqlnum == 3 ]]; then
	for file in $dirpath/*; do
		str_qnum=$(echo $(basename -- "$file") | cut  -d'.' -f1)
		echo "QUESTION $str_qnum"
		psql "$dbname" -X -A -t --quiet < "$file" | tee "tmp.txt"
		sleep $sleep
		yournumline=$(wc -l < tmp.txt)
		echo
		echo "COMPARE {YOUR QUERY} WITH {ANSWER QUERY}"
		echo
		
		ansnumline=$(wc -l < "$anstxtdir/result-${str_qnum}.txt")
		diff -y -W 70 --suppress-common-lines "tmp.txt" "$anstxtdir/result-${str_qnum}.txt"
		if [[ $? == "0" ]]
		then
		  echo "COMPARE RESULT: Same"
		  cur_status="CORRECT"
		  cur_pts=1
		else
		  echo "COMPARE RESULT: Different"
		  cur_status="INCORRECT"
		  cur_pts=0
		fi
		echo -n -e "$cur_pts," >> $scorefile
		total_pts=$(($total_pts + $cur_pts))

		rm tmp.txt
		echo
		echo "NUMBER OF LINES IN OUTPUT TEXT FILE"
		echo -e "\t YOUR QUERY: $yournumline"
		echo -e "\t ANSWER QUERY: $ansnumline"
		echo
		echo "YOUR ANSWER FOR QUESTION ${str_qnum}: ${cur_status} (${cur_pts} point)"
		echo
		echo "-----------------------------------------"
	done
fi

case $sqlnum in
	1) full_pts=10 ;;
	2) full_pts=20 ;;
	3) full_pts=10 ;;
esac

case $sqlnum in
	1) final_pts=$(( $total_pts > 10 ? 10 : total_pts )) ;;
	2) final_pts=$(($total_pts * 5)) ;;
	3) final_pts=${total_pts} ;;
esac

echo -n -e "${total_pts},${final_pts}" >> $scorefile

echo "SUMMARY:"
echo -e "\t Answer ${total_pts} questions correctly"
echo -e "\t FINAL POINTS = ${final_pts} (out of ${full_pts})"
