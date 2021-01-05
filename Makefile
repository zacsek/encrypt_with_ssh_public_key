SHELL:=/bin/bash

all:
	@echo "Usage:"
	#@echo "        key     : generate ssh key"
	@echo "        enc     : directly encrypt file"
	@echo "        dec     : directly decrypt file"
	@echo "        encrypt : encrypt big file with symmetric key"
	@echo "        decrypt : decrypt big file with symmetric key"


key: 
	@echo "This is no longer used, because openssl won't load private key from local folder. It is left here nonetheless"
	@echo "ssh-keygen -q -t rsa -N '' -f id_rsa <<< 'y'  2>&1 >/dev/null"

enc: 
	openssl rsautl -encrypt -oaep -pubin -inkey <(ssh-keygen -e -f ~/.ssh/id_rsa.pub -m PKCS8) -in example.txt -out example.txt.enc

dec: 
	openssl rsautl -decrypt -oaep -inkey ~/.ssh/id_rsa -in example.txt.enc -out example.txt.out

encrypt: 
	cp -v lena.png secret.png
	openssl rand -out secret.key 32
	openssl aes-256-cbc -in secret.png -out secret.png.enc -pass file:secret.key
	openssl rsautl -encrypt -oaep -pubin -inkey <(ssh-keygen -e -f ~/.ssh/id_rsa.pub -m PKCS8) -in secret.key -out secret.key.enc
	rm -v secret.key secret.png

decrypt: 
	openssl rsautl -decrypt -oaep -inkey ~/.ssh/id_rsa -in secret.key.enc -out secret.key
	openssl aes-256-cbc -d -in secret.png.enc -out secret.png -pass file:secret.key
	
