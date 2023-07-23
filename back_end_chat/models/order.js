const db = require('../config/config');

const Order = {};


Order.findByStatus = (status, result) => {

    const sql = `
    SELECT
        CONVERT(O.id, char) AS id,
        CONVERT(O.id_user, char) AS id_user,
        O.status,
        O.timestamp,
        JSON_OBJECT(
            'id', CONVERT(U.id, char),
            'name', U.name,
            'lastname', U.lastname,
            'image', U.image,
            'phone', U.phone
        ) AS client,
        JSON_ARRAYAGG(
            JSON_OBJECT(
                'id', CONVERT(P.id, char),
                'name', P.name,
                'description', P.description,
                'image1', P.image1,
                'image2', P.image2,
                'quantity_product', P.quantity_product,
                'price', P.price,
                'quantity', OHP.quantity
            )
        ) AS products
    FROM 
        send_sms.orders AS O
    INNER JOIN
        send_sms.users AS U
    ON
        U.id = O.id_user
	
    INNER JOIN
        send_sms.order_has_products AS OHP
    ON
        OHP.id_order = O.id
    INNER JOIN
        send_sms.products AS P
    ON
        P.id = OHP.id_product
    WHERE 
        status = ?
    GROUP BY
        O.id
	ORDER BY
		O.timestamp;
    `;

    db.query(
        sql,
        status,
        (err, data) => {
            if (err) {
                console.log('Error:', err);
                result(err, null);
            }
            else {
                result(null, data);
            }
        }
    )
}

Order.create = (order, result) => {
    const sql = `
    INSERT INTO
        send_sms.orders(
            id_user,
            name_client,
            telefono_client,
            status,
            timestamp,
            created_at,
            updated_at   
        )
    VALUES(?, ?, ?, ?, ?, ?, ?)
    `;

    db.query(
        sql, 
        [
            order.id_user,
            order.name_client,
            order.telefono_client,
            'ORDER', // 1. PAGADO 2. DESPACHADO 3. EN CAMINO 4. ENTREGADO
            Date.now(),
            new Date(),
            new Date(),
        ],
        (err, res) => {
            if (err) {
                console.log('Error:', err);
                result(err, null);
            }
            else {
                console.log('Id de la nueva orden:', res.insertId);
                result(null, res.insertId);
            }
        }

    )

}


module.exports = Order;