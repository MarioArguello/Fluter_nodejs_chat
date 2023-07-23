const Category = require('../models/category');

module.exports = {

    async create(req, res) {
        try {
            const categorybody = req.body;
           
            console.log(`data category body: ${categorybody.name}`);
            console.log(`data category body: ${categorybody.description}`);
          
            const data = await Category.create(categorybody);
            console.log(`data name :${data.name}`);
            console.log(`data data :${data}`);
            if(data){
                return res.status(201).json({
                    success: true,
                    message: 'Se a creado correctamente la categoria',
                    data: data.id
                });
            }
        } catch (error) {
            console.log(`Error: ${error}`);
            return res.status(501).json({
                success: false,
                message: 'Error al crear categoria',
                error: error
            });
        }
    },

   async getAll(req, res) {
    try {
    const id_person = req.params.id_person;
       const data = await Category.getAll(id_person);
       console.log(`Categorias : ${data}`);
       return res.status(201).json(data);
    } catch (error) {
        console.log(`Error: ${error}`);
        return res.status(501).json({
            success: false,
            message: 'Error al obtener las categorias'
        });
    }
        
    }

}