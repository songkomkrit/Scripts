#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -s sleep -n sqlnum -x expdf"
   echo -e "\t-s Sleep time (in seconds)"
   echo -e "\t-n SQL homework number"	# for example, 1
   # for example, hwk-01/submit-01/0000000000_FirstLast_As09
   echo -e "\t-x Export pdf (true or false)"
   exit 1 # Exit script after printing help
}

while getopts "s:n:x:" opt
do
   case "$opt" in
   	  s ) sleep="$OPTARG" ;;
      n ) sqlnum="$OPTARG" ;;
      x ) expdf="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$sleep" ] || [ -z "$sqlnum" ] || [ -z "$expdf" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct

read -s -p "Enter PostgreSQL password: " password
echo
echo
export PGPASSWORD="$password"
echo

str_sqlnum="$sqlnum"
[[ $sqlnum =~ ^[1-9]$ ]] && str_sqlnum="0$sqlnum"

maindirpath="hwk-${str_sqlnum}/submit-${str_sqlnum}"
outtxtdirpath="hwk-${str_sqlnum}/report-txt-${str_sqlnum}"
outpdfdirpath="hwk-${str_sqlnum}/report-pdf-${str_sqlnum}"

scorefile="hwk-${str_sqlnum}/score-${str_sqlnum}/score-${str_sqlnum}-run.csv"
echo -n -e "id,first,last,time," >> $scorefile

case $sqlnum in
	1) numq=16 ;;
	2) numq=4 ;;
	3) numq=10 ;;
esac

for i in {1..$numq}; do
	echo -n -e "q$i," >> $scorefile
done

echo -n -e "total,final" >> $scorefile

for student_dir in $maindirpath/*; do
	info=$(basename -- $student_dir)
	id=$(echo $info | cut  -d'_' -f1)
	fullname=$(echo $info | cut  -d'_' -f2)
	firstname=$(echo $fullname | grep -oE '[A-Z]+[^A-Z]+?' | head -n1)
	lastname=$(echo $fullname | grep -oE '[A-Z]+[^A-Z]+?' | tail -1)
	outname="sql-${str_sqlnum}-grading-${id}-${firstname}-${lastname}"
	echo $outname

	./grade-single.sh -s $sleep -n $sqlnum -p $password -d $student_dir | tee "${outtxtdirpath}/${outname}.txt"
	sleep $sleep 
	if $expdf; then
		cupsfilter "${outtxtdirpath}/${outname}.txt" > "${outpdfdirpath}/${outname}.pdf"
	fi
done
