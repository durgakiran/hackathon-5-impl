const express = require('express')
const main = require('.')
const quryAllColdStorages = require('./coldstorages')
const registerColdStorage = require('./registerColdStorage')
const bodyParser = require("body-parser");
const queryAllUsers = require('./queryAllUsers');
const queryUserById = require('./queryUserById');
const invokeRegisterUser = require('./invokeRegisterUser');
const queryRequestForQuotationByUserId = require('./queryRequestsForQuotationByUserId');
const queryQuotationRequestId = require('./queryQuotationByRequestId');
const quryRequestStatus = require('./queryRequestStatus');
const invokeRequestForQuotation = require('./invokeRequestForQuotation');
const invokeQuoteResponseFromCS = require('./invokeQuoteResponseFromCS');
const invokeConfirmProposal = require('./invokeConfirmProposal');
const uuid = require('uuid');
const app = express()
const port = 3007;


const BAD_REQUEST = 'BAD_REQUEST';

//Here we are configuring express to use body-parser as middle-ware.
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());


app.get('/', async (req, res) => {
    res.send(await main())
})


app.post('/dummy', (req, res) => {
    console.log(req.body);
    console.log(req.params);
    console.log(req.headers);
    return res.send({ message: req.body });
});

// register cold storages
app.post('/warehouse/register', async (req, res) => {
    const body = req.body;
    console.log(req.body);

    try {
        const id = uuid.v4();
        // TODO: needs to add validation
        if (body) {
            await registerColdStorage(id, body);
        } else {
            throw new Error('Bad request');
        }

        return res.send({ message: 'success' });
    } catch {
        return res.status(400).send({ message: BAD_REQUEST });
    }

});


app.get('/coldstorages/list', async (req, res) => {
    try {
        const result = JSON.parse(await quryAllColdStorages());
        for (const data of result) {
            try {
                data.Record.info = JSON.parse(data.Record.info);
            } catch {
                data.Record.info = data.Record.info;
            }
        }

        res.send({ data: result });
    } catch (error) {
        console.log(error);
        res.status(400).send({ message: BAD_REQUEST })

    }
});

// users requests 
app.get('/users/list', async (req, res) => {
    try {
        const result = JSON.parse(await queryAllUsers());
        for (const data of result) {
            data.Record.info = JSON.parse(data.Record.info);
        }

        res.send({ data: result });
    } catch {
        res.status(400).send({ message: BAD_REQUEST })

    }
});

app.get('/users/:id', async (req, res) => {
    try {
        const id = req.params;
        const results = JSON.parse(await queryUserById(id.id));
        if (id) {
            res.send({ data: { ...results, info: JSON.parse(results.info) } });
        } else {
            res.status(400).send({ message: BAD_REQUEST })
        }
    } catch {
        res.status(400).send({ message: BAD_REQUEST })

    }
});

app.post('/users/register', async (req, res) => {
    try {
        const body = req.body;
        const id = uuid.v4();
        if (body) {
            await invokeRegisterUser(id, body)
            res.send({ data: 'success' })
        } else {
            res.status(400).send({ message: BAD_REQUEST })
        }
    } catch {
        res.status(400).send({ message: BAD_REQUEST })

    }

});

// quotations requests

app.post('/quotation/request/:userId', async (req, res) => {
    try {
        const body = req.body;
        const params = req.params;
        const userId = params.userId;
        const id = uuid.v4();
        if (body && userId && id) {
            await invokeRequestForQuotation(userId, id, body)
            res.send({ data: 'success' })
        } else {
            res.status(400).send({ message: BAD_REQUEST })
        }
    } catch {
        res.status(400).send({ message: BAD_REQUEST })

    }
});


app.get('/quotation/user/:userid', async (req, res) => {
    try {
        const id = req.params;
        if (id) {
            const results = JSON.parse(await queryRequestForQuotationByUserId(id.userid));
            for (const data of results) {
                try {
                    data.Record.info = JSON.parse(data.Record.info);
                } catch {
                    data.Record.info = data.Record.info;
                }
            }
            res.send({ data: results });
        } else {
            res.status(400).send({ message: BAD_REQUEST })
        }
    } catch (error) {
        console.log(error);
        res.status(400).send({ message: BAD_REQUEST })
    }
});



app.post('/quotation/quote/:warhouseId/:reqId', async (req, res) => {
    const paramas = req.params;
    const body = req.body;
    try {
        if (paramas.warhouseId && paramas.reqId) {
            const info = { ...body, warhouseId: paramas.warhouseId };
            console.log(info);
            const id = uuid.v4();
            await invokeQuoteResponseFromCS(id, paramas.reqId, info);
            res.send({ data: { id } })
        } else {
            res.status(400).send({ message: BAD_REQUEST })
        }
    } catch (error) {
        console.log(error);
        res.status(400).send({ message: BAD_REQUEST })
    }
});

app.post('/quotation/confirm/:reqId/:resId', async (req, res) => {
    const paramas = req.params;
    const body = req.body;
    try {
        if (paramas.reqId && paramas.resId) {
            const info = { ...body };
            console.log(info);
            const id = uuid.v4();
            await invokeConfirmProposal(id, paramas.resId, paramas.reqId, info);
            res.send({ data: { id } })
        } else {
            res.status(400).send({ message: BAD_REQUEST })
        }
    } catch (error) {
        console.log(error);
        res.status(400).send({ message: BAD_REQUEST })
    }
});



app.get('/quotation/status/:reqid', async (req, res) => {
    const id = req.params;
    res.send({ data: JSON.parse(await quryRequestStatus(id.reqid)) })
});

app.get('/quotation/:requestId', async (req, res) => {
    try {
        const id = req.params;
        if (id) {
            const results = JSON.parse(await queryQuotationRequestId(id.requestId));
            for (const data of results) {
                try {
                    data.Record.info = JSON.parse(data.Record.info);
                } catch {
                    data.Record.info = data.Record.info;
                }
            }
            res.send({ data: results });
        } else {
            res.status(400).send({ message: BAD_REQUEST })
        }
    } catch (error) {
        console.log(error);
        res.status(400).send({ message: BAD_REQUEST })
    }
});



// app.post('/users/register', async (req, res) => {
//     const body = req.body;
//     const resId = body.resId;
//     const reqId = body.reqId;
//     const info = body.info;
//     res.send({ data: JSON.parse(await invokeConfirmProposal(resId, reqId, info)) })
//     res.send({ data: JSON.parse(await invokeRegisterUser(body)) })
// });


app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
});
