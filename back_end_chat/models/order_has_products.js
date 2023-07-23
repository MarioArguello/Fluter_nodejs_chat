const db = require('../config/config');

const OrderHasProducts = {};



OrderHasProducts.create = (id_order, id_product, quantity, result) => {

    const sql = `
    INSERT INTO
        send_sms.order_has_products(
            id_order,
            id_product,
            quantity,
            created_at,
            updated_at   
        )
    VALUES($1, $2, $3, $4, $5) RETURNING id
    `;

   return  db.oneOrNone(
        sql, 
        [
            id_order,
            id_product,
            quantity,
            new Date(),
            new Date(),
        ],
    );

}


module.exports = OrderHasProducts;