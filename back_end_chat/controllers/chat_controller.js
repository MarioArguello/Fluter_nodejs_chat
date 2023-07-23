const Chat = require('../models/chat');

module.exports = {
    async create(req, res, next) {
        try {
            const chat = req.body;

            const existChat = await Chat.findByUserOneandUser2(chat.id_user1, chat.id_user2);

            if (existChat) {
                console.log('Actualizar chat');
                await Chat.update(chat);
                return res.status(201).json({
                    message: 'El chat se a actualizado correctamente',
                    success: true,
                    data: existChat.id
                })
            } else {
                console.log('Crear chat');
                const data = await Chat.create(chat);
                return res.status(201).json({
                    message: 'El chat se a creado correctamente',
                    success: true,
                    data: data.id
                })
            }

        } catch (error) {
            console.log(error)
            return res.status(501).json({
                message: 'No se pudo crear el chat',
                success: false,
                error: error
            });
        }

    },
    async findByUser(req,res,next){
        try {
            const idUser = req.params.id_user;
            const data = await Chat.findByIdUser(idUser);
            return res.status(201).json(data);
        } catch (error) {
            console.log(error)
            return res.status(501).json({
                message: 'No se pudo listar el chat',
                success: false,
                error: error
            });
        }
    }
}