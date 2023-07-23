const db = require('../config/config');

const Product = {};

Product.findByCategory = (id_category, id_person) => {
  
    const sql = `
    SELECT
        P.id,
        P.name,
        P.description,
        P.price,
        P.image1,
        P.image2,
        CAST ( P.quantity_product AS INTEGER),
        P.id_category,
        P.id_person
    FROM
        send_sms.products as P
    WHERE 
        P.id_category = $1 and P.id_person = $2
    `;

    return db.manyOrNone(
        sql,
        [id_category,
        id_person
        ],
    );
}

Product.findByNameAndCategory = (name, id_category, result) => {
    const sql = `
    SELECT
        P.id,
        P.name,
        P.description,
        P.price,
        P.image1,
        P.image2,
        P.quantity_product,
        P.id_category,
        P.id_person
    FROM
        send_sms.products as P
    WHERE 
        P.id_category = $1 AND LOWER(P.name) LIKE $2
    `;

    return db.oneOrNone(
        sql,
        [
            id_category,
            `%${name.toLowerCase()}%`
        ],
    );
}

Product.create = (product) => {

    const sql = `
    INSERT INTO
        send_sms.products(
            name,
            description,
            price,
            image1,
            image2,
            quantity_product,
            id_category,
            id_person,
            created_at,
            updated_at   
        )
    VALUES($1, $2, $3, $4, $5,$6, $7, $8, $9, $10) RETURNING *
    `;

    return db.oneOrNone(
        sql,
        [
            product.name,
            product.description,
            product.price,
            product.image1,
            product.image2,
            product.quantity_product,
            product.id_category,
            product.id_person,
            new Date(),
            new Date(),
        ],
    );
}

Product.update = (product, result) => {

    const sql = `
    UPDATE
        send_sms.products
    SET
        name = $1,
        description = $2,
        price = $3,
        image1 = $4,
        image2 = $5,
        quantity_product = $6,
        id_category = $7,
        id_person = $8,
        updated_at = $9
    WHERE
        id = $10
    `;
    return db.oneOrNone(sql,
        [
            product.name,
            product.description,
            product.price,
            product.image1,
            product.image2,
            product.quantity_product,
            product.id_category,
            product.id_person,
            new Date(),
            product.id
        ],
    );
}


module.exports = Product;