rm -rf tmp || true
mkdir tmp || true
# Private key for the certificate authority
openssl genrsa -des3 -out ./tmp/rootCA.protected.key 2048
openssl rsa -in ./tmp/rootCA.protected.key -out ./tmp/rootCA.key
# Generate the CA
openssl req -x509 -new -nodes -key ./tmp/rootCA.key -sha256 -days 1024 -out ./tmp/rootCA.pem -subj "/C=US/ST=California/L=Mountain View/O=Your Organization/OU=Your Unit/CN=example.com"
# Generate a key for the client certificate
openssl genrsa -out ./tmp/client.key 2048
# Generate the certificate request for the client
openssl req -new -key ./tmp/client.key -out ./tmp/client.csr -subj "/C=US/ST=California/L=Mountain View/O=Your Organization/OU=Your Unit/CN=localhost"
# Sign the certificate request for the client
openssl x509 -req -in ./tmp/client.csr -extensions client -CA ./tmp/rootCA.pem -CAkey ./tmp/rootCA.key -CAcreateserial -out ./tmp/client.crt -days 500 -sha256

# Generate a key for the server certificate
openssl genrsa -out ./tmp/server.key 2048
# Generate the certificate request for the server
openssl req -new -key ./tmp/server.key -out ./tmp/server.csr -subj "/C=US/ST=California/L=Mountain View/O=Your Organization/OU=Your Unit/CN=localhost"
# Sign the certificate request for the server
openssl x509 -req -in ./tmp/server.csr -extensions server -CA ./tmp/rootCA.pem -CAkey ./tmp/rootCA.key -CAcreateserial -out ./tmp/server.crt -days 500 -sha256

yes | cp -rf tmp/server.crt config/krakend/certificates
yes | cp -rf tmp/server.key config/krakend/certificates
yes | cp -rf tmp/rootCA.pem config/krakend/certificates