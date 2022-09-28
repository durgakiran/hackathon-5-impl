/* eslint-disable strict */
/*eslint strict: ["error", "global"]*/


const { Contract } = require('fabric-contract-api');


class HelloWorldContract extends Contract {

    constructor() {
        super();
    }

    /**
     * Instantiate to perform any setup of the ledger that might be rquired
     */
    async instantiate(ctx) {
        console.log('instantiated');
    }

    async queryHelloWorld(ctx){
        return 'Hello World';
    }

}

module.exports = HelloWorldContract;
