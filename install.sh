#!/bin/bash
echo -e "[?] Checking...\n"
sleep 0.3

#check for gf pattern
if [[ "$(ls ~/.gf &>/dev/null;echo $?)" -eq 2 ]]; then
	echo [-] gf patterns not found
	echo [?] Installing gf patterns to $HOME/.gf
	sleep 0.1
	mkdir ~/.gf;cd ~/.gf
	git clone "https://github.com/1ndianl33t/Gf-Patterns" &>/dev/null
	mv Gf-Patterns/*.json . && rm -rf Gf-Patterns/
	echo  [+] Installed gf Patterns
	
fi

#Check for GOPATH
if [[ $(echo $GOPATH) = "" ]] || [[ $(echo $GOPATH) != "$HOME/go" ]]; then
	echo [?] Go Path not setted
	echo "Do you want to set GOPATH y/n:> "
	read answer
	if [ "$answer" == "y" ] || [ "$answer" == "yes" ];then
		echo -e "\n" >> ~/.bashrc
		echo "export PATH=$PATH:$(go env GOPATH)/bin" >> ~/.bashrc
		echo "export GOPATH=$(go env GOPATH)" >> ~/.bashrc
		source ~/.bashrc
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
	if [[ "$value" == *"httpx"* ]] || [[ "$value" == *"gau"* ]];then
		$(go get -u "github.com/tomnomnom/$value" &>/dev/null)
		$(GO111MODULE=on go get -u -v "github.com/lc/gau" &>/dev/null)
		$(GO111MODULE=on go get -v "github.com/projectdiscovery/httpx/cmd/httpx" &>/dev/null) 	
	else
		$(go get -u "github.com/tomnomnom/$value" &>/dev/null)	
	fi
done
source ~/.bashrc
echo [!] All tools are installed
