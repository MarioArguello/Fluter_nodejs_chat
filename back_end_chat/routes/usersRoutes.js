const UsersController = require('../controllers/users_controller/users_controller');
const passport = require('passport');
const sendEmailPerson = require('../models/sendEmail');
module.exports = (app, upload) => {
    // peticion get
    // 401 el cliente no esta autorizado para realizar esta peticion
    app.get('/api/users/getAll/:id',passport.authenticate('jwt',{session:false}), UsersController.getAll);
    app.get('/api/users/getPerson/:id/:name',passport.authenticate('jwt',{session:false}), UsersController.getPerson);
    app.get('/api/users/checkIfIsOnline/:id', passport.authenticate('jwt', {session: false}), UsersController.checkIfIsOnline);
   
    //peticiones post-envios
    app.post('/api/users/create',upload.array('image',1), UsersController.registerWithImage);
    app.post('/api/users/login', UsersController.login);
    app.post('/api/users/gmailSend', sendEmailPerson.EnviarCode );
    app.post('/api/users/correoperson', UsersController.correoverificar);

    //peticiones put- actualizar datos
    app.put('/api/users/updateWithImage',passport.authenticate('jwt',{session:false}), upload.array('image',1), UsersController.UpdateWithImage);
    app.put('/api/users/updateWithDoubleImage',passport.authenticate('jwt',{session:false}), upload.array('image',2), UsersController.UpdateWithDoubleImage);
    app.put('/api/users/updateUser',passport.authenticate('jwt',{session:false}),  UsersController.updateUser);
    app.put('/api/users/updateNotificationToken',passport.authenticate('jwt',{session:false}),  UsersController.updateNotificationToken);
   
}