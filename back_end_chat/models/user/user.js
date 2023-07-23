const db = require('../../config/config');
const bcrypt = require('bcryptjs');
const User = {};


User.getAll = (id) => {
    const sql = `
    SELECT 
        id,
        email,
        name,
        lastname,
        img_portada,
        phone,
        image,
        session_token,
        notification_token
    FROM
        send_sms.users
    WHERE
        id != $1
    ORDER BY random() LIMIT 10;
    `;
    return db.manyOrNone(sql,id);
}
User.getAllPerson = (id, nombre) => {
    const sql = `
    SELECT 
        id,
        email,
        name,
        lastname,
        phone,
        img_portada,
        image,
        session_token,
        notification_token
    FROM
        send_sms.users
    wHERE
        id != $1 AND LOWER(name) LIKE $2
    `;
    return db.manyOrNone(sql,[id,`%${nombre.toLowerCase()}%`]);
}
User.findByEmail = (email, callback) => {
    const sql = `
    SELECT 
        id,
        email,
        name,
        lastname,
        image,
        phone,
        img_portada,
        password,
        session_token
    FROM
        send_sms.users
    WHERE
        email = $1
    `;
    return db.oneOrNone(sql, email);
}

User.findById = (id, callback) => {
    const sql = `
    SELECT 
        id,
        email,
        name,
        lastname,
        image,
        phone,
        img_portada,
        password,
        session_token
    FROM
        send_sms.users
    WHERE
        id = $1
    `;
    return db.oneOrNone(sql, id).then(user => { callback(null, user) });
}

User.create = async (user) => {
    const hast = await bcrypt.hash(user.password, 10);
    const sql = `
    INSERT INTO
        send_sms.users(
            email,
	        name,
	        lastname,
	        phone,
	        image,
	        password,
	        created_at,
	        updated_at
        )
    VALUES($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id
    `;
    return db.oneOrNone(sql, [
        user.email,
        user.name,
        user.lastname,
        user.phone,
        user.image,
        hast,
        new Date(),
        new Date()
    ]);
}
User.update = async (user) => {
    const sql = `
    UPDATE
        send_sms.users
    SET
        name = $2,
        lastname = $3,
        phone = $4,
        image = $5,
        img_portada = $6,
        updated_at = $7
    WHERE
        id = $1
    RETURNING *
    `;
    return db.oneOrNone(sql, [
        user.id,
        user.name,
        user.lastname,
        user.phone,
        user.image,
        user.img_portada,
        new Date()
    ]);
}
User.updateNotificationToken = async (id_user,token) => {
    const sql = `
    UPDATE
        send_sms.users
    SET
        notification_token = $2
    WHERE
        id = $1
    `;
    return db.none(sql, [id_user,token
    ]);
}
User.checkIfIsOnline = (id_user) => {
    const sql = `
        SELECT
            online,
            id_socket
        FROM 
            send_sms.users
        WHERE 
            id = $1
    `;

    return db.oneOrNone(sql, id_user);
}
User.updateOnlineByUser = (id_user, online) => {
    const sql = `
        UPDATE
            send_sms.users
        SET
            online = $2
        WHERE
            id = $1
    `;

    return db.none(sql, [
        id_user,
        online
    ]);
}

User.updateOnlineBySocket = (id_socket, online) => {
    const sql = `
        UPDATE
            send_sms.users
        SET
            online = $2
        WHERE
            id_socket = $1
    `;

    return db.none(sql, [
        id_socket,
        online
    ]);
}


User.updateIdSocket = (id_user, id_socket) => {
    const sql = `
        UPDATE
            send_sms.users
        SET
            id_socket = $2
        WHERE
            id = $1
    `;

    return db.none(sql, [
        id_user,
        id_socket
    ]);
}
module.exports = User;