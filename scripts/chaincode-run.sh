#!/bin/bash

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


peer chaincode query -C coldstorage -n helloworld -c '{"Args": ["queryHelloWorld"]}'

peer chaincode invoke -o orderer1.group:7050 --tls --cafile $ORDERER_CA  -C coldstorage -n wdra --peerAddresses dpstr.wdra.group:30051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE  -c '{"Args": ["addColdStorages", "sc3"] }'



peer chaincode invoke -o orderer1.group:7050 --tls --cafile $ORDERER_CA  -C coldstorage -n wdra --peerAddresses dpstr.wdra.group:30051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE  -c '{"Args": ["registerColsStorage", "sc4", "hash"] }'

peer chaincode query -C coldstorage -n wdra -c '{"Args": ["quryAllColdStorages"]}'
# peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n mycc --peerAddresses peer0.org1.example.com:7051  --peerAddresses peer0.org2.example.com:9051 -c '{"Args":["invoke","a","b","10"]}'

# make cold storage inactive
peer chaincode invoke -o orderer1.group:7050 --tls --cafile $ORDERER_CA  -C coldstorage -n wdra --peerAddresses dpstr.wdra.group:30051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE  -c '{"Args": ["makeColdStorageInactive", "sc3"] }'

peer chaincode query -C coldstorage -n wdra -c '{"Args": ["quryAllColdStorages"]}'

peer chaincode query -C coldstorage -n wdra -c '{"Args": ["GetCSById", "sc3"]}'




# user
peer chaincode query -C $CHANNEL_NAME -n wdra -c '{"Args":["QueryAllUsers"]}'
peer chaincode invoke -o orderer1.group:7050 --tls --cafile $ORDERER_CA  -C coldstorage -n wdra --peerAddresses dpstr.wdra.group:30051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE  -c '{"function":"RegisterUser","Args":["user2", "{\"name\": \"Bob\"}"]}'
peer chaincode query -C $CHANNEL_NAME -n wdra -c '{"Args":["QueryUserById","user1"]}'


# quotation
peer chaincode query -C $CHANNEL_NAME -n wdra -c '{"Args":["GetRequestsForQuotationByUserId", "user1"]}'
peer chaincode invoke -o orderer1.group:7050 --tls --cafile $ORDERER_CA  -C coldstorage -n wdra --peerAddresses dpstr.wdra.group:30051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE  -c '{"function":"RequestForQuotation","Args":["user1", "req1", "{\"name\": \"Bob\"}"]}'
# peer chaincode invoke -o orderer1.group:7050 --tls --cafile $ORDERER_CA  -C coldstorage -n wdra --peerAddresses dpstr.wdra.group:30051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE  -c '{"function":"RegisterUser","Args":["user2", "{\"name\": \"Bob\"}"]}'
# peer chaincode query -C $CHANNEL_NAME -n wdra -c '{"Args":["QueryUserById","user1"]}'

# quotes
peer chaincode query -C $CHANNEL_NAME -n wdra -c '{"Args":["GetQuotationsByReqId", "req1"]}'
peer chaincode invoke -o orderer1.group:7050 --tls --cafile $ORDERER_CA  -C coldstorage -n wdra --peerAddresses dpstr.wdra.group:30051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE  -c '{"function":"QuoteResponseFromCS","Args":["res1", "req1", "{\"name\": \"Bob\"}"]}'
# peer chaincode query -C $CHANNEL_NAME -n wdra -c '{"Args":["QueryUserById","user1"]}'


# proposal confirmation
peer chaincode query -C $CHANNEL_NAME -n wdra -c '{"Args":["ReqStatus", "req1"]}'
peer chaincode invoke -o orderer1.group:7050 --tls --cafile $ORDERER_CA  -C coldstorage -n wdra --peerAddresses dpstr.wdra.group:30051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE  -c '{"function":"ConfirmProposal","Args":["cnf1", "res1", "req1", "{\"name\": \"Bob\"}"]}'


# peer chaincode query -C $CHANNEL_NAME -n wdra -c '{"Args":["GetCSById","cs1"]}'
# peer chaincode query -C $CHANNEL_NAME -n wdra -c '{"Args":["peer chaincode query -C $CHANNEL_NAME -n wdra -c '{"Args":["GetCSById","cs1"]}'","CS1"]}'


