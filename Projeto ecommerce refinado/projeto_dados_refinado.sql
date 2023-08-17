-- inserção de dados e queries
use ecommerce_refinado;

-- idClient, Fname, Minit, Lname, DocumentType, DocumentNumber, Address
insert into clients (Fname, Minit, Lname, DocumentType, DocumentNumber, Adress)
				values ('Joao', 'S', 'Lima', 'CPF', 12345678912, 'rua um 1, centro - Cidade alta'),
						('Maria', 'P', 'Souza', 'CPF', 12345678913, 'rua dois 9, centro-Cidade alta'),
                        ('Lucas', 'M', 'Silva', 'CNPJ', 123456789123456, 'av tres 5, centro-Cidade baixa');
 
-- idProduct, Pname, classification_kids, category('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis'), avaliação, size
insert into product (Pname, classification_kids, category, avaliação, size)
				values ('Fone',false,'Eletrônico','4',null),
						('Barbie',true,'Brinquedos','3',null),
						('Camiseta',true,'Vestimenta','5',null),
						('Microfone',false,'Eletrônico','4',null),
						('Sofá',false,'Móveis','3','3x57x80'),
						('Farinha',false,'Alimentos','2',null),
						('Fire Stick',false,'Eletrônico','3',null);
                        
-- idPayment, typePayment('Pix', 'Debito', 'Boleto','Cartão')
insert into payments (typePayment)
				values ('Pix'),
						('Debito'),
                        ('Boleto'),
                        ('Cartão');

-- idOrder, idOrderClient, idOrderPayment, orderStatus('Cancelado','Confirmado','Processando'), orderDescription, orderValue, numberPayment
insert into orders (idOrderClient, idOrderPayment, orderStatus, orderDescription, orderValue, numberPayment) 
							values (1, 1, default,'compra via aplicativo',null,12345),
                                    (2, 2, default,'compra via aplicativo',50,12346),
                                    (3, 3, 'Confirmado',null,null,12347),
                                    (1, 4, 'Confirmado','compra via web',30,12348),
                                    (1, 2, default,'compra via web',25,12349),
                                    (3, 4, 'Confirmado','compra via aplicativo',250,12351);

-- idDelivery, idDOrder, idDClient, codeDelivery, statusDelivery ('Em separação', 'Em transporte', 'Saiu para entrega', 'Entregue'), valueDelivery
insert into delivery (idDOrder, idDClient, codeDelivery, statusDelivery, valueDelivery)
				values (1, 1, 'abc123', 'Em separação', 30),
						(2, 2, 'abd124', 'Em transporte', 30),
                        (3, 3, 'abe125', 'Saiu para entrega', 30);
                                    
-- idPOproduct, idPOorder, poQuantity, poStatus('Disponível','Sem estoque')
insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus) 
					values (1,1,2,default),
                            (2,1,1,'Sem estoque'),
                            (3,2,1,default),
                            (4,2,2,'Sem estoque');
                            
-- idProdStorage, storageLocation, quantity
insert into productStorage (storageLocation,quantity) values
							('Rio de Janeiro',1000),
                            ('Rio de Janeiro',500),
                            ('São Paulo',10),
                            ('São Paulo',100),
                            ('São Paulo',10),
                            ('Brasília',60);
                            
-- idLproduct, idLstorage, location
insert into storageLocation (idLproduct, idLstorage, location) values
							(1,2,'RJ'),
                            (2,6,'GO');
                            
-- idSupplier, SocialName, CNPJ, contact
insert into supplier (SocialName, CNPJ, contact) values
					('Almeida e filhos', 123456789123456, '21985474'),
                    ('Eletrônicos Silva', 854519649143457, '21985484'),
                    ('Eletrônicos Valma', 934567893934695, '21975474'),
                    ('Kids World', 456789123654485, '1198657484')
                    
-- idPsSupplier, idPsProduct, quantity
insert into productSupplier (idPsSupplier, idPsProduct, quantity) values
							(1,1,500),
                            (1,2,400),
                            (2,4,633),
                            (3,3,5),
                            (2,5,10);
                            
-- idSeller, SocialName, AbstName, CNPJ, CPF, location, contact
insert into seller (SocialName, AbstName, CNPJ, CPF, location, contact) values
					('Tech eletronics', null, 123456789456321, null, 'Rio de Janeiro', 219946287),
                    ('Botique Durgas', null, null, 123456783, 'Rio de Janeiro', 219567895),
                    ('Kids World', null, 456789123654485, null, 'São Paulo', 1198657484);
    
-- idPseller, idPproduct, prodQunatity
insert into productSeller (idPseller, idPproduct, prodQuantity) values
							(1,6,80),
                            (2,7,10);

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 1 Quantos pedidos foram feitos por cada cliente?
select concat(c.Fname, ' ',c.Lname) as Cliente, count(*) as qtd_de_pedidos 
from clients c join orders o on c.idClient = o.idOrderClient
group by c.idClient; 

-- 2 Algum vendedor também é fornecedor?
select u.SocialName as Fornecedor, e.SocialName as Vendedor, e.location as Localização, e.CNPJ as CNPJ
from supplier u join seller e on u.CNPJ = e.CNPJ
order by u.cnpj;

-- 3 Relação de produtos, fornecedores e estoques?
select s.SocialName as Razão_Social, s.CNPJ as CNPJ, s.contact as contato,
su.quantity as quantidade, p.Pname as Produto, p.classification_kids as Classificação, p.category as categoria, p.avaliação as avaliação, p.size as tamanho,
sl.location as Localização, ps.storageLocation as Local_Estoque
from supplier s join productSupplier su on s.idSupplier = su.idPsSupplier 
join product p on su.idPsProduct = p.idProduct
join storageLocation sl on p.idProduct = sl.idLproduct
join productStorage ps on sl.idLproduct = ps.idProdStorage;

-- 4 Relação de nomes dos fornecedores e nomes dos produtos?
select s.SocialName as Razão_Social, s.CNPJ as CNPJ, s.contact as contato,
su.quantity as quantidade, p.Pname as Produto, p.classification_kids as Classificação, p.category as categoria, p.avaliação as avaliação, p.size as tamanho
from supplier s join productSupplier su on s.idSupplier = su.idPsSupplier 
join product p on su.idPsProduct = p.idProduct;

-- 5 Quais são os Vendedores que venderam uma quantidade maior que 3 da categoria eletronico ?
select s.SocialName as Razão_Social, s.AbstName as Nome, s.location as localização,
ps.prodQuantity as quantidade, 
p.Pname as Produto, p.classification_kids as Classificação, p.category as categoria, p.avaliação as avaliação, p.size as tamanho
from seller s join productSeller ps on s.idSeller = ps.idPseller
join product p on ps.idPproduct = p.idProduct
where categoria = 'Eletrônico'
having quantidade > 3
order by quantidade;

-- 6 Quais sao os produtos comprados por aplicativo e quais sao as suas quantidades ?
select p.Pname as Produto, p.category as categoria,
po.poQuantity as Quantidade, po.poStatus as Status_produto,
o.orderDescription as Descrição_metodo_compra, o.orderValue as Valor
from product p join productOrder po on p.idProduct = po.idPOproduct
join orders o on po.idPOorder = o.idOrder
where o.orderDescription = 'compra via aplicativo'
order by Quantidade;

-- 7 Qual o cliente que mais gastou, em quais produtos, e quais foram os metodos de pagamento ?
select concat(c.Fname, ' ', c.Lname) as Cliente, 
o.orderValue as Valor,
p.typePayment as Metodo_Pagamento,
pr.Pname as Produto,
po.poQuantity as Quantidade
from clients c inner join orders o on c.idClient = o.idOrderClient
inner join payments p on o.idOrderPayment = p.idPayment
inner join productOrder po on po.idPOorder = o.idOrder
inner join product pr on po.idPOproduct = pr.idProduct
where o.orderValue is not null;
