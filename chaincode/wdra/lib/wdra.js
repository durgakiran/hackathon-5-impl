/* eslint-disable strict */
/*eslint strict: ["error", "global"]*/


const { Contract } = require('fabric-contract-api');


class WdraContract extends Contract {

    constructor() {
        super();
    }

    /**
     * Instantiate to perform any setup of the ledger that might be rquired
     */
    async instantiate(ctx) {
        console.log('instantiated');
    }

    /**
     * adds new registerd cold storage to ledger
     */
    async addColdStorages(ctx, id) {
        const wdrId = 'WDR-' + id;

        // id should not already existing
        const csInfo = await ctx.stub.getState(wdrId);

        if (csInfo) {
            const csInfoObject = csInfo.toString();
            if (csInfoObject) {
                throw new Error(`cs with ${id} already exists`);
            }
        }

        await ctx.stub.putState(wdrId, Buffer.from(JSON.stringify({ wdrId: wdrId, id, active: true })));
    }

    /**
     * adds new registerd cold storage to ledger
     */
    async makeColdStorageInactive(ctx, id) {
        const wdrId = 'WDR-' + id;

        // id should not already existing
        const csInfo = await ctx.stub.getState(wdrId);

        if (!csInfo) {
            throw new Error(`cs with ${id} does not exists`);
        }

        await ctx.stub.putState(wdrId, Buffer.from(JSON.stringify({ wdrId: wdrId, id, active: false })));
    }

    async registerColdStorage(ctx, id, info) {
        const csId = 'CSR-' + id;
        const wdraId = 'WDR-' + id;

        // id should not already existing
        const csInfo = await ctx.stub.getState(csId);
        console.log('activeObect data: ', csInfo);
        if (csInfo) {
            const csInfoObject = csInfo.toString();
            if (csInfoObject) {
                throw new Error(`cs with ${id} already exists`);
            }
        }

        let active = false;
        const activeObject = await ctx.stub.getState(wdraId);

        console.log('activeObect data: ', activeObject);
        if (activeObject) {
            const stringified = activeObject.toString();
            if (stringified) {
                const parsed = JSON.parse(stringified);
                if (parsed.active === true) {
                    active = true;
                }
            }
        }

        await ctx.stub.putState(csId, Buffer.from(JSON.stringify({csId, wdraId, info, id, type: 'cs', active})));
    }

    async quryAllColdStorages(ctx) {
        const startKey = '';
        const endKey = '';
        const allResults = [];
        for await (const { key, value } of ctx.stub.getStateByRange(startKey, endKey)) {
            const strValue = Buffer.from(value).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(key, value, err);
                record = strValue;
            }
            if (record.type === 'cs') {
                allResults.push({ Key: key, Record: record });
            }
        }
        console.info(allResults);
        return JSON.stringify(allResults);
    }

    async GetCSById(ctx, id) {
        // received data would be in bytes
        const csId = 'CSR-' + id;
        const csInfoByte = await ctx.stub.getState(csId);
        if (!csInfoByte) {
            throw new Error(`${csId} does not exist`);
        }

        return csInfoByte.toString();
    }

    /**
     * we take info and push it to HLF
     */
    async RegisterUser(ctx, userId, userInfo) {
        const user = {
            id: userId,
            info: userInfo,
            type: 'user'
        };

        await ctx.stub.putState(userId, Buffer.from(JSON.stringify(user)));
    }

    async QueryAllUsers(ctx) {
        console.info('==========queried for all users==========');
        const startKey = '';
        const endKey = '';
        const allResults = [];
        for await (const { key, value } of ctx.stub.getStateByRange(startKey, endKey)) {
            const strValue = Buffer.from(value).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            if (record.type === 'user') {
                allResults.push({ Key: key, Record: record });
            }
        }
        console.info(allResults);
        return JSON.stringify(allResults);
    }

    async QueryUserById(ctx, userId) {
        console.info('==========queried for user by id==========');
        const userInfoByte = await ctx.stub.getState(userId);
        if (!userInfoByte) {
            throw new Error(`${userId} does not exist`);
        }

        return userInfoByte.toString();
    }


    /**
     *
     */
    async RegisterInsurer(ctx, insuranceOrgId, insOrgInfo) {
        const insuranceOrgInfo = {
            id: insuranceOrgId,
            info: insOrgInfo,
            type: 'insurer'
        };

        await ctx.stub.putState(insuranceOrgId, Buffer.from(JSON.stringify(insuranceOrgInfo)));
    }


    async RegisterCollateralManager(ctx, cmId, cmInfo) {
        const collateralManagerInfo = {
            id: cmId,
            info: cmInfo,
            type: 'cm'
        };

        await ctx.stub.putState(cmId, Buffer.from(JSON.stringify(collateralManagerInfo)));
    }

    async RegisterTralog(ctx, trId, trInfo) {
        const tralogInfo = {
            id: trId,
            info: trInfo,
            type: 'trl'
        };

        await ctx.stub.putState(trId, Buffer.from(JSON.stringify(tralogInfo)));
    }


    async RequestForQuotation(ctx, userId, reqId, reqInfo) {
        const requestInfo = {
            id: reqId,
            userId: userId,
            info: reqInfo,
            type: 'quotation'
        };

        await ctx.stub.putState(reqId, Buffer.from(JSON.stringify(requestInfo)));
    }

    async GetRequestsForQuotationByUserId(ctx, userId) {
        const startKey = '';
        const endKey = '';
        const allResults = [];
        for await (const { key, value } of ctx.stub.getStateByRange(startKey, endKey)) {
            const strValue = Buffer.from(value).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            if (record.type === 'quotation' && record.userId === userId) {
                allResults.push({ Key: key, Record: record });
            }
        }
        console.info(allResults);
        return JSON.stringify(allResults);

    }


    async QuoteResponseFromCS(ctx, resId, reqId, reqInfo) {
        const responseInfo = {
            id: resId,
            reqId,
            info: reqInfo,
            type: 'quotationresponse'
        };

        await ctx.stub.putState(resId, Buffer.from(JSON.stringify(responseInfo)));
    }

    async GetQuotationsByReqId(ctx, reqId) {
        const startKey = '';
        const endKey = '';
        const allResults = [];
        for await (const { key, value } of ctx.stub.getStateByRange(startKey, endKey)) {
            const strValue = Buffer.from(value).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            if (record.type === 'quotationresponse' && record.reqId === reqId) {
                allResults.push({ Key: key, Record: record });
            }
        }
        console.info(allResults);
        return JSON.stringify(allResults);
    }

    async ConfirmProposal(ctx, cnfId, resId, reqId, resInfo) {
        const confirmInfo = {
            id: cnfId,
            resId: resId,
            reqId,
            info: resInfo,
            type: 'proposalconfirmation'
        };

        await ctx.stub.putState(cnfId, Buffer.from(JSON.stringify(confirmInfo)));
    }

    async ReqStatus(ctx, reqId) {
        const startKey = '';
        const endKey = '';
        const allResults = [];
        for await (const { key, value } of ctx.stub.getStateByRange(startKey, endKey)) {
            const strValue = Buffer.from(value).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            if (record.type === 'proposalconfirmation' && record.reqId === reqId) {
                allResults.push({ Key: key, Record: { confirmed: true } });
            }
        }
        console.info(allResults);
        return JSON.stringify(allResults);
    }


}

module.exports = WdraContract;
