const db = require("./database");
const jwt = require("jsonwebtoken");
const config = require("./config").api;


db.config.queryFormat = function (query, values) {
    if (!values) return query;
    return query.replace(/\:(\w+)/g, function (txt, key) {
      if (values.hasOwnProperty(key)) {
        return this.escape(values[key]);
      }
      return txt;
    }.bind(this));
};

module.exports = (app) => {

    // Authentication Request
    app.post(config.route + "/authentication", (req, res) => {
        if (CheckSecretKey(req.body.secret, config.secret) == true) {
            jwt.sign({ community: req.body.community }, req.body.secret, {expiresIn: '2 days'}, (error, token) => {
                res.json({status: true, message: "Key Valid", authToken: token});
            })
        } else {
            res.json({status: false, message: "Key Invalid", token: ""});
        };
    });

    // Database Request
    app.post(config.route + "/execute", verifyToken, (req, res) => {
        jwt.verify(req.token, req.body.secret, (error, authData) => {
            if (error) {
                res.json({status: false, message: error, results: ""});
            } else {
                db.query(req.body.query, req.body.data, (error, results, fields) => {
                    if (error) {
                        res.json({status: false, message: error, results: "[]"});
                    } else {
                        res.json({status: true, message: "Query Success", results: results});
                    }
                })
            }
        })
    });
}

// Verifying Bearer Token
function verifyToken(req, res, next) {
    const bearerHeader = req.headers["authentication"];
    if (typeof bearerHeader !== "undefined") {
        const bearer = bearerHeader.split(" ");
        const bearerToken = bearer[1];
        req.token = bearerToken;
        next()
    } else {
        res.json("Token Not Found");
    }
}

// Check Secret Key Matches
function CheckSecretKey(key, secret) {
    if (key != secret) {
        return false
    } else {
        return true
    }
}

console.log("[DatabaseAPI Message] : Loaded 'routes.js'");