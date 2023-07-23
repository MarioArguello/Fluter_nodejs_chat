const productsController = require('../controllers/productsController');
const passport = require('passport');

module.exports = (app, upload) => {

    app.get('/api/products/findByCategory/:id_category/:id_person',  passport.authenticate('jwt', { session: false }), productsController.findByCategory);
    app.get('/api/products/findByNameAndCategory/:id_category/:name',  passport.authenticate('jwt', { session: false }), productsController.findByNameAndCategory);
    app.post('/api/products/create',  passport.authenticate('jwt', { session: false }), upload.array('image', 2), productsController.create);
}