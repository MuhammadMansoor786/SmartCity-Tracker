const serverless = require('serverless-http');
const app = require('../../server');

function parseJsonBody(request, event) {
    let body = request.body;
    let fromEventBody = false;

    if (body == null || body === '' || (Buffer.isBuffer(body) && body.length === 0)) {
        body = event.body;
        fromEventBody = true;
    }

    if (body == null || body === '') {
        return;
    }

    if (typeof body === 'object' && !Buffer.isBuffer(body)) {
        request.body = body;
        return;
    }

    const encoded = fromEventBody && event.isBase64Encoded === true;
    const text = Buffer.isBuffer(body)
        ? (encoded ? Buffer.from(body.toString('utf8'), 'base64') : body).toString('utf8')
        : Buffer.from(body, encoded ? 'base64' : 'utf8').toString('utf8');

    try {
        request.body = JSON.parse(text);
    } catch (err) {
        // Leave non-JSON bodies intact for Express and Multer to parse.
    }
}

module.exports.handler = serverless(app, { request: parseJsonBody });
