const promise = require('bluebird');
const options = {
    promiseLib: promise,
    query: (e) => { }
}
const pgp = require('pg-promise')(options);
const types = pgp.pg.types;
types.setTypeParser(1114, function(stringValue) {
    return stringValue;
});
const databaseConfig = {
    'host': '',
    'port': 5432,
    'database': '',
    'user': '',
    'password': ''
};
const db = pgp(databaseConfig);
module.exports = db;