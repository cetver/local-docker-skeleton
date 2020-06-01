## CA
```shell script
openssl genrsa -out CA.key 2048
openssl req -new -key CA.key -out CA.csr \
    -subj '/C=AU/ST=Some-State/L=Some-City/O=Local CA/OU=IT/CN=sites.loc'
openssl req -x509 -key CA.key -in CA.csr -out CA.crt -days 100000
```

## Concrete certificate
```shell script
openssl genrsa -out skeleton.key 2048
openssl req -new -key skeleton.key -out skeleton.csr \
    -subj '/C=AU/ST=Some-State/L=Some-City/O=Skeleton-Cert/OU=IT/CN=skeleton.loc'\
    -addext 'subjectAltName = DNS:*.skeleton.loc'
openssl x509 -req -in skeleton.csr -out skeleton.crt -CA CA.crt -CAkey CA.key -CAcreateserial -days 50000
```

## System install
```shell script
sudo mkdir --verbose --parents /usr/share/ca-certificates/extra
sudo cp --verbose CA.crt /usr/share/ca-certificates/extra
sudo dpkg-reconfigure ca-certificates
sudo update-ca-certificates
```

## FF
about:preferences#general 
    search - certificates - view certificates - authorities - import - /usr/share/ca-certificates/extra/CA.crt

## Chrome
chrome://settings/
    search - certificates - manage certificates - authorities - import - /usr/share/ca-certificates/extra/CA.crt