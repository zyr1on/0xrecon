#!/bin/bash

start=`date +%s`

if [[ $(ls scan/ &>/dev/null;echo $?) -eq 2 ]]; then
	mkdir scan/
	printf "[+] Scan file created. Data will be stored there: $(pwd)/scan \n"
else
	printf "[!] Old Scan file found. If you do not delete it, the data will be overwritten. Delete? y/n>> "
	read scan_data
	if [ "$scan_data" = "yes"  ] || [ "$scan_data" = "y" ];then
		rm -rf scan
      		mkdir scan
	else
		printf "[?] Data overwriting to $(pwd)/scan \n"
	fi
fi

printf "[?] Enter Target>> "
read target
printf "[?] Enter Pattern gf >> "
read pattern
printf "[?] Enter Payload as Placeholder to add paramaters>> "
read payload
printf "[?] Are you want to disable httpx output with colors y/n>> "
read answer

echo -n Target: $target Pattern: $pattern Payload: $payload" | ";date 

gau_scan() {
	gau $target > scan/gau.lst #Gau tool output
}
wayback() {
	waybackurls $target > scan/waydata.lst #wayback machine output
}
pattern() {
	cat scan/gau.lst scan/waydata.lst | sort -u > scan/urls.lst #combine gau and wayback datas
	cat scan/urls.lst |gf $pattern > scan/$pattern.out    #gf pattern to search for defined pattern
}
replace() {
	cat scan/$pattern.out | grep '=' | qsreplace | qsreplace $payload > scan/replaced_payload.out #add payload as placeholder
}

http_x() {
	if [ "$answer" = "y" ] || [ "$answer" = "yes" ]; then
		cat scan/replaced_payload.out | httpx -title -status-code -silent -csp-probe -no-color  > scan/httpx.out
	else
		cat scan/replaced_payload.out | httpx -title -status-code -silent -csp-probe > scan/httpx.out
	fi
	cat scan/httpx.out | awk '{print $2,$3,$NF,$1}' | sort -u > scan/finish.out
}
gau_scan
wayback
pattern
replace
http_x
end=`date +%s`
runtime=$((end-start))
echo Run Time: $runtime"sec"
