const mysql = require("mysql");
const config = require("./config").database;

var db;

function DatabaseConnection() {
    if (!db) {
        db = mysql.createConnection(config);
        db.connect( (error) => {
            if (error) {
                console.log(`Error when connecting to the sql db: ${error}`);
                setTimeout(DatabaseConnection, 2000);
            }
            console.log("MySQL Connection Created");
        });

        db.on("error", (error) => {
            if (error.code == "PROTOCOL_CONNECTION_LOST") {
                DatabaseConnection();
            } else {
                throw error;
            }
        });
    }
    return db
}

module.exports = DatabaseConnection();

console.log("[DatabaseAPI Message] : Loaded 'database.js'");