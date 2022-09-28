echo "adding new organization Cold storage"


export FABRIC_CFG_PATH=${PWD}

function generatCrypto {
    ./bin/fabric-ca-client version > dev/null 2>&1

    if [[ $? -ne 0 ]]; then
        echo "ERROR! fabric-ca-client binary not found.."
        echo
        echo "Follow the instructions in the Fabric docs to install the Fabric Binaries:"
        echo "https://hyperledger-fabric.readthedocs.io/en/latest/install.html"
        exit 1
    fi

    echo "Generating certificates using fabric ca"

    sudo docker-compoase -f ./cs/compose/docker-compose.yaml -f ./cs/compose/compose_ca_cs.yaml up -d 2>&1

    . fabric-ca/registerEnroll.sh

    # generat artifacts
}


function generateDefinitions {

}

function addCSOrg {
    # byfn network needs to be up
    if [ ! -d ./organizations/ordererOrganizations ]; then
        fatalln "ERROR: Please, run ./network.sh up createChannel first."
    fi

    # generate artifacts if they don't exist
    if [ ! -d "../organizations/peerOrganizations/org3.example.com" ]; then
        generatCrypto
        generateOrg3Definition
    fi

    # bring up the peer server

    # updatechannel configuration transaction

    # join channel

}

