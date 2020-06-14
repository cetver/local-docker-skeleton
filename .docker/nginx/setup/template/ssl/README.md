## CA
```shell script
openssl genrsa -out CA.key 2048

openssl req \
    -x509 \
    -new \
    -sha256 \
    -subj '/C=AU/ST=Some-State/L=Some-City/O=!!! AAA Local CA/OU=IT/CN=all.local.sites/emailAddress=all@local.sites' \
    -key CA.key \
    -out CA.crt \
    -days 36500
```

## Concrete certificate
```shell script
openssl genrsa -out skeleton.key 2048

openssl req \
    -sha256 \
    -new \
    -key skeleton.key \
    -out skeleton.csr \
    -subj '/C=AU/ST=Some-State/L=Some-City/O=Skeleton-Cert/OU=IT/CN=skeleton.loc/emailAddress=it@skeleton.loc'

# View the Certificate Signing Request
openssl req -in skeleton.csr -text -noout

openssl x509 \
    -req \
    -sha256 \
    -in skeleton.csr \
    -out skeleton.crt \
    -CA CA.crt \
    -CAkey CA.key \
    -CAcreateserial \
    -days 3650 \
    -extensions v3_req \
    -extfile <(
        echo '[v3_req]'; 
        echo 'keyUsage = nonRepudiation, digitalSignature, keyEncipherment';
        echo 'subjectAltName = @subject_alt_name';
        echo '[subject_alt_name]';
        echo 'DNS.1 = *.skeleton.loc';
        echo 'DNS.2 = skeleton.loc';
    )

# View the certificate
openssl x509 -in skeleton.crt -text -noout
```

## System install
```shell script
sudo mkdir --verbose --parents /usr/share/ca-certificates/extra
sudo cp --verbose CA.crt /usr/share/ca-certificates/extra
sudo dpkg-reconfigure ca-certificates
sudo update-ca-certificates
```

## FF
about:preferences 
    search - certificates - view certificates - authorities - import - /usr/share/ca-certificates/extra/CA.crt

## Chrome
chrome://settings/
    search - certificates - manage certificates - authorities - import - /usr/share/ca-certificates/extra/CA.crt