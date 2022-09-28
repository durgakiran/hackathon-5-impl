/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Gateway, Wallets } = require('fabric-network');
const path = require('path');
const fs = require('fs');


async function queryRequestForQuotationByUserId(id) {
    try {
        // load the network configuration
        const ccpPath = path.resolve(__dirname, 'configurations', 'connection-wdra.json');
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const identity = await wallet.get('appUser');
        if (!identity) {
            console.log('An identity for the user "appUser" does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            return;
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: true, asLocalhost: false } });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('coldstorage');

        // Get the contract from the network.
        const contract = network.getContract('wdra');

        // Evaluate the specified transaction.
        // queryCar transaction - requires 1 argument, ex: ('queryCar', 'CAR4')
        // queryAllCars transaction - requires no arguments, ex: ('queryAllCars')
        const result = await contract.evaluateTransaction('GetRequestsForQuotationByUserId', id);
        console.log(`Transaction has been evaluated, result is: ${result.toString()}`);

        // Disconnect from the gateway.
        await gateway.disconnect();

        return result.toString();
        
    } catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
    }
}

module.exports = queryRequestForQuotationByUserId;
