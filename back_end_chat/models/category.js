const db = require('../config/config');

const Category = {};

Category.getAll = (id_person) => {
    const sql = `
    SELECT
        id,
        name,
        description
    FROM
        send_sms.categories
    WHERE 
        id_person = $1
    ORDER BY
        name
    `;
    return db.manyOrNone(sql,[id_person]);
}

Category.create = (category) => {

    const sql = `
    INSERT INTO
        send_sms.categories(
            name,
            description,
            id_person,
            created_at,
            updated_at   
        )
    VALUES($1, $2, $3, $4, $5) RETURNING id
    `;
    return db.oneOrNone(
        sql, 
        [
            category.name,
            category.description,
            category.id_person,
            new Date(),
            new Date(),
        ]
    );
}


module.exports = Category;