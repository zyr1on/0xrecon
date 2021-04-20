#!/bin/bash

start=`date +%s`
printf "[?] Enter Target>> "
read target
printf "[?] Enter Pattern gf >> "
read pattern
printf "[?] Enter Payload as Placeholder to add paramaters>> "
read payload
printf "[?] Are you want to disable httpx output with colors y/n>> "
read answer

echo -n Target: $target Pattern: $pattern Payload: $payload" | ";date 
mkdir scan
cd scan
gau_scan() {
	gau $target >> gau.lst #Gau tool output
}
wayback() {
	waybackurls $target >> waydata.lst #wayback machine output
}
pattern() {
	cat gau.lst waydata.lst | sort -u >> urls.lst #combine gau and wayback datas
	cat urls.lst | gf $pattern >> $pattern.txt    #gf pattern to search for defined pattern
}
replace() {
	cat $pattern.txt | qsreplace | qsreplace -a $payload >> payload.txt #add payload as placeholder
}

http_x() {
	if [ "$answer" = "y" ] || [ "$answer" = "yes" ]; then
		if [[ "$pattern" == *"redirect"* ]]; then
			cat payload.txt | httpx -title -status-code -silent -csp-probe -no-color -follow-redirects  > httpx.out
		else
			cat payload.txt | httpx -title -status-code -silent -csp-probe -no-color > httpx.out
		fi
	else
		cat payload.txt | httpx -title -status-code -silent -csp-probe -follow-redirects > httpx.out
	fi
	cat httpx.out | awk '{print $2,$3,$NF,$1}' | sort -u > finish.out
}
gau_scan
wayback
pattern
replace
http_x
end=`date +%s`
runtime=$((end-start))
echo Run Time: $runtime"sec"
