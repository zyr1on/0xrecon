#!/bin/bash

echo -e "[?] Checking...\n"
sleep 0.3

#Check for GOPATH
if [[ $(echo $GOPATH) = "" ]] || [[ $(echo $GOPATH) != "$HOME/go" ]]; then
	echo [?] Go Path not setted
	echo "Do you want to set GOPATH y/n:> "
	read answer
	if [ "$answer" == "y" ] || [ "$answer" == "yes" ];then
		export PATH=$PATH:$(go env GOPATH)/bin
		export GOPATH=$(go env GOPATH)
	else
		break
	fi
else
	echo "[!] Found GOPATH: $GOPATH"
fi

#Check for GOLANG tool
if [ $(command -v go) ]; then
	echo [!] GOLANG installed
else
	echo Please Install GOLANG before run it
	break
fi

not_installed=("")

#check for gf
if [ $(command -v gf) ]; then
	echo [!] gf installed
else
	echo [-] gf not installed
	not_installed+=("gf")
fi
sleep 0.2

#check for gau
if [ $(command -v gau ) ]; then
	echo [!] gau installed
else
	echo [-] gau not installed
	not_installed+=("gau")
fi
sleep 0.2

#check for qsreplace
if [ $(command -v qsreplace) ]; then
	echo [!] qsreplace installed
else
	echo [-] qsreplace not installed
	not_installed+=("qsreplace")
fi
sleep 0.2

#check for waybackurls
if [ $(command -v waybackurls) ]; then
	echo [!] Waybackurls installed
else
	echo [-] Waybackurls not installed
	not_installed+=("waybackurls")
fi
sleep 0.2

#check for httpx
if [ $(command -v httpx) ]; then
	echo [!] httpx installed
else
	echo [-] httpx not installed
	not_installed+=("httpx")
fi

for value in "${not_installed[@]}";do
	if [[ "$value" == *"gau"* ]]; then
		$(GO111MODULE=on go get -u -v "github.com/lc/gau")
	elif [[ "$value" == *"qsreplace"* ]]; then
		$(go get -u "github.com/tomnomnom/qsreplace")
	elif [[ "$value" == *"waybackurls"* ]]; then
		$(go get -u "github.com/tomnomnom/waybackurls")
	elif [[ "$value" == *"gf"* ]]; then
		$(go get -u "github.com/tomnomnom/gf")
	elif [[ "$value" == *"httpx"* ]]; then
		$(GO111MODULE=on go get -v "github.com/projectdiscovery/httpx/cmd/httpx")
	else
		echo [!] All tools are installed
	fi
done
$(sudo cp $HOME/go/bin/* -r /usr/bin/)
