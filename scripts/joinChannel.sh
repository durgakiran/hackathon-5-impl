#!/bin/bash



echo "joining channel"



echo "setting environment variables"

export CHANNEL_NAME=coldstorage
export CHANNEL_BLOCK_NAME=coldstorage.block
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/group/tlsca/tlsca.group-cert.pem
export FCD=/opt/gopath/src/github.com/hyperledger/fabric/peer

echo "create channel"
# if [ -d "$FCD/channel-artifacts/$CHANNEL_NAME.block" ]; then
#     # create channel
    
# fi
peer channel create -o orderer1.group:7050 -c $CHANNEL_NAME -f ./channel-artifacts/$CHANNEL_NAME.tx --outputBlock ./channel-artifacts/$CHANNEL_BLOCK_NAME --tls --cafile $ORDERER_CA


echo "wdra"

export CORE_PEER_ADDRESS=dpstr.wdra.group:30051
export CORE_PEER_LOCALMSPID=wdraMSP
export CORE_PEER_TLS_CERT_FILE=$FCD/crypto/peerOrganizations/wdra.group/peers/dpstr.wdra.group/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=$FCD/crypto/peerOrganizations/wdra.group/peers/dpstr.wdra.group/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=$FCD/crypto/peerOrganizations/wdra.group/peers/dpstr.wdra.group/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=$FCD/crypto/peerOrganizations/wdra.group/users/Admin@wdra.group/msp


peer channel join -b $FCD/channel-artifacts/$CHANNEL_BLOCK_NAME


#insp
export CORE_PEER_ADDRESS=insp.wdra.group:20051
export CORE_PEER_LOCALMSPID=wdraMSP
export CORE_PEER_TLS_CERT_FILE=$FCD/crypto/peerOrganizations/wdra.group/peers/insp.wdra.group/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=$FCD/crypto/peerOrganizations/wdra.group/peers/insp.wdra.group/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=$FCD/crypto/peerOrganizations/wdra.group/peers/insp.wdra.group/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=$FCD/crypto/peerOrganizations/wdra.group/users/Admin@wdra.group/msp

peer channel join -b $FCD/channel-artifacts/$CHANNEL_BLOCK_NAME


#wdra
export CORE_PEER_ADDRESS=wdra.wdra.group:7051
export CORE_PEER_LOCALMSPID=wdraMSP
export CORE_PEER_TLS_CERT_FILE=$FCD/crypto/peerOrganizations/wdra.group/peers/wdra.wdra.group/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=$FCD/crypto/peerOrganizations/wdra.group/peers/wdra.wdra.group/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=$FCD/crypto/peerOrganizations/wdra.group/peers/wdra.wdra.group/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=$FCD/crypto/peerOrganizations/wdra.group/users/Admin@wdra.group/msp

peer channel join -b $FCD/channel-artifacts/$CHANNEL_BLOCK_NAME

peer channel update -o orderer1.group:7050 -c $CHANNEL_NAME -f $FCD/channel-artifacts/wdraMSPanchors.tx --tls --cafile $ORDERER_CA
