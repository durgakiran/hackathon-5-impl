
sudo docker stop $(sudo docker ps -aq)

sudo docker rm $(sudo docker ps -aq)

sudo docker volume rm $(sudo docker volume ls -q)


MODE=$1


if [ "$MODE" == "deep" ]; then
    echo "removing artifacts and crypto config"
    rm -Rf ./channel-artifacts/
    rm -Rf ./crypto-config/

    mkdir -p channel-artifacts
    mkdir -p crypto-config
fi


