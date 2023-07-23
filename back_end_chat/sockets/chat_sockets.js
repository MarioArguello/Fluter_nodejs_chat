const User = require('../models/user/user');
const Message = require('../models/message');


module.exports = (io) => {
    const chatNSP = io.of('/chat');
    chatNSP.on('connection', function (socket) {
        console.log('Usuario se conecto a socket io', socket.id);
        socket.on('message', function (data) {
            console.log('Nuevo mensaje', data);
            chatNSP.emit(`message/${data.id_chat}`, data);
            chatNSP.emit(`message/${data.id_user}`, data);
        });
        socket.on('writing', function (data) {
            console.log('Usuario escribiendo', data);
            chatNSP.emit(`writing/${data.id_chat}/${data.id_user}`, data);
        });

        socket.on('seen', function (data) {
            console.log('Mensaje visto', data);
            chatNSP.emit(`seen/${data.id_chat}`, data);
        });
        socket.on('received', async function (data) {
            console.log('Mensaje recivido', data);
            chatNSP.emit(`received/${data.id_chat}`, data);
            await Message.updateToReceived(data.id_message);
        });
        socket.on('online', async function (data) {
            chatNSP.emit(`online/${data.id_user}`, { id_socket: socket.id });
            await User.updateOnlineByUser(data.id_user, true);
            await User.updateIdSocket(data.id_user, socket.id);
            console.log('UN NUEVO USUARIO SE CONECTO AL CHAT', socket.id);
        });
        socket.on('disconnect', async function (data) {
            console.log('UN USUARIO SE DESCONECTO', socket.id);
            chatNSP.emit(`offline/${socket.id}`, { id_socket: socket.id });
            await User.updateOnlineBySocket(socket.id, false);
        });
    });

}