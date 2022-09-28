#!/bin/bash

function createwdraOrg() {
    echo "Enrolling the CA admin"
    mkdir -p organizations/peerOrganizations/wdra.group/

    export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/wdra.group/

    set -x
    ./bin/fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-wdra --tls.certfiles "${PWD}/organizations/fabric-ca/wdra/ca-cert.pem"
    { set +x; } 2>/dev/null

    echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-wdra.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-wdra.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-wdra.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-wdra.pem
    OrganizationalUnitIdentifier: orderer' >"${PWD}/organizations/peerOrganizations/wdra.group/msp/config.yaml"

    # Since the CA serves as both the organization CA and TLS CA, copy the org's root cert that was generated by CA startup into the org level ca and tlsca directories

    # Copy wdra's CA cert to wdra's /msp/tlscacerts directory (for use in the channel MSP definition)
    mkdir -p "${PWD}/organizations/peerOrganizations/wdra.group/msp/tlscacerts"
    cp "${PWD}/organizations/fabric-ca/wdra/ca-cert.pem" "${PWD}/organizations/peerOrganizations/wdra.group/msp/tlscacerts/ca.crt"

    # Copy wdra's CA cert to wdra's /tlsca directory (for use by clients)
    mkdir -p "${PWD}/organizations/peerOrganizations/wdra.group/tlsca"
    cp "${PWD}/organizations/fabric-ca/wdra/ca-cert.pem" "${PWD}/organizations/peerOrganizations/wdra.group/tlsca/tlsca.wdra.group-cert.pem"

    # Copy wdra's CA cert to wdra's /ca directory (for use by clients)
    mkdir -p "${PWD}/organizations/peerOrganizations/wdra.group/ca"
    cp "${PWD}/organizations/fabric-ca/wdra/ca-cert.pem" "${PWD}/organizations/peerOrganizations/wdra.group/ca/ca.wdra.group-cert.pem"

    echo "Registering wdra"
    set -x
    ./bin/fabric-ca-client register --caname ca-wdra --id.name wdra --id.secret wdrapw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/wdra/ca-cert.pem"
    { set +x; } 2>/dev/null

    echo "Registering insp"
    set -x
    ./bin/fabric-ca-client register --caname ca-wdra --id.name insp --id.secret insppw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/wdra/ca-cert.pem"
    { set +x; } 2>/dev/null

    echo "Registering dpstr"
    set -x
    ./bin/fabric-ca-client register --caname ca-wdra --id.name dpstr --id.secret dpstrpw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/wdra/ca-cert.pem"
    { set +x; } 2>/dev/null

    echo "Registering user"
    set -x
    ./bin/fabric-ca-client register --caname ca-wdra --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/wdra/ca-cert.pem"
    { set +x; } 2>/dev/null

    echo "Registering the org admin"
    set -x
    ./bin/fabric-ca-client register --caname ca-wdra --id.name wdraadmin --id.secret wdraadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/wdra/ca-cert.pem"
    { set +x; } 2>/dev/null

    echo "Generating the wdra msp"
    set -x
    ./bin/fabric-ca-client enroll -u https://wdra:wdrapw@localhost:7054 --caname ca-wdra -M "${PWD}/organizations/peerOrganizations/wdra.group/peers/wdra.wdra.group/msp" --csr.hosts wdra.wdra.group --tls.certfiles "${PWD}/organizations/fabric-ca/wdra/ca-cert.pem"
    { set +x; } 2>/dev/null

    cp "${PWD}/organizations/peerOrganizations/wdra.group/msp/config.yaml" "${PWD}/organizations/peerOrganizations/wdra.group/peers/wdra.wdra.group/msp/config.yaml"

    echo "Generating the wdra-tls certificates"
    set -x
    ./bin/fabric-ca-client enroll -u https://wdra:wdrapw@localhost:7054 --caname ca-wdra -M "${PWD}/organizations/peerOrganizations/wdra.group/peers/wdra.wdra.group/tls" --enrollment.profile tls --csr.hosts wdra.wdra.group --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/wdra/ca-cert.pem"
    { set +x; } 2>/dev/null

    # Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
    cp "${PWD}/organizations/peerOrganizations/wdra.group/peers/wdra.wdra.group/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/wdra.group/peers/wdra.wdra.group/tls/ca.crt"
    cp "${PWD}/organizations/peerOrganizations/wdra.group/peers/wdra.wdra.group/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/wdra.group/peers/wdra.wdra.group/tls/server.crt"
    cp "${PWD}/organizations/peerOrganizations/wdra.group/peers/wdra.wdra.group/tls/keystore/"* "${PWD}/organizations/peerOrganizations/wdra.group/peers/wdra.wdra.group/tls/server.key"

    echo "Generating the insp msp"
    set -x
    ./bin/fabric-ca-client enroll -u https://insp:insppw@localhost:7054 --caname ca-wdra -M "${PWD}/organizations/peerOrganizations/wdra.group/peers/insp.wdra.group/msp" --csr.hosts insp.wdra.group --tls.certfiles "${PWD}/organizations/fabric-ca/wdra/ca-cert.pem"
    { set +x; } 2>/dev/null

    cp "${PWD}/organizations/peerOrganizations/wdra.group/msp/config.yaml" "${PWD}/organizations/peerOrganizations/wdra.group/peers/insp.wdra.group/msp/config.yaml"

    echo "Generating the insp-tls certificates"
    set -x
    ./bin/fabric-ca-client enroll -u https://insp:insppw@localhost:7054 --caname ca-wdra -M "${PWD}/organizations/peerOrganizations/wdra.group/peers/insp.wdra.group/tls" --enrollment.profile tls --csr.hosts insp.wdra.group --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/wdra/ca-cert.pem"
    { set +x; } 2>/dev/null

    # Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
    cp "${PWD}/organizations/peerOrganizations/wdra.group/peers/insp.wdra.group/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/wdra.group/peers/insp.wdra.group/tls/ca.crt"
    cp "${PWD}/organizations/peerOrganizations/wdra.group/peers/insp.wdra.group/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/wdra.group/peers/insp.wdra.group/tls/server.crt"
    cp "${PWD}/organizations/peerOrganizations/wdra.group/peers/insp.wdra.group/tls/keystore/"* "${PWD}/organizations/peerOrganizations/wdra.group/peers/insp.wdra.group/tls/server.key"

    echo "Generating the dpstr msp"
    set -x
    ./bin/fabric-ca-client enroll -u https://dpstr:dpstrpw@localhost:7054 --caname ca-wdra -M "${PWD}/organizations/peerOrganizations/wdra.group/peers/dpstr.wdra.group/msp" --csr.hosts dpstr.wdra.group --tls.certfiles "${PWD}/organizations/fabric-ca/wdra/ca-cert.pem"
    { set +x; } 2>/dev/null

    cp "${PWD}/organizations/peerOrganizations/wdra.group/msp/config.yaml" "${PWD}/organizations/peerOrganizations/wdra.group/peers/dpstr.wdra.group/msp/config.yaml"

    echo "Generating the dpstr-tls certificates"
    set -x
    ./bin/fabric-ca-client enroll -u https://dpstr:dpstrpw@localhost:7054 --caname ca-wdra -M "${PWD}/organizations/peerOrganizations/wdra.group/peers/dpstr.wdra.group/tls" --enrollment.profile tls --csr.hosts dpstr.wdra.group --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/wdra/ca-cert.pem"
    { set +x; } 2>/dev/null

    # Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
    cp "${PWD}/organizations/peerOrganizations/wdra.group/peers/dpstr.wdra.group/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/wdra.group/peers/dpstr.wdra.group/tls/ca.crt"
    cp "${PWD}/organizations/peerOrganizations/wdra.group/peers/dpstr.wdra.group/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/wdra.group/peers/dpstr.wdra.group/tls/server.crt"
    cp "${PWD}/organizations/peerOrganizations/wdra.group/peers/dpstr.wdra.group/tls/keystore/"* "${PWD}/organizations/peerOrganizations/wdra.group/peers/dpstr.wdra.group/tls/server.key"

    echo "Generating the user msp"
    set -x
    ./bin/fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-wdra -M "${PWD}/organizations/peerOrganizations/wdra.group/users/User1@wdra.group/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/wdra/ca-cert.pem"
    { set +x; } 2>/dev/null

    cp "${PWD}/organizations/peerOrganizations/wdra.group/msp/config.yaml" "${PWD}/organizations/peerOrganizations/wdra.group/users/User1@wdra.group/msp/config.yaml"

    echo "Generating the org admin msp"
    set -x
    ./bin/fabric-ca-client enroll -u https://wdraadmin:wdraadminpw@localhost:7054 --caname ca-wdra -M "${PWD}/organizations/peerOrganizations/wdra.group/users/Admin@wdra.group/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/wdra/ca-cert.pem"
    { set +x; } 2>/dev/null

    cp "${PWD}/organizations/peerOrganizations/wdra.group/msp/config.yaml" "${PWD}/organizations/peerOrganizations/wdra.group/users/Admin@wdra.group/msp/config.yaml"
}

function createOrderer() {
    echo "Enrolling the CA admin"
    mkdir -p organizations/ordererOrganizations/group

    export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/group

    set -x
    ./bin/fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles "${PWD}/organizations/fabric-ca/group/ca-cert.pem"
    { set +x; } 2>/dev/null

    echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >"${PWD}/organizations/ordererOrganizations/group/msp/config.yaml"

    # Since the CA serves as both the organization CA and TLS CA, copy the org's root cert that was generated by CA startup into the org level ca and tlsca directories

    # Copy orderer org's CA cert to orderer org's /msp/tlscacerts directory (for use in the channel MSP definition)
    mkdir -p "${PWD}/organizations/ordererOrganizations/group/msp/tlscacerts"
    cp "${PWD}/organizations/fabric-ca/group/ca-cert.pem" "${PWD}/organizations/ordererOrganizations/group/msp/tlscacerts/tlsca.group-cert.pem"

    # Copy orderer org's CA cert to orderer org's /tlsca directory (for use by clients)
    mkdir -p "${PWD}/organizations/ordererOrganizations/group/tlsca"
    cp "${PWD}/organizations/fabric-ca/group/ca-cert.pem" "${PWD}/organizations/ordererOrganizations/group/tlsca/tlsca.group-cert.pem"

    echo "Registering orderer1"
    set -x
    ./bin/fabric-ca-client register --caname ca-orderer --id.name orderer1 --id.secret orderer1pw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/group/ca-cert.pem"
    { set +x; } 2>/dev/null

    echo "Registering orderer2"
    set -x
    ./bin/fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret orderer2pw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/group/ca-cert.pem"
    { set +x; } 2>/dev/null

    echo "Registering orderer3"
    set -x
    ./bin/fabric-ca-client register --caname ca-orderer --id.name orderer3 --id.secret orderer3pw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/group/ca-cert.pem"
    { set +x; } 2>/dev/null

    echo "Registering orderer4"
    set -x
    ./bin/fabric-ca-client register --caname ca-orderer --id.name orderer4 --id.secret orderer4pw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/group/ca-cert.pem"
    { set +x; } 2>/dev/null

    echo "Registering orderer5"
    set -x
    ./bin/fabric-ca-client register --caname ca-orderer --id.name orderer5 --id.secret orderer5pw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/group/ca-cert.pem"
    { set +x; } 2>/dev/null

    echo "Registering the orderer admin"
    set -x
    ./bin/fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/group/ca-cert.pem"
    { set +x; } 2>/dev/null

    echo "Generating the orderer1 msp"
    set -x
    ./bin/fabric-ca-client enroll -u https://orderer1:orderer1pw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/group/orderers/orderer1.group/msp" --csr.hosts orderer1.group --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/group/ca-cert.pem"
    { set +x; } 2>/dev/null

    cp "${PWD}/organizations/ordererOrganizations/group/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/group/orderers/orderer1.group/msp/config.yaml"

    echo "Generating the orderer-tls certificates"
    set -x
    ./bin/fabric-ca-client enroll -u https://orderer1:orderer1pw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/group/orderers/orderer1.group/tls" --enrollment.profile tls --csr.hosts orderer1.group --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/group/ca-cert.pem"
    { set +x; } 2>/dev/null

    # Copy the tls CA cert, server cert, server keystore to well known file names in the orderer's tls directory that are referenced by orderer startup config
    cp "${PWD}/organizations/ordererOrganizations/group/orderers/orderer1.group/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/group/orderers/orderer1.group/tls/ca.crt"
    cp "${PWD}/organizations/ordererOrganizations/group/orderers/orderer1.group/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/group/orderers/orderer1.group/tls/server.crt"
    cp "${PWD}/organizations/ordererOrganizations/group/orderers/orderer1.group/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/group/orderers/orderer1.group/tls/server.key"

    # Copy orderer org's CA cert to orderer's /msp/tlscacerts directory (for use in the orderer MSP definition)
    mkdir -p "${PWD}/organizations/ordererOrganizations/group/orderers/orderer1.group/msp/tlscacerts"
    cp "${PWD}/organizations/ordererOrganizations/group/orderers/orderer1.group/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/group/orderers/orderer1.group/msp/tlscacerts/tlsca.group-cert.pem"

    echo "Generating the orderer2 msp"
    set -x
    ./bin/fabric-ca-client enroll -u https://orderer2:orderer2pw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/group/orderers/orderer2.group/msp" --csr.hosts orderer2.group --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/group/ca-cert.pem"
    { set +x; } 2>/dev/null

    cp "${PWD}/organizations/ordererOrganizations/group/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/group/orderers/orderer2.group/msp/config.yaml"

    echo "Generating the orderer-tls certificates"
    set -x
    ./bin/fabric-ca-client enroll -u https://orderer2:orderer2pw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/group/orderers/orderer2.group/tls" --enrollment.profile tls --csr.hosts orderer2.group --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/group/ca-cert.pem"
    { set +x; } 2>/dev/null

    # Copy the tls CA cert, server cert, server keystore to well known file names in the orderer's tls directory that are referenced by orderer startup config
    cp "${PWD}/organizations/ordererOrganizations/group/orderers/orderer2.group/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/group/orderers/orderer2.group/tls/ca.crt"
    cp "${PWD}/organizations/ordererOrganizations/group/orderers/orderer2.group/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/group/orderers/orderer2.group/tls/server.crt"
    cp "${PWD}/organizations/ordererOrganizations/group/orderers/orderer2.group/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/group/orderers/orderer2.group/tls/server.key"

    # Copy orderer org's CA cert to orderer's /msp/tlscacerts directory (for use in the orderer MSP definition)
    mkdir -p "${PWD}/organizations/ordererOrganizations/group/orderers/orderer2.group/msp/tlscacerts"
    cp "${PWD}/organizations/ordererOrganizations/group/orderers/orderer2.group/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/group/orderers/orderer2.group/msp/tlscacerts/tlsca.group-cert.pem"

    echo "Generating the orderer3 msp"
    set -x
    ./bin/fabric-ca-client enroll -u https://orderer3:orderer3pw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/group/orderers/orderer3.group/msp" --csr.hosts orderer3.group --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/group/ca-cert.pem"
    { set +x; } 2>/dev/null

    cp "${PWD}/organizations/ordererOrganizations/group/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/group/orderers/orderer3.group/msp/config.yaml"

    echo "Generating the orderer-tls certificates"
    set -x
    ./bin/fabric-ca-client enroll -u https://orderer3:orderer3pw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/group/orderers/orderer3.group/tls" --enrollment.profile tls --csr.hosts orderer3.group --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/group/ca-cert.pem"
    { set +x; } 2>/dev/null

    # Copy the tls CA cert, server cert, server keystore to well known file names in the orderer's tls directory that are referenced by orderer startup config
    cp "${PWD}/organizations/ordererOrganizations/group/orderers/orderer3.group/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/group/orderers/orderer3.group/tls/ca.crt"
    cp "${PWD}/organizations/ordererOrganizations/group/orderers/orderer3.group/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/group/orderers/orderer3.group/tls/server.crt"
    cp "${PWD}/organizations/ordererOrganizations/group/orderers/orderer3.group/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/group/orderers/orderer3.group/tls/server.key"

    # Copy orderer org's CA cert to orderer's /msp/tlscacerts directory (for use in the orderer MSP definition)
    mkdir -p "${PWD}/organizations/ordererOrganizations/group/orderers/orderer3.group/msp/tlscacerts"
    cp "${PWD}/organizations/ordererOrganizations/group/orderers/orderer3.group/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/group/orderers/orderer3.group/msp/tlscacerts/tlsca.group-cert.pem"

    echo "Generating the orderer4 msp"
    set -x
    ./bin/fabric-ca-client enroll -u https://orderer4:orderer4pw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/group/orderers/orderer4.group/msp" --csr.hosts orderer4.group --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/group/ca-cert.pem"
    { set +x; } 2>/dev/null

    cp "${PWD}/organizations/ordererOrganizations/group/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/group/orderers/orderer4.group/msp/config.yaml"

    echo "Generating the orderer-tls certificates"
    set -x
    ./bin/fabric-ca-client enroll -u https://orderer4:orderer4pw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/group/orderers/orderer4.group/tls" --enrollment.profile tls --csr.hosts orderer4.group --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/group/ca-cert.pem"
    { set +x; } 2>/dev/null

    # Copy the tls CA cert, server cert, server keystore to well known file names in the orderer's tls directory that are referenced by orderer startup config
    cp "${PWD}/organizations/ordererOrganizations/group/orderers/orderer4.group/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/group/orderers/orderer4.group/tls/ca.crt"
    cp "${PWD}/organizations/ordererOrganizations/group/orderers/orderer4.group/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/group/orderers/orderer4.group/tls/server.crt"
    cp "${PWD}/organizations/ordererOrganizations/group/orderers/orderer4.group/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/group/orderers/orderer4.group/tls/server.key"

    # Copy orderer org's CA cert to orderer's /msp/tlscacerts directory (for use in the orderer MSP definition)
    mkdir -p "${PWD}/organizations/ordererOrganizations/group/orderers/orderer4.group/msp/tlscacerts"
    cp "${PWD}/organizations/ordererOrganizations/group/orderers/orderer4.group/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/group/orderers/orderer4.group/msp/tlscacerts/tlsca.group-cert.pem"

    echo "Generating the orderer5 msp"
    set -x
    ./bin/fabric-ca-client enroll -u https://orderer5:orderer5pw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/group/orderers/orderer5.group/msp" --csr.hosts orderer5.group --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/group/ca-cert.pem"
    { set +x; } 2>/dev/null

    cp "${PWD}/organizations/ordererOrganizations/group/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/group/orderers/orderer5.group/msp/config.yaml"

    echo "Generating the orderer-tls certificates"
    set -x
    ./bin/fabric-ca-client enroll -u https://orderer5:orderer5pw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/group/orderers/orderer5.group/tls" --enrollment.profile tls --csr.hosts orderer5.group --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/group/ca-cert.pem"
    { set +x; } 2>/dev/null

    # Copy the tls CA cert, server cert, server keystore to well known file names in the orderer's tls directory that are referenced by orderer startup config
    cp "${PWD}/organizations/ordererOrganizations/group/orderers/orderer5.group/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/group/orderers/orderer5.group/tls/ca.crt"
    cp "${PWD}/organizations/ordererOrganizations/group/orderers/orderer5.group/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/group/orderers/orderer5.group/tls/server.crt"
    cp "${PWD}/organizations/ordererOrganizations/group/orderers/orderer5.group/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/group/orderers/orderer5.group/tls/server.key"

    # Copy orderer org's CA cert to orderer's /msp/tlscacerts directory (for use in the orderer MSP definition)
    mkdir -p "${PWD}/organizations/ordererOrganizations/group/orderers/orderer5.group/msp/tlscacerts"
    cp "${PWD}/organizations/ordererOrganizations/group/orderers/orderer5.group/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/group/orderers/orderer5.group/msp/tlscacerts/tlsca.group-cert.pem"

    echo "Generating the admin msp"
    set -x
    ./bin/fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/group/users/Admin@group/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/group/ca-cert.pem"
    { set +x; } 2>/dev/null

    cp "${PWD}/organizations/ordererOrganizations/group/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/group/users/Admin@group/msp/config.yaml"
}
