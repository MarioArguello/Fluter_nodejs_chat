const message_controller = require('../controllers/message_controller');
const passport = require('passport');
module.exports = (app,upload) => {
    //peticiones post-envios
    app.post('/api/message/create', passport.authenticate('jwt', { session: false }), message_controller.create);
   
    app.put('/api/message/updatetoSeen', passport.authenticate('jwt', { session: false }), message_controller.updateMessageSeen);
    app.put('/api/message/updatetoRecived', passport.authenticate('jwt', { session: false }), message_controller.updateMessageRecived);
   
    app.post('/api/message/createWithImage', passport.authenticate('jwt', { session: false }),upload.array('image',1), message_controller.createWithImage);
    
    app.post('/api/message/createWithVideo', passport.authenticate('jwt', { session: false }),upload.single('video'), message_controller.createWithVideo);
    
    
    app.get('/api/message/findByChat/:id_chat', passport.authenticate('jwt', { session: false }), message_controller.findByChat);

}