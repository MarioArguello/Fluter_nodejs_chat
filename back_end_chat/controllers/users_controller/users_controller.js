const User = require('../../models/user/user');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const keys = require('../../config/keys');
const storage = require('../../utils/cloud_storage');
const asyncForEach = require('../../utils/async_foreach');


module.exports = {
    async getAll(req, res, next) {
        try {
            const id = req.params.id;
            const data = await User.getAll(id);
            console.log(`usuarios : ${data}`);
            return res.status(201).json(data);
        } catch (error) {
            console.log(`Error: ${error}`);
            return res.status(501).json({
                success: false,
                message: 'Error al obtener los usuarios'
            });
        }
    },
    async getPerson(req, res, next) {
        try {
            const id = req.params.id;
            const name = req.params.name;
            const data = await User.getAllPerson(id, name);
            console.log(`usuarios : ${data}`);
            return res.status(201).json(data);
        } catch (error) {
            console.log(`Error: ${error}`);
            return res.status(501).json({
                success: false,
                message: 'Error al obtener los usuarios'
            });
        }
    },

    async registro(req, res, next) {
        try {
            const user = req.body;
            const data = await User.create(user);
            return res.status(201).json({
                success: true,
                message: 'El registro se realizo con exito',
                data: data.id
            });

        } catch (error) {
            console.log(`Error: ${error}`);
            return res.status(501).json({
                success: false,
                message: 'Error al registro del usuario',
                error: error
            });
        }
    },
    async updateUser(req, res, next) {
        try {
            const user = req.body;
            await User.update(user);
            return res.status(201).json({
                success: true,
                message: 'El usuario se actualizo con exito',
                data: user
            });

        } catch (error) {
            console.log(`Error: ${error}`);
            return res.status(501).json({
                success: false,
                message: 'Error al actualizar el usuario',
                error: error
            });
        }
    },
    async updateNotificationToken(req, res, next) {
        try {
            const body = req.body;
            console.log(`Token de notificacion: ${body.notification_token}`);
            console.log(`Token id : ${body.id}`);
            await User.updateNotificationToken(body.id, body.notification_token);
            return res.status(201).json({
                success: true,
                message: 'El token se a actualizo con exito'
            });

        } catch (error) {
            console.log(`Error: ${error}`);
            return res.status(501).json({
                success: false,
                message: 'Error al actualizar el token',
                error: error
            });
        }
    },


    async registerWithImage(req, res, next) {
        try {
            const user = JSON.parse(req.body.user);

            const files = req.files;

            if (files.length > 0) {
                const pathImage = `image_${Date.now()}`;
                const url = await storage(files[0], pathImage);
                if (url != undefined && url != null) {
                    user.image = url;
                }
            }

            const data = await User.create(user);
            user.id = data.id;
            const token = jwt.sign({ id: user.id, email: user.email }, keys.secretOrKey, {});
            user.session_token = `JWT ${token}`;
            console.log(`Toker de acceso ${user.session_token}`);
            return res.status(201).json({
                success: true,
                message: 'El registro se realizo con exito',
                data: user
            });

        } catch (error) {
            console.log(`Error: ${error}`);
            return res.status(501).json({
                success: false,
                message: 'Error al registro del usuario',
                error: error
            });
        }
    },
    async UpdateWithImage(req, res, next) {
        try {
            const user = JSON.parse(req.body.user);
            console.log(user);
            const perfilAndPortada = req.body.tipo;
            const files = req.files;
            if (perfilAndPortada == 'PERFIL') {
                if (files.length > 0) {
                    const pathImage = `image_${Date.now()}`;
                    const url = await storage(files[0], pathImage);
                    if (url != undefined && url != null) {
                        user.image = url;
                    }
                }
            } else if (perfilAndPortada == 'PORTADA') {
                if (files.length > 0) {
                    const pathImage = `image_${Date.now()}`;
                    const url = await storage(files[0], pathImage);
                    if (url != undefined && url != null) {
                        user.img_portada = url;
                    }
                }
            }
            await User.update(user);
            console.log('Usuario actualizado', user);
            return res.status(201).json({
                success: true,
                message: 'La actualizacion se realizo con exito',
                data: user
            });

        } catch (error) {
            console.log(`Error: ${error}`);
            return res.status(501).json({
                success: false,
                message: 'Error al actualizar el usuario',
                error: error
            });
        }
    },

    async UpdateWithDoubleImage(req, res, next) {
        try {
            const user = JSON.parse(req.body.user);
            console.log(user);
            let inserts = 0;
            const files = req.files;
            if (files.length === 0) {
                return res.status(501).json({
                    success: false,
                    message: 'Error al registrar el usuario, no tiene imagenes',
                });
            } else {
                const data_user = await User.update(user);
                if(data_user){
                    const start = async (image_perfil) => {
                        console.log(` update #${inserts} ${user.id}`);
                        await asyncForEach(files, async (file) => {
                            const pathImage = `image_${Date.now()}`;
                            const url = await storage(file, pathImage);
                            if (url != undefined && url != null) {
                                if (inserts == 0) {
                                    inserts = inserts + 1;
                                    console.log(`NUMBER ${inserts}`);
                                    user.image = url;
                                } else if (inserts == 1) {
                                    console.log(`NUMBER ${inserts}`);
                                    user.img_portada = url;
                                }
                            }
                            console.log(`user ${user}`);
                            console.log(user);
                           const user_newdata = await User.update(user);
                           console.log(`user_newdata ${user_newdata}`);
                           if (inserts == files.length) { // TERMINO DE ALAMACENAR LAS TRES IMAGENES
                                return res.status(201).json({
                                    success: true,
                                    message: 'El usuario se almaceno correctamente',
                                    data: user_newdata
                                });
                            }
                        });
                    }
                    start();
                }
                
            }

            await User.update(user);
            console.log('Usuario actualizado', user);
            return res.status(201).json({
                success: true,
                message: 'La actualizacion se realizo con exito',
                data: user
            });

        } catch (error) {
            console.log(`Error: ${error}`);
            return res.status(501).json({
                success: false,
                message: 'Error al actualizar el usuario',
                error: error
            });
        }
    },
    async checkIfIsOnline(req, res, next) {
        try {
            const id = req.params.id;
            const data = await User.checkIfIsOnline(id);
            console.log(`checkIfIsOnline data: ${data}`);
            return res.status(201).json(data);
        }
        catch (error) {
            console.log(`Error: ${error}`);
            return res.status(501).json({
                success: false,
                message: 'Error al obtener los usuarios'
            });
        }
    },
    async correoverificar(req, res, next) {
        try {
            const email = req.body.email;
            const data = await User.findByEmail(email);
            console.log(`Verificar correo electronico: ${data}`);
            if (!data) {
                return res.status(401).json(
                    {
                        success: false,
                        message: 'El email no fue encontrado'
                    }
                );
            }
            return res.status(201).json({
                success: true,
                message: 'El usuario a sigo autenticado corectamente',
                data: data
            });
        }
        catch (error) {
            console.log(`Error: ${error}`);
            return res.status(501).json({
                success: false,
                message: 'Error al correo'
            });
        }
    },
    async login(req, res, next) {
        try {
            const email = req.body.email;
            const password = req.body.password;

            const myUser = await User.findByEmail(email);
            if (!myUser) {
                return res.status(401).json(
                    {
                        success: false,
                        message: 'El email no fue encontrado'
                    }
                );
            }
            const IsPasswordValid = await bcrypt.compare(password, myUser.password);
            if (IsPasswordValid) {
                const token = jwt.sign({ id: myUser.id, email: myUser.email }, keys.secretOrKey, {
                    // expiresIn:
                });
                const data = {
                    id: myUser.id,
                    name: myUser.name,
                    lastname: myUser.lastname,
                    email: myUser.email,
                    phone: myUser.phone,
                    image: myUser.image,
                    img_portada: myUser.img_portada,
                    session_token: `JWT ${token}`
                };
                return res.status(201).json(
                    {
                        success: true,
                        message: 'El usuario a sigo autenticado corectamente',
                        data: data
                    }
                );
            } else {
                return res.status(401).json(
                    {
                        success: false,
                        message: 'La contraseña es incorrecta'
                    }
                );
            }



        } catch (error) {
            console.log(`Error: ${error}`);
            return res.status(501).json({
                success: false,
                message: 'Error con el login',
                error: error
            });
        }

    },


};