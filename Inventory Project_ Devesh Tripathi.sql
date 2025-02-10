create database Inventory_Project
use Inventory_Project

--- --Creating Table 

create table Supplier ( SID char(5) constraint pk_supplier primary key, 
						SNAME varchar(50) not null, 
						SADD varchar(80) not null,
						SCITY varchar(15) default 'Delhi',
						SPHONE varchar(15) unique,
						Email varchar(100)
					   );

					   --drop table supplier;

create table Product (  PID char(5) constraint pk_product primary key,
						PDESC varchar(50) not null, 
						PRICE int check(Price>0), 
						CATEGORY char (2) check(Category in ('IT','HA','HC') ),
						SID char(5) constraint fk_supplier foreign key (SID) references supplier(SID) 
					);

					drop table product;

Create table Stock ( PID char(5) constraint fkproduct_stock foreign key(PID) references Product(PID) on delete cascade,
					 SQty int check(SQty>=0),
					 ROL int check(ROL>0),
					 MOQ int check(MOQ>=0)
				   );

				   --drop table stock;

create table Customer ( CID char(5) constraint pk_customer primary key ,
						CNAME varchar(50) not null,
						ADDRESS varchar(50) not null,
						CITY varchar(50) not null,
						PHONE char(15) not null,
						EMAIL varchar(100) not null,
						DOB date check(DOB>'2000-01-01')
					  );

					  --drop table customer;

create table Orders ( OID char(5) constraint pk_order primary key,
					 ODATE date,
					 CID char(5) constraint fkcustomer_stock foreign key(CID) references Customer(CID),
					 PID char(5) constraint fk_product foreign key(PID) references Product(PID),
					 OQty int check(OQty>=1)
					);

					--drop table orders;
------------------------------------------------------------------------------------------------------------------------

-- SEQUENCE

/* Creating sequence to gennerate number from 1 to 9999 */
create sequence supplier_seq
start with 1
increment by 1
maxvalue 9999

create sequence product_seq
start with 1
increment by 1
maxvalue 9999

create sequence customer_seq
start with 1
increment by 1
maxvalue 9999

create sequence orders_seq
start with 1
increment by 1
maxvalue 9999


--======================================================================================================================
-- UDF

/* Creating UDF to generate alphanum_id */

create function alphanum_id(@Chr char(1),@num int)
		returns char(5)
		as 
		begin
			declare @id char(5) --E0001

			if @num < 10
				set @id=concat(@chr,'000',@num)
			else if @num < 100
				set @id=concat(@chr,'00',@num)
			else if @num < 1000
				set @id=concat(@chr,'0',@num)
			else if @num < 10000
				set @id=concat(@chr,@num)
			else
				set @id='NA'

			return @id

		end;


--======================================================================================================================


--- Inserting values in supplier table.

create procedure supplier_insert( @sname varchar(50), @Addr varchar(50), @city varchar(50),@phone varchar(15), @email varchar(100))
as 
begin
	declare @id char(5)
	declare @num as int
	set @num = (next value for supplier_seq)
	set @id= dbo.alphanum_id('S',@num)

	insert into supplier values(@id, @sname, @Addr, @city, @phone, @email);
	select * from supplier where SID= @id ;
end

supplier_insert 'Avik Enterprise','Sector 15 New colony','Noida','8299661743','avik@gmail.com';
supplier_insert 'Sangam Pvt Ltd','Safdurganj','Delhi','4359661743','sangam@gmail.com';
supplier_insert 'Ramesh Pharmaceutical','Sector 62 ','Noida','5946661743','hpworld@gmail.com';
supplier_insert 'Chroma Store','Navi Mumbai','Mumbai','5888661743','chroma@gmail.com';
supplier_insert 'Reliance Digital','Sector 23 ','Gurgaon','8989666174','reliancedigital@gmail.com';


---------------------------------------------------------------------------------------------------------------------


--- Inserting values in product table.

create procedure product_insert( @pdesc varchar(50), @price int, @category char(2), @sid char(5))
as 
begin
	declare @id char(5)
	declare @num as int
	set @num = (next value for product_seq)
	set @id= dbo.alphanum_id('P',@num)

	insert into product values(@id, @pdesc, @price, @category, @sid);
	select * from product where PID= @id 
end;

product_insert 'HP Keyboard',569,'IT','S0004';
product_insert 'Dell Laptop',65000,'IT','S0004';
product_insert 'BP Machine',1500,'HC','S0003';
product_insert 'Samsung Washing Machine',569,'HA','S0005';
product_insert 'Phillips Mixer Grinder',2569,'HA','S0005';
product_insert 'JBL Speaker',9999,'IT','S0004';
product_insert 'MI TV',569,'HA','S0001';
product_insert 'Protein Powder',1120,'HC','S0003';
product_insert 'Asus Mouse',700,'IT','S0004';
product_insert 'HP Laptop',85000,'IT','S0004';
product_insert 'Oxymeter',2500,'HC','S0003';
product_insert 'Videocon Washing Machine',569,'HA','S0005';
product_insert 'Voltas AC',25969,'HA','S0005';
product_insert 'Sony Speaker',25999,'IT','S0004';
product_insert 'LG TV',569,'HA','S0001';
product_insert 'Protein Powder',6520,'HC','S0003';


----------------------------------------------------------------------------------------------------------------------


--- Inserting values in Stock table.

create procedure stock_insert( @PID char(5), @SQty int, @ROL int, @MOQ int)
as 
begin
	insert into stock values( @PID, @SQty, @ROL, @MOQ );
	select * from stock where PID= @PID ;
end


stock_insert 'P0001',200,6,2 ;
stock_insert 'P0006',20,3,1 ;
stock_insert 'P0008',50,4,1 ;
stock_insert 'P0010',100,8,1 ;
stock_insert 'P0015',40,1,3 ;
stock_insert 'P0002',200,6,2 ;
stock_insert 'P0004',30,3,1 ;
stock_insert 'P0009',50,4,1 ;
stock_insert 'P0011',100,8,1 ;
stock_insert 'P0014',40,1,3 ;


----------------------------------------------------------------------------------------------------------------------


--- Inserting values in Customer table.

create procedure customer_insert( @cname varchar(50),@addr varchar(50),@city varchar(50),@phone varchar(15),@email varchar(100))
as 
begin
	declare @id char(5)
	declare @num as int
	declare @date as date
	set @date= concat( year(getdate()) ,'-', month(getdate()) ,'-', day(getdate()) )
	set @num = (next value for customer_seq)
	set @id= dbo.alphanum_id('C',@num)

	insert into customer values(@id, @cname, @addr, @city, @phone, @email, @date);
	select * from customer where CID= @id ;
end

customer_insert 'RAMESH GUPTA','SECTOR 7 Rohini ','DELHI','9999002727','surya@gmail.com';
customer_insert 'Manoj Kumar','A32/620 Main Road','PUNE','8899001123','mKumar@gmail.com';
customer_insert 'Kapil Sharma','Jay Maa Apartments Flat 32 ','DEHRADUN','9999001099','kSharma@gmail.com';
customer_insert 'MONIKA ARORA','HNO-B205 ','NOIDA','9459002727','MA@GMAIL.COM';
customer_insert 'Saumya Singh','Sector 23','Gurgaon','9999002727','saumya@gmail.com';


----------------------------------------------------------------------------------------------------------------------


--- Inserting values in Orders table.

create procedure orders_insert( @cid char(5), @pid char(5), @OQty int)
as 
begin
	declare @id char(5)
	declare @num as int
	declare @date as date
	set @date= concat( year(getdate()) ,'-', month(getdate()) ,'-', day(getdate()) )
	set @num = (next value for orders_seq)
	set @id= dbo.alphanum_id('O',@num)

	insert into orders values(@id, @date, @cid, @pid, @OQty );
	select * from orders where OID= @id ;

end

drop procedure orders_insert;

		/* Updating stock_quantity after accepting each order in stock table using trigger */

		create trigger updating_SQty_trigger
			on orders
			for Insert
			as
			begin
				declare @stock_qty as int
				declare @order_qty as int
				set @stock_qty= (select Sqty from stock where pid=(select pid from inserted) )
				set @order_qty= (select OQty from inserted)

				if @stock_qty > @order_qty
					begin
						update stock set SQty= SQty-(select OQty from inserted /* order table*/)
							where  pid=(select pid from inserted)
						print('Order Accepted')
					end

				else
					begin
						rollback
						Print('Insufficient Stock ! ' )
					end
			end;

			drop trigger updating_SQty_trigger;


orders_insert 'C0001','P0001',10;
orders_insert 'C0002','P0008',5;
orders_insert 'C0003','P0010',25;
orders_insert 'C0001','P0009',7;
orders_insert 'C0005','P0011',40000;
orders_insert 'C0001','P0010',3;
delete orders

--======================================================================================================================

--- Display order Bill

CREATE PROCEDURE BILL @OID AS CHAR(5)
AS
BEGIN
	SELECT CUSTOMER.CID, CNAME, OID, ODATE , PRODUCT.PID, PDESC, PRICE, OQTY , PRICE * OQTY AS 'AMOUNT'
	FROM ORDERS
	INNER JOIN CUSTOMER
	ON ORDERS.CID = CUSTOMER.CID
	INNER JOIN PRODUCT
	ON ORDERS.PID = PRODUCT.PID
	WHERE OID = @OID;
END;

bill'O0002'
bill'O0003'



--- Display all order done by given customer

create procedure customer_orders @search_id char(5)
as
begin
	select customer.CID, Cname as [Customer Name],product.PID as [Product ID], Pdesc as [Product Name],
	               Price, orders.oid as [Order ID], ODate as [Order Date] 
	from orders
	inner join customer
	on customer.CID=orders.CID
	inner join product
	on orders.pid=product.pid
	where orders.cid=@search_id
end;
drop procedure customer_orders
customer_orders'C0001'



--- Displaying all product supplied by Supplier
create procedure supplier_products @sid as char(5)
as 
begin
	select supplier.sid [Supplier ID], Sname [Supplier Name], pid [Product ID], pdesc [Product Name], Category, Price
	from supplier
	inner join product
	on supplier.SID=product.SID
	where supplier.SID=@SID
end;

supplier_products'S0001'