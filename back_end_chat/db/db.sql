/* new schema, send_sms */
CREATE TABLE send_sms.users(
	id BIGSERIAL PRIMARY KEY,
	email VARCHAR(255) NOT NULL UNIQUE,
	name VARCHAR(255) NOT NULL,
	lastname VARCHAR(255) NOT NULL,
	phone VARCHAR(20) NULL,
	image VARCHAR(255)  NULL,
	password VARCHAR(255) NOT NULL,
	notification_token VARCHAR(255)  NULL,
	is_available BOOLEAN NULL,
	session_token VARCHAR(255) NULL,
	created_at TIMESTAMP(0) NOT NULL,
	updated_at TIMESTAMP(0) NOT NULL
);

CREATE TABLE send_sms.chats(
	id BIGSERIAL PRIMARY KEY,
	id_user1 BIGINT NOT NULL,
	id_user2 BIGINT NOT NULL,
	timestamp BIGINT NOT NULL,
	created_at TIMESTAMP(0) NOT NULL,
	updated_at TIMESTAMP(0) NOT NULL,
	FOREIGN KEY (id_user1) REFERENCES send_sms.users(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (id_user2) REFERENCES send_sms.users(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE send_sms.messages(
	id BIGSERIAL PRIMARY KEY,
	message TEXT NOT NULL,
	url VARCHAR(255) NULL,
	is_image BOOLEAN DEFAULT FALSE,
	is_video BOOLEAN DEFAULT FALSE,
	id_sender BIGINT NOT NULL,
	id_receiver  BIGINT NOT NULL,
	id_chat  BIGINT NOT NULL,
	status VARCHAR(80) NOT NULL,
	timestamp BIGINT NOT NULL,
	created_at TIMESTAMP(0) NOT NULL,
	updated_at TIMESTAMP(0) NOT NULL,
	FOREIGN KEY (id_sender) REFERENCES send_sms.users(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (id_receiver) REFERENCES send_sms.users(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (id_chat) REFERENCES send_sms.chats(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE send_sms.roles(
	id BIGSERIAL PRIMARY KEY,
    name VARCHAR(90) NOT NULL UNIQUE,
    image VARCHAR(255) NULL,
    route VARCHAR(180) NOT NULL,
    created_at TIMESTAMP(0) NOT NULL,
    updated_at TIMESTAMP(0) NOT NULL
);



INSERT INTO send_sms.roles(
	name,
    route,
    created_at,
    updated_at
)
VALUES(
	'TIENDA',
    '/tienda/orders/list',
    '2023-05-10',
    '2023-05-10'
);

INSERT INTO send_sms.roles(
	name,
    route,
    created_at,
    updated_at
)
VALUES(
	'CLIENTE',
    '/client',
    '2023-05-10',
    '2023-05-10'
);

CREATE TABLE send_sms.user_has_roles(
	id_user BIGINT NOT NULL,
    id_rol BIGINT NOT NULL,
    created_at TIMESTAMP(0) NOT NULL,
    updated_at TIMESTAMP(0) NOT NULL,
    FOREIGN KEY(id_user) REFERENCES send_sms.users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(id_rol) REFERENCES send_sms.roles(id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY(id_user, id_rol)
);


CREATE TABLE send_sms.categories(
	id BIGSERIAL PRIMARY KEY ,
    name VARCHAR(180) NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP(0) NOT NULL,
    updated_at TIMESTAMP(0) NOT NULL
);

CREATE TABLE send_sms.products(
	id BIGSERIAL PRIMARY KEY,
    name VARCHAR(180) NOT NULL UNIQUE,
    description TEXT NOT NULL,
    price DOUBLE PRECISION NOT NULL,
    image1 VARCHAR(255) NULL,
    image2 VARCHAR(255) NULL,
    quantity_product BIGINT NOT NULL,
    id_category BIGINT NOT NULL,
    id_person BIGINT NOT NULL,
    created_at TIMESTAMP(0) NOT NULL,
    updated_at TIMESTAMP(0) NOT NULL,
    FOREIGN KEY(id_category) REFERENCES send_sms.categories(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(id_person) REFERENCES send_sms.users(id) ON UPDATE CASCADE ON DELETE CASCADE
);



CREATE TABLE send_sms.orders(
	id BIGSERIAL PRIMARY KEY,
    id_user BIGINT NOT NULL,
    name_client VARCHAR(255) NOT NULL,
    telefono_client VARCHAR(255) NOT NULL,
    status VARCHAR(90) NOT NULL,
    timestamp BIGINT NOT NULL,
    created_at TIMESTAMP(0) NOT NULL,
    updated_at TIMESTAMP(0) NOT NULL,
    FOREIGN KEY(id_user) REFERENCES send_sms.users(id) ON UPDATE CASCADE ON DELETE CASCADE
); 

CREATE TABLE send_sms.order_has_products(
	id_order BIGINT NOT NULL,
    id_product BIGINT NOT NULL,
    quantity BIGINT NOT NULL,
    created_at TIMESTAMP(0) NOT NULL,
    updated_at TIMESTAMP(0) NOT NULL,
    PRIMARY KEY(id_order, id_product),
    FOREIGN KEY(id_order) REFERENCES send_sms.orders(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(id_product) REFERENCES send_sms.products(id) ON UPDATE CASCADE ON DELETE CASCADE
);