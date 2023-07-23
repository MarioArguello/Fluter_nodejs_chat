const Product = require('../models/product');
const storage = require('../utils/cloud_storage');
const asyncForEach = require('../utils/async_foreach');


module.exports = {

    async findByCategory(req, res) {
        try {
            const id_category = req.params.id_category;
            const id_person = req.params.id_person;
            const data = await Product.findByCategory(id_category,id_person);
            return res.status(201).json(data);
        } catch (error) {
            return res.status(501).json({
                success: false,
                message: 'Hubo un error al momento de listar los productos',
                error: error
            });
        }

    },

    async findByNameAndCategory(req, res) {
        try {
            const id_category = req.params.id_category;
            const name = req.params.name;
            const data = await Product.findByNameAndCategory(name, id_category);
            return res.status(201).json(data);
        } catch (error) {
            return res.status(501).json({
                success: false,
                message: 'Hubo un error al momento de listar las categorias',
                error: error
            });
        }


    },

    async create(req, res) {
        try {
            console.log(`nombre del producto :`);
            const product = JSON.parse(req.body.product); // CAPTURO LOS DATOS QUE ME ENVIE EL CLIENTE
            console.log(`nombre del producto : ${product.name}`);
            const files = req.files;
            let inserts = 0;
            if (files.length === 0) {
                return res.status(501).json({
                    success: false,
                    message: 'Error al registro del producto',
                    error: error
                });
            }
            else {
                const data = await Product.create(product);
                console.log(`nombre del data.name : ${data.name}`);
                console.log(`nombre del data.id : ${data.id}`);
                console.log(`nombre del data.description : ${data.description}`);
                console.log(`nombre del data.price : ${data.price}`);
                if (data) {
                    const start = async (url1) => {
                        await asyncForEach(files, async (file) => {
                            const path = `image_${Date.now()}`;
                            const url = await storage(file, path);
                            if (url != undefined && url != null) { // CREO LA IMAGEN EN FIREBASE
                                if (inserts == 0) { //IMAGEN 1
                                    inserts+=1;
                                    console.log(` inserts : ${inserts}`);
                                    url1=url
                                    const Updatedata = {
                                        name: data.name,
                                        description: data.description,
                                        price: data.price,
                                        image1: url1,
                                        quantity_product: data.quantity_product,
                                        id_category: data.id_category,
                                        id_person: data.id_person,
                                        id: data.id
                                    };
                                    Product.update(Updatedata);
                                    console.log(`nombre del data.image1 : ${data.image1}`);
                                }
                                else if (inserts == 1) { //IMAGEN 2
                                    console.log(`Segunda vuelta `);
                                    const Updatedata = {
                                        name: data.name,
                                        description: data.description,
                                        price: data.price,
                                        image1: url1,
                                        image2: url,
                                        quantity_product: data.quantity_product,
                                        id_category: data.id_category,
                                        id_person: data.id_person,
                                        id: data.id
                                    };
                                     Product.update(Updatedata);
                                        return res.status(201).json({
                                            success: true,
                                            message: 'El producto se almaceno correctamente',
                                            data: Updatedata
                                        });
                                    }

                                }
                            }
                        )}
                    start();
                }
            }
        } catch (error) {
            console.log(`Error: ${error}`);
            return res.status(501).json({
                success: false,
                message: 'Error al registro del usuario',
                error: error
            });
        }



    }

}