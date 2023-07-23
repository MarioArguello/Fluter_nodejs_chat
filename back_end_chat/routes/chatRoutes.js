const chat_controller = require('../controllers/chat_controller');
const passport = require('passport');
module.exports = (app) => {
    //peticiones post-envios
    app.post('/api/chat/create', passport.authenticate('jwt', { session: false }), chat_controller.create);
    app.get('/api/chat/findBYidUser/:id_user', passport.authenticate('jwt', { session: false }), chat_controller.findByUser);

}