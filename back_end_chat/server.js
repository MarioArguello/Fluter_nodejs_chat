const express = require('express');
const app = express();
const http = require('http');
const server = http.createServer(app);
const logger = require('morgan');
const cors = require('cors');
const passport = require('passport');

const multer = require('multer');
const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');
const io =require('socket.io')(server);
//Enviar email




/*
Invoacar los socket
*/
const chatSocket = require('./sockets/chat_sockets');

/*

*/
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
})

/*
* RUTAS
*/
const users = require('./routes/usersRoutes');
const chats = require('./routes/chatRoutes');
const messages = require('./routes/message_route');
const categoriesRoutes = require('./routes/categoryRoute');
const productRoutes = require('./routes/productRoute');
const ordersRoutes = require('./routes/orderRoute');


const port = process.env.PORT || 3000;

app.use(logger('dev'));
app.use(express.json());

app.use(express.urlencoded({
    extended: true
}));

app.use(cors());

app.use(passport.initialize());
app.use(passport.session());

// console.log('PASSPORT', passport);

require('./config/passport')(passport);

app.disable('x-powered-by');

app.set('port', port);

chatSocket(io);


const upload = multer({
    storage: multer.memoryStorage()
})

/*
* LLAMANDO A LA RUTAS
*/ 

users(app, upload);
chats(app);
messages(app, upload);
categoriesRoutes(app);
productRoutes(app, upload);
ordersRoutes(app);



server.listen(3000, 'ipconfig-ipmaquina' || 'localhost', function () {
    console.log('Aplicacion de NodeJs ' + port + '  Iniciada...');
});


//ERROR HANDLER

app.use((err, req, res, next) => {
    console.log(err);
    res.status(err.status || 500).send(err.stack);
});

module.exports = {
    app: app,
    server: server
}