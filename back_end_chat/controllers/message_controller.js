const e = require('express');
const Message = require('../models/message');
const storage = require('../utils/cloud_storage');
const videoStorage = require('../utils/cloud_storage_video');
module.exports = {
    async create(req, res, next) {
        try {
            const message = req.body;
            const data = await Message.create(message);

            return res.status(201).json({
                message: 'El mensaje se a creado correctamente',
                success: true,
                data: data.id
            })
        } catch (error) {
            console.log(error)
            return res.status(501).json({
                message: 'No se pudo crear el mensaje',
                success: false,
                error: error
            });
        }

    },
    async updateMessageSeen(req, res, next) {
        try {
            const id = req.body.id;
            await Message.updateToSeen(id);

            return res.status(201).json({
                message: 'El mensaje se a actualizado correctamente',
                success: true
            })
        } catch (error) {
            console.log(error)
            return res.status(501).json({
                message: 'No se pudo actualizar el mensaje',
                success: false,
                error: error
            });
        }

    },
    async updateMessageRecived(req, res, next) {
        try {
            const id = req.body.id;
            await Message.updateToReceived(id);

            return res.status(201).json({
                message: 'El mensaje se a actualizado correctamente',
                success: true
            })
        } catch (error) {
            console.log(error)
            return res.status(501).json({
                message: 'No se pudo actualizar el mensaje',
                success: false,
                error: error
            });
        }

    },
    async findByChat(req, res, next) {
        try {
            const id_chat = req.params.id_chat;
            const data = await Message.findbyChat(id_chat);

            return res.status(201).json(data);
        } catch (error) {
            console.log(error)
            return res.status(501).json({
                message: 'No se pudo leer los mensajes',
                success: false,
                error: error
            });
        }

    },
    async createWithImage(req, res, next) {
        try {
            const message = JSON.parse(req.body.message);

            const files = req.files;

            if (files.length > 0) {
                const pathImage = `image_${Date.now()}`;
                const url = await storage(files[0], pathImage);
                if (url != undefined && url != null) {
                    message.url = url;
                }
            }

            const data = await Message.create(message);


            return res.status(201).json({
                success: true,
                message: 'El mensaje se a creado correctamente',
                data: {'id':data.id,'url':message.url}
            });

        } catch (error) {
            console.log(`Error: ${error}`);
            return res.status(501).json({
                success: false,
                message: 'Error al crear el mensaje',
                error: error
            });
        }
    },
    async createWithVideo(req, res, next) {
        try {
            const message = JSON.parse(req.body.message);

            if (req.file) {
                const path = `video_${Date.now()}`;
                const url = await videoStorage(req.file, path);
                if (url != undefined && url != null) {
                    message.url = url;
                }
                const data = await Message.create(message);


                return res.status(201).json({
                    success: true,
                    message: 'El mensaje se a creado correctamente',
                    data: data.id
                });
            }else{
                return res.status(501).json({
                    success: false,
                    message: 'No se pudo guardar el video'
                });
            }
        } catch (error) {
            console.log(`Error: ${error}`);
            return res.status(501).json({
                success: false,
                message: 'Error un error con la creacion de nuevo mensaje con video',
                error: error
            });
        }
    }
}