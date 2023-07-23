const db = require('../config/config');
const Message = {};

Message.findbyChat = (id_chat) => {
    const sql = ` 
        SELECT
            id,
            message,
            id_sender,
            id_receiver,
            id_chat,
            timestamp,
            is_image,
            is_video,
            url,
            status
        FROM
            send_sms.messages
        WHERE
            id_chat = $1
        ORDER BY
            timestamp DESC
    `;
    return db.manyOrNone(sql, id_chat);



}

Message.create = (messages) => {
    const sql = `
    INSERT INTO 
        send_sms.messages(
            message,
            id_sender,
            id_receiver,
            id_chat,
            status,
            url,
            is_image,
            is_video,
            timestamp,
            created_at,
            updated_at
        )
    VALUES($1 ,$2 ,$3 ,$4 ,$5,$6 ,$7 ,$8 ,$9 ,$10,$11 ) RETURNING id
`;
    return db.oneOrNone(sql, [
        messages.message,
        messages.id_sender,
        messages.id_receiver,
        messages.id_chat,
        'ENVIADO',
        messages.url,
        messages.is_image,
        messages.is_video,
        new Date().getTime(),
        new Date(),
        new Date()
    ]);
}

Message.updateToSeen = (id) => {
    const sql = `
    UPDATE
        send_sms.messages
    SET
        status = 'VISTO',
        updated_at = $2
    WHERE
        id = $1 

`;
    return db.oneOrNone(sql, [id,
        new Date()
    ]);
}
Message.updateToReceived = (id) => {
    const sql = `
    UPDATE
        send_sms.messages
    SET
        status = 'RECIBIDO',
        updated_at = $2
    WHERE
        id = $1 

`;
    return db.oneOrNone(sql, [id,
        new Date()
    ]);
}
module.exports = Message;