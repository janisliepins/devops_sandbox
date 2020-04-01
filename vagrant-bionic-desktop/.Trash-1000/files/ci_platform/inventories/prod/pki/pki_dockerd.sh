#!/bin/sh
set -e -u

################################################################################
output(){
  if [ "$#" -eq 2 ] ; then
    if [ "$1" = "i" ] ; then
      echo "`date '+%Y.%m.%d %H:%M:%S'`:INFO :$2"
    elif [ "$1" = "e" ] ; then
      echo "`date '+%Y.%m.%d %H:%M:%S'`:ERROR:$2"
    elif [ "$1" = "w" ] ; then
      echo "`date '+%Y.%m.%d %H:%M:%S'`:WARN :$2"
    else
      echo "`date '+%Y.%m.%d %H:%M:%S'`:DEBUG:$2"
    fi
  else
    echo "`date '+%Y.%m.%d %H:%M:%S'`:DEBUG:$1"
  fi
}
################################################################################
openssl_cfg(){
  output 'i' "Dealing with OpenSSL configuration"
  if ! [ -d "`dirname $OPENSSL_CONF`" ] ; then
    output 'i' "Creating OpenSSL root dir"
    mkdir -p "`dirname $OPENSSL_CONF`"
  fi

  if ! [ -f "$OPENSSL_CONF" ] ; then
    output 'i' "Creating OpenSSL configuration file"
    echo "[ ca ]
default_ca       = CA_default

[ CA_default ]

dir              = $PKI_ROOT/openssl            # top dir
database         = $PKI_ROOT/openssl/index.txt  # index file.
new_certs_dir    = $PKI_ROOT/openssl/newcerts   # new certs dir
serial           = $PKI_ROOT/openssl/serial     # serial no file
RANDFILE         = $PKI_ROOT/openssl/.rand      # random number file
certificate      = $PKI_ROOT/openssl/cacert.pem # The CA cert
private_key      = $PKI_ROOT/openssl/cakey.pem  # CA private key

default_days     = 365                       # how long to certify for
default_crl_days = 30                        # how long before next CRL
default_md       = sha256                    # md to use
policy           = policy_any                # default policy
email_in_dn      = no                        # Don't add the email into cert DN
name_opt         = ca_default                # Subject name display option
cert_opt         = ca_default                # Certificate display option
copy_extensions  = copy                      # copy might be needed for ecomm merchant cert singning
unique_subject   = no                        # lets support certificate rotation
x509_extensions  = x509_end_cert             # lets add default x509 info to user certificates


[ policy_any ]
countryName            = supplied
stateOrProvinceName    = optional
localityName           = optional
organizationName       = optional
organizationalUnitName = optional
commonName             = supplied
emailAddress           = optional

[ req ]
default_bits           = 2048
default_md             = sha256
string_mask            = nombstr
distinguished_name     = req_distinguished_name
req_extensions         = x509_end_req

[ req_distinguished_name ]
countryName                    = Country Name (2 letter code)
countryName_default            = LV
countryName_min                = 2
countryName_max                = 2
stateOrProvinceName            = State or Province Name (full name)
stateOrProvinceName_default    = Latvia
stateOrProvinceName_max        = 32
localityName                   = Locality Name (eg, city)
localityName_default           = Riga
localityName_max               = 32
organizationName               = Organization Name (eg, company)
organizationName_default       = TietoEvry
organizationName_max           = 32
organizationalUnitName         = Organizational Unit Name (eg, section)
organizationalUnitName_default = Cards
organizationalUnitName_max     = 32
commonName                     = Common Name
commonName_default             = CardSuite cert
commonName_max                 = 64
emailAddress                   = Email Address
emailAddress_max               = 40

[ x509_ca ]
basicConstraints               = CA:TRUE, pathlen:1
keyUsage                       = keyCertSign, cRLSign
subjectKeyIdentifier           = hash

[ x509_intermediate ]
basicConstraints               = CA:TRUE, pathlen:0
keyUsage                       = keyCertSign, cRLSign
subjectKeyIdentifier           = hash
authorityKeyIdentifier         = keyid:always

[ x509_intermediate_req ]
basicConstraints               = CA:TRUE, pathlen:0
keyUsage                       = keyCertSign, cRLSign
subjectKeyIdentifier           = hash

[ x509_end_req ]
basicConstraints               = CA:FALSE
keyUsage                       = digitalSignature, keyEncipherment, dataEncipherment, keyAgreement
extendedKeyUsage               = serverAuth, clientAuth
subjectKeyIdentifier           = hash
subjectAltName                 = \${ENV::OPENSSL_CERT_ALTNAME}

[ x509_end_cert ]
basicConstraints               = CA:FALSE
keyUsage                       = digitalSignature, keyEncipherment, dataEncipherment, keyAgreement
extendedKeyUsage               = serverAuth, clientAuth
subjectKeyIdentifier           = hash
authorityKeyIdentifier         = keyid:always

[ x509_self_sign_cert ]
basicConstraints               = CA:FALSE
keyUsage                       = digitalSignature, keyEncipherment, dataEncipherment, keyAgreement
extendedKeyUsage               = serverAuth, clientAuth
subjectKeyIdentifier           = hash
authorityKeyIdentifier         = keyid:always
subjectAltName                 = \${ENV::OPENSSL_CERT_ALTNAME}
" > "$OPENSSL_CONF"
  else
    output 'i' "OpenSSL configuration file exits"
  fi
  output 'i' "Checking/creating file structure for OpenSSL"
  if ! [ -d "$PKI_ROOT/openssl/newcerts" ] ; then
    mkdir -p "$PKI_ROOT/openssl/newcerts"
  fi

  if ! [ -f "$PKI_ROOT/openssl/serial" ] ; then
    echo "00" > "$PKI_ROOT/openssl/serial"
  fi
  if ! [ -r "$PKI_ROOT/openssl/index.txt" ] ; then
    touch "$PKI_ROOT/openssl/index.txt"
  fi
  if ! [ -r "$PKI_ROOT/openssl/index.txt.attr" ] ; then
    touch "$PKI_ROOT/openssl/index.txt.attr"
  fi
  output 'i' "OpenSSL configuration up and ready"
}
################################################################################
gen_priv_key(){
  output 'i' "Creating private key $1"
  openssl genpkey \
    -algorithm RSA \
    -out "$2" \
    -pass "pass:$3" \
    -pkeyopt "rsa_keygen_bits:2048" \
    -AES-256-CBC
  output 'i' "Private key generated"
}
################################################################################
gen_ca(){
  if [ -d "$PKI_ROOT/$1" ] ; then
    output 'e' "Refusing to generate CA certificate as it allready exists"
    exit 1
  else
    output 'i' "Generating CA with alias $1"
    mkdir -p "$PKI_ROOT/$1"
  fi
  export OPENSSL_CERT_ALTNAME=""  

  output 'i' "Creating private key"
  gen_priv_key "$1" "$PKI_ROOT/$1/$1.key" "$2"

  output 'i' "Creating certificate"
  openssl req \
    -new \
    -x509 \
    -reqexts "x509_ca" \
    -extensions "x509_ca" \
    -text \
    -key "$PKI_ROOT/$1/$1.key" \
    -passin "pass:$2" \
    -subj "$3" \
    -days "$4" \
    -out "$PKI_ROOT/$1/$1.pem"

  output 'i' "Exporting certificate to x509"
  openssl x509 \
    -in "$PKI_ROOT/$1/$1.pem" > "$PKI_ROOT/$1/$1.x509"
  output 'i' "CA creationg completed, it recides $PKI_ROOT/$1"
}
################################################################################
gen_cert(){
  output 'i' "Generating certificate for $1"
  export OPENSSL_CERT_ALTNAME
  mkdir -p "$PKI_ROOT/$1"
  gen_priv_key "$1" "$PKI_ROOT/$1/$1.key" "$2"

  output 'i' "Creating certificate request"
  openssl req -new \
    -key "$PKI_ROOT/$1/$1.key" \
    -passin "pass:$2" \
    -subj "$3" \
    -days "$4" \
    -out "$PKI_ROOT/$1/$1.req"
  
  output 'i' "Signing certificate request"
  openssl ca \
    -in "$PKI_ROOT/$1/$1.req" \
    -out "$PKI_ROOT/$1/$1.pem" \
    -cert "$PKI_ROOT/$5/$5.pem" \
    -keyfile "$PKI_ROOT/$5/$5.key" \
    -passin "pass:$6" \
    -days "$4" \
    -batch

  output 'i' "Converting certificate to x509"
  openssl x509 \
    -in "$PKI_ROOT/$1/$1.pem" > "$PKI_ROOT/$1/$1.x509"

  output 'i' "Creating x509 certificate chain"
  openssl x509 \
    -in "$PKI_ROOT/$1/$1.pem" > "$PKI_ROOT/$1/$1_chain.x509"

  cat "$PKI_ROOT/$5/$5.x509" >> "$PKI_ROOT/$1/$1_chain.x509"

  output 'i' "Converting private key to plaintext"
  openssl rsa \
    -in "$PKI_ROOT/$1/$1.key" \
    -out "$PKI_ROOT/$1/$1.key_clear" \
    -passin "pass:$2"

  output 'i' "Certificate $1 generation completed, it recides in $PKI_ROOT/$1"
}
################################################################################
main(){
  PKI_ROOT="$( cd "$(dirname "$0")" ; pwd -P )"
  OPENSSL_CONF="$PKI_ROOT/openssl/openssl.cfg"
  export OPENSSL_CONF
  openssl_cfg

  PREFIX=test

  CA_KEY_PASSWORD="CardsDockerCAPassword11"
  CA_REF="${PREFIX}-docker-CA"
  gen_ca "$CA_REF" "$CA_KEY_PASSWORD" "/CN=${PREFIX}-docker-CA/OU=Cards/O=Tieto/L=Riga/ST=Latvia/C=LV" "3650"

  OPENSSL_CERT_ALTNAME="IP:10.57.6.135"
  gen_cert "${PREFIX}-docker-daemon" "CoreDaemonPassowor17" "/CN=${PREFIX}-docker-daemon/OU=Cards/O=Tieto/L=Riga/ST=Latvia/C=LV" "730" "$CA_REF" "$CA_KEY_PASSWORD"

  OPENSSL_CERT_ALTNAME="IP:10.57.6.136"
  gen_cert "${PREFIX}-docker-registry" "AF9feHN0YXQ2NABfXdha" "/CN=${PREFIX}-docker-registry/OU=Cards/O=Tieto/L=Riga/ST=Latvia/C=LV" "730" "$CA_REF" "$CA_KEY_PASSWORD"

}
################################################################################
main
