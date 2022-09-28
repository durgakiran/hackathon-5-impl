#!/bin/bash

echo "chaincode"





# export CORE_PEER_ADDRESS=dpstr.wdra.group:30051
# export CORE_PEER_LOCALMSPID=wdraMSP
# export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/wdra.group/peers/dpstr.wdra.group/tls/server.crt
# export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/wdra.group/peers/dpstr.wdra.group/tls/server.key
# export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/wdra.group/peers/dpstr.wdra.group/tls/ca.crt
# export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/wdra.group/users/Admin@wdra.group/msp

# export CHANNEL_NAME=coldstorage
# # export CC_PACKAGE_ID=helloworld:e3e399cd88d946f43efa76e4fb834174edea4e680b1b9b40c93977bdd66d23ed



# peer lifecycle chaincode package helloworld.tar.gz --path $CHAINCODE_PATH/chaincode --lang node --label helloworld-$1

# peer lifecycle chaincode queryinstalled

# peer lifecycle chaincode install helloworld.tar.gz

# peer lifecycle chaincode queryinstalled

# peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name helloworld

# PACKAGE_ID=helloworld:e3e399cd88d946f43efa76e4fb834174edea4e680b1b9b40c93977bdd66d23ed


# export CORE_PEER_ADDRESS=dpstr.wdra.group:30051
# export CORE_PEER_LOCALMSPID=wdraMSP
# export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/wdra.group/peers/dpstr.wdra.group/tls/server.crt
# export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/wdra.group/peers/dpstr.wdra.group/tls/server.key
# export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/wdra.group/peers/dpstr.wdra.group/tls/ca.crt
# export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/wdra.group/users/Admin@wdra.group/msp

# export CHANNEL_NAME=coldstorage
# export CC_PACKAGE_ID=helloworld-v0.1:24ed2d6d7134cd7957922da2e0eccef15bd87858ada9ac8aaaef12de16487369
# export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/group/orderers/orderer1.group/msp/tlscacerts/tlsca.group-cert.pem

# peer lifecycle chaincode approveformyorg -o orderer1.group:7050 --tls true --cafile $ORDERER_CA --channelID=$CHANNEL_NAME --name helloworld --version 1 --package-id $CC_PACKAGE_ID --sequence 2


# peer lifecycle chaincode commit -o orderer1.group:7050 --tls true --cafile "$ORDERER_CA" --channelID $CHANNEL_NAME --name helloworld --version 1 --sequence 2

export CHAINCODE_PATH=/opt/gopath/src/github.com
export FCD=/opt/gopath/src/github.com/hyperledger/fabric/peer
export CORE_PEER_ADDRESS=dpstr.wdra.group:30051
export CORE_PEER_LOCALMSPID=wdraMSP
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/wdra.group/peers/dpstr.wdra.group/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/wdra.group/peers/dpstr.wdra.group/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/wdra.group/peers/dpstr.wdra.group/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/wdra.group/users/Admin@wdra.group/msp
export CHANNEL_NAME=coldstorage
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/group/orderers/orderer1.group/msp/tlscacerts/tlsca.group-cert.pem


function installChainCode {
    # package chaincode
    peer lifecycle chaincode package wdra.tar.gz --path $CHAINCODE_PATH/chaincode/wdra --lang node --label wdra-$VERSION

    # query already installed chaincodes
    peer lifecycle chaincode queryinstalled

    # install chaincode
    peer lifecycle chaincode install wdra.tar.gz

    # query installed chaincodes
    peer lifecycle chaincode queryinstalled
}

function approveChainCode {
    echo "approving chain code by ${CORE_PEER_LOCALMSPID}"
    peer lifecycle chaincode approveformyorg -o orderer1.group:7050 --tls true --cafile $ORDERER_CA --channelID=$CHANNEL_NAME --name wdra --version 1 --package-id $PACKAGE --sequence $SEQUENCE
}

function commitChainCode {
    peer lifecycle chaincode commit -o orderer1.group:7050 --tls true --cafile "$ORDERER_CA" --channelID $CHANNEL_NAME --name wdra --version 1 --sequence $SEQUENCE
}

CMD=$1
VERSION=$2

echo "executing with ${CMD} with version ${VERSION}"

if [ "$CMD" == "install" ]; then
    installChainCode
fi


PACKAGE=$3
SEQUENCE=$4

if [ "$CMD" == "approve" ]; then
    approveChainCode
fi

if [ "$CMD" == "commit" ]; then
    commitChainCode
fi


