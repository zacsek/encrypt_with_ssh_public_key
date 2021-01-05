# Encrypt / Decrypt with SSH public/private keys

View this markdown with:

	$ sudo pip3 install grip
	$ grip -b README.md

## Article

Article about using SSH public key to encrypt is [here](https://www.bjornjohansen.com/encrypt-file-using-ssh-key#:~:text=If%20you%20have%20someone's%20public,decrypt%20the%20file%20you%20sent.)

## Encrypt/Decrypt with public/private SSH key directly

To encrypt a small file directly with SSH public key, use this:

	openssl rsautl -encrypt -oaep -pubin -inkey <(ssh-keygen -e -f ~/.ssh/id_rsa.pub -m PKCS8) -in <file_to_encrypt> -out <encrypted_file>

To decrypt it, use this:

	openssl rsautl -decrypt -oaep -inkey ~/.ssh/id_rsa -in <encrypted_file> -out <decrypted_file>
	

## To encrypt a large file:

### Generate a symmetric key

	openssl rand -out secret.key 32

### Encrypt the file with symmetric key

	openssl aes-256-cbc -in secretfile.txt -out secretfile.txt.enc -pass file:secret.key

### Encrypt the symmetric key

	openssl rsautl -encrypt -oaep -pubin -inkey <(ssh-keygen -e -f recipients-key.pub -m PKCS8) -in secret.key -out secret.key.enc

## To decrypt a large file:

### Decrypt symmetric key

	openssl rsautl -decrypt -oaep -inkey ~/.ssh/id_rsa -in secret.key.enc -out secret.key

### Decrypt file with symmetric key

	openssl aes-256-cbc -d -in secretfile.txt.enc -out secretfile.txt -pass file:secret.key


