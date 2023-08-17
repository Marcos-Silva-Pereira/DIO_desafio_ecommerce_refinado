-- criação do banco de dados para o cenário de e-commerce
create database ecommerce_refinado;
use ecommerce_refinado;

-- criar tabela cliente
create table clients(
	idClient int auto_increment primary key,
    Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    DocumentType enum ('CPF','CNPJ') not null default 'CPF',
    DocumentNumber varchar(15) not null,
    Adress varchar(30),
    constraint unique_document_client unique (DocumentNumber)    
);

-- criar tabela produto
create table product(
	idProduct int auto_increment primary key,
    Pname varchar(10) not null,
    Classification_kids bool default false,
    category enum('Eletronico','Vestimenta','Brinquedos','Alimentos','Móveis') not null,
    avaliação float default 0,
    size varchar(10)  
);

-- criar tabela pagamentos
create table payments(
    idPayment int auto_increment primary key,
    typePayment enum('Pix', 'Debito', 'Boleto','Cartão') not null default 'Cartão',
    constraint unique_payment_typePayment unique (typePayment)
);

-- criar tabela pedido
create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    idOrderPayment int,
    orderStatus enum('Cancelado','Confirmado','Processando') default 'Processando',
    orderDescription varchar(255),
    orderValue float default 10,
    numberPayment varchar(25) not null,
    constraint fk_orders_client foreign key (idOrderClient) references clients(idClient),
    constraint fk_orders_payment foreign key (idOrderPayment) references payments(idPayment)
);

-- criar tabela entrega
create table delivery(
	idDelivery int auto_increment primary key,
	idDOrder int,
    idDClient int,
    codeDelivery varchar(20) not null,
    statusDelivery enum('Em separação', 'Em transporte', 'Saiu para entrega', 'Entregue') default 'Em separação',
    valueDelivery float default 0,
    constraint unique_codeDelivery_delivery unique (codeDelivery),
    constraint fk_delivery_orders foreign key (idDOrder) references orders(idOrder),
    constraint fk_delivery_clients foreign key (idDClient) references clients(idClient)
);

-- criar tabela estoque
create table productStorage(
	idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);

-- criar tabela fornecedor
create table supplier(
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);

-- criar tabela vendedor
create table seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15),
    CPF char(9),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
);

-- criar tabela Produtos_vendedor
create table productSeller(
	idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);

-- criar tabela Produto/pedido
create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível','Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_seller foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_product foreign key (idPOorder) references orders(idOrder)
);

-- criar tabela Produto_em_Estoque (localização)
create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);

-- criar tabela Produto_fornecedor
create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_productSupplier foreign key (idPsProduct) references product(idProduct)
);
