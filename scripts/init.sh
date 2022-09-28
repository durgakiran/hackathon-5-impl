#!/bin/bash


function cleanArtifacts() {
    rm -Rf channel-artifacts/
}

function cleanCrypto() {
    if [ -d "organizations/peerOrganizations" ]; then
        rm -Rf organizations/peerOrganizations && rm -Rf organizations/ordererOrganizations
    fi
}

function generateCryptoFabric() {
    . scripts/registerEnroll.sh

    sudo docker-compose -f ./compose/compose-ca.yaml up -d

    echo "Creating Org1 Identities"

    createwdraOrg

    echo "Creating Orderer Org Identities"

    createOrderer
}


function generateCrypto() {
    which ./bin/cryptogen
    if [ "$?" -ne 0 ]; then
        fatalln "cryptogen tool not found. exiting"
    fi

    echo "Generating certificates using cryptogen tool"

    # generate crypto for orderer and wdra
    ./bin/cryptogen generate --config=./cryptogen/crypto-config.yaml --output="crypto-config"

    res=$?

    { set +x; } 2>/dev/null
    if [ $res -ne 0 ]; then
      fatalln "Failed to generate certificates..."
    fi
}

function generateGenesisBlock() {
    ./bin/configtxgen -profile Raft -configPath $PWD -channelID sys-channel -outputBlock ./channel-artifacts/orderer.genesis.block
}

function createChannel() {
    echo "creating channel ${CHANNEL_NAME}"
    ./bin/configtxgen -profile SixOrgsChannel -outputCreateChannelTx ./channel-artifacts/$CHANNEL_NAME.tx -channelID $CHANNEL_NAME
}


function anchorUpdate() {
    echo "update anchors"

    ./bin/configtxgen -profile SixOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/wdraMSPanchors.tx -channelID $CHANNEL_NAME -asOrg wdraMSP
}

function networkUP() {
    # clean cryptographic files
    # cleanCrypto

    # cleanArtifacts
    
    # generate cryptographic files
    # generateCrypto

    # run containers
    sudo docker-compose -f ./compose/docker-compose.yaml up -d
    

    # print all containers
    sudo docker ps -a
}

function pullImages() {
    sudo docker pull hyperledger/fabric-orderer:2.4
    sudo docker tag hyperledger/fabric-orderer:2.4 hyperledger/fabric-orderer:latest

    sudo docker pull hyperledger/fabric-peer:2.4
    sudo docker tag hyperledger/fabric-peer:2.4 hyperledger/fabric-peer:latest

    sudo docker pull hyperledger/fabric-ca:1.5
    sudo docker tag hyperledger/fabric-ca:1.5 hyperledger/fabric-ca:latest

    sudo docker pull hyperledger/fabric-tools:2.4
    sudo docker tag hyperledger/fabric-tools:2.4 hyperledger/fabric-tools:latest


}

function joinChannel() {
    CHANNEL_NAME=coldstorage

}

export COMPOSE_PROJECT_NAME=compose
export IMAGE_TAG=latest
export SYS_CHANNEL=sys-channel

MODE=$1

if [ "$MODE" == "up" ]; then
    echo "bringing network up"
    networkUP
fi


if [ "$MODE" == "generatecrypto" ]; then
    echo "bringing network up"
    generateCrypto
fi

SYS_CHANNEL=sys-channel


if [ "$MODE" == "genesis" ]; then
    echo "creating genesis block"
    generateGenesisBlock
fi


CHANNEL_NAME=coldstorage


if [ "$MODE" == "createchannel" ]; then
    echo "creating genesis block"
    createChannel
fi

if [ "$MODE" == "updateanchor" ]; then
    echo "updating anchors"
    anchorUpdate
fi


if [ "$MODE" == "fabricca" ]; then
    echo "updating crypto using fabric ca"
    generateCryptoFabric
fi
