Searching about PostgresSQL
==============================================

1.
CREATE DATABASE sysperson
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE sysperson
    IS 'myDB for researching';

2.
-- Database: sysperson

-- DROP DATABASE sysperson;

CREATE DATABASE sysperson
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE sysperson
    IS 'myBD for researching';

---------------------------------------------------------------------------
ALTER DATABASE <old_database> RENAME TO <new_database>;

---------------------------------------------------------------------------
DROP DATABASE mydb;

Dữ liệu kiểu chuỗi (Character Data Types)

Kiểu dữ liệu						Miêu tả
character varying(n), varchar(n) 	=> Độ dài (variable-length) thay đổi có giới hạn
character(n), char(n) 				=> Độ dài (fixed-length) cố định, thiếu ký tự thì sẽ đệm bằng ký tự trống (blank)
text 								=> Độ dài (variable-lenth) thay đổi không có giới hạn
---------------------------------------------------------------------------

CREATE TABLE public.groups
(
    group_id integer NOT NULL,
    group_name character varying COLLATE pg_catalog."default" NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    CONSTRAINT groups_pkey PRIMARY KEY (group_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;
ALTER TABLE public.groups OWNER to postgres;
---------------------------------------------------------------------------
create table customer(	id int4 NOT NULL primary key,	name varchar(50),	address varchar(50)) with(oids=false);

insert into customer(id, name, address) values(1, 'thuongtx', 'HCM-VN');

---------------------------------------------------------------------------
Sử dụng Array trong Postgres để thay thế cho bảng trung gian
1. Users
id - serial - Primary Key
username - character varying[255]
email - character varying[255]
jobs - integer[] << Array

2. Jobs
id - serial - Primary Key
name - character varying[255]
description - character varying[255]

Query:

SELECT users.* , array_to_json(array_agg(jobs.*)) as detail_jobs FROM users
LEFT JOIN jobs ON jobs.id = ANY(users.jobs)
GROUP BY users.id;

OR

SELECT users.* , array_to_json(array_agg(jobs.*)) as detail_jobs FROM users
LEFT JOIN jobs ON jobs.id IN (SELECT unnest(users.jobs))
GROUP BY users.id;


=> Ta có thể chọn định danh tên côt để có 1 mảng trả về ví dụ :
SELECT users.* , array_to_json(array_agg(jobs.name)) as detail_jobs FROM users
LEFT JOIN jobs ON jobs.id = ANY(users.jobs)
GROUP BY users.id;

---------------------------------------------------------------------------

Đổi tên bảng từ groups => new_groups

ALTER TABLE public.groups RENAME TO new_groups;
---------------------------------------------------------------------------

Thêm column có tên là “description” với kiểu dữ liệu là “text”

ALTER TABLE public.groups ADD COLUMN description text;

---------------------------------------------------------------------------
Xóa column của Table:

ALTER TABLE table_name DROP COLUMN column_name;

---------------------------------------------------------------------------

Thay đổi tên của Table

ALTER TABLE name RENAME TO new_name

---------------------------------------------------------------------------

Thay đổi schema của Table

ALTER TABLE name SET SCHEMA new_schema

---------------------------------------------------------------------------
Trong PostgreSQL, khi tạo bảng CSDL chúng ta sử dụng SERIAL để định nghĩa 1 auto-increment column – column có ID (integer) tự động tăng.

Khi column được định nghĩa là SERIAL, PostgreSQL sẽ tạo ra 1 column với kiểu dữ liệu Integer và tạo ra 1 sequence cho column đó. Sequece là 1 đối tượng dữ liệu của kiểu dữ liệu Integer tự động tăng trong PostgreSQL.

Các loại SERIAL Datatype trong PostgreSQL
Name		Storage 	Size	Range
SMALLSERIAL	2 bytes		1 	to 	32,767
SERIAL		4 bytes		1 	to 	2,147,483,647
BIGSERIAL	8 bytes		1 	to 	9,223,372,036,854,775,807

Tạo Auto-Increment Column sử dụng SERIAL
Cú pháp lệnh: 

CREATE TABLE table_name(
    id SERIAL
);

Ví dụ: Tạo bảng groups với trường group_id là auto-increment column

CREATE TABLE groups
(
    group_id SERIAL,
    group_name character varying COLLATE pg_catalog."default" NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    CONSTRAINT groups_pkey PRIMARY KEY (group_id)
)
Kết quả:

insert into customer(name, address)
values('thuongtx', 'HCM-VN');
insert into customer(name, address)
values('tung', 'DN-VN');
insert into customer(name, address)
values('smith', 'HN-VN');

---------------------------------------------------------------------------

1. Tạo Sequence (CREATE SEQUENCE)
Cú pháp lệnh: 

CREATE [ TEMPORARY | TEMP ] SEQUENCE [ IF NOT EXISTS ] <sequence_name>
[ AS <data_type> ]
[ INCREMENT [ BY ] <increment >]
[ MINVALUE <minvalue> | NO MINVALUE ] [ MAXVALUE <maxvalue> | NO MAXVALUE ]
[ START [ WITH ] start ] [ CACHE cache ] [ [ NO ] CYCLE ]
[ OWNED BY { table_name.column_name | NONE } ]

Với:
<sequence_name>: Tên của sequence
<data_type>: Chỉ ra kiểu dữ liệu của sequence (smallint, integer, và bigint), mặc định là bigint
<increment >: Giá trị bổ sung vào chuỗi, giá trị có thể là 1 số dương (2) hoặc 1 số âm (-1), mặc định là 1
<minvalue>: Xác định giá trị tối thiểu một chuỗi có thể tạo ra. Nếu set giá trị hoặc NO MINVALUE được chỉ định, thì giá trị mặc định sẽ được sử dụng. Giá trị mặc định cho một chuỗi tăng dần là 1. Giá trị mặc định cho một chuỗi giảm dần là giá trị tối thiểu của kiểu dữ liệu.
<maxvalue>: Xác định giá trị tối đa một chuỗi có thể tạo ra. Nếu set giá trị hoặc NO MAXVALUE được chỉ định, thì giá trị mặc định sẽ được sử dụng. Giá trị mặc định cho một chuỗi tăng dần là giá trị tối đa của kiểu dữ liệu. Giá trị mặc định cho một chuỗi giảm dần là -1.
<start>: Giá trị bắt đầu của chuỗi. Giá trị mặc định là bắt đầu là <minvalue> cho chuỗi tăng dần và  <maxvalue> cho chuỗi giảm dần.

2. Ví dụ: Tạo một chuỗi sequence tăng dần có tên là vinasupport_sequence

CREATE SEQUENCE vinasupport_sequence
INCREMENT 1
START 100;

3. Để kiểm tra giá trị kế tiếp của 1 sequence trên chúng ta dùng câu SQL sau:

SELECT nextval('vinasupport_sequence');

4. Liệt kê danh sách Sequence

SELECT
    c.relname sequence_name
FROM 
    pg_class 
WHERE 
    relkind = 'S';


5. Xóa Sequence (DROP SEQUENCE)
Cú pháp lệnh: 

DROP SEQUENCE [ IF EXISTS ] <squence_name> [, …] [ CASCADE | RESTRICT ]

Với:

<squence_name>: Tên của sequence
Ví dụ: Xóa sequence “vinasupport_sequence”

DROP SEQUENCE vinasupport_sequence

---------------------------------------------------------------------------

1. Định nghĩa khóa chính khi tạo bảng
Khi tạo 1 bảng CSDL trong PostgreSQL chúng ta sử dụng keywork là PRIMARY KEY để tạo khóa chính

CREATE TABLE public.groups
(
    group_id integer NOT NULL PRIMARY KEY,
    group_name character varying COLLATE pg_catalog."default" NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
)
Hoặc tạo 1 CONSTRAINT như sau:

CREATE TABLE public.groups
(
    group_id integer NOT NULL,
    group_name character varying COLLATE pg_catalog."default" NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    CONSTRAINT groups_pkey PRIMARY KEY (group_id)
)

2. Thêm khóa chính cho 1 bảng CSDL
Để thêm 1 khóa chính vào 1 bảng đã tồn tại chúng là sử dụng lệnh SQL: ALTER TABLE với ADD PRIMARY KEY

ALTER TABLE table_name ADD PRIMARY KEY (column_1, column_2);

Ví dụ: Tạo bảng products và thêm 2 khóa chỉnh product_no_1, product_no_2

CREATE TABLE products (
   product_no_1 INTEGER,
   product_no_2 INTEGER,
   description TEXT
);
ALTER TABLE public.products ADD PRIMARY KEY (product_no_1, product_no_2);

3. Xóa khóa chính của bảng CSDL
Để xóa khóa chính của 1 bảng chúng ta sử dụng lệnh SQL: ALTER TABLE với DROP CONSTRAINT

ALTER TABLE table_name DROP CONSTRAINT primary_key_constraint;

Ví dụ: Xóa khóa chính của bảng products có rằng buộc constraint tên là: products_pkey
ALTER TABLE public.products DROP CONSTRAINT products_pkey;

---------------------------------------------------------------------------
Khóa ngoại
1. ví dụ

CREATE TABLE public.users
(
    user_id integer NOT NULL,
    group_id integer REFERENCES groups(group_id),
    username character varying COLLATE pg_catalog."default" NOT NULL,
    password character varying COLLATE pg_catalog."default" NOT NULL,
    email character varying COLLATE pg_catalog."default",
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
)
Chú ý: Bảng groups cần phải tạo trước.

Ngoài ra có thể sử dụng keyword: FOREIGN KEY

CREATE TABLE public.users
(
    user_id integer NOT NULL,
    group_id integer NOT NULL,
    username character varying COLLATE pg_catalog."default" NOT NULL,
    password character varying COLLATE pg_catalog."default" NOT NULL,
    email character varying COLLATE pg_catalog."default",
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    FOREIGN KEY (group_id) REFERENCES groups(group_id)
)

2. Định nghĩa khóa ngoại cho một tập hợp các column
Trong trường hợp khóa ngoại là một nhóm cột, chúng ta định nghĩa khóa ngoại như sau:

CREATE TABLE child_table(
child_column_1 INTEGER PRIMARY KEY,
child_column_2 INTEGER,
child_column_3 INTEGER,
FOREIGN KEY (child_column_2 , child_column_3 ) REFERENCES parent_table (parent_column_1, parent_column_2)
);

3. Thêm khóa ngoại vào bảng
Để thêm một ràng buộc khóa ngoại vào bảng hiện có, bạn sử dụng câu lệnh ALTER TABLE như sau:

ALTER TABLE child_table
ADD CONSTRAINT constraint_name FOREIGN KEY (child_column_1) REFERENCES parent_table (parent_column_1)

---------------------------------------------------------------------------

Ràng buộc Kiểm Tra (CHECK Constraint)

1. Cú pháp lệnh: 

CREATE TABLE <table_name> (
<column_name> <data_type> CHECK (<check_condition>)
);

2. Hoặc chỉ định 1 tên cho rằng buộc kiếm tra

CREATE TABLE <table_name> (
<column_name> <data_type> CONSTRAINT <constraint_name> CHECK (<check_condition>)
);

Ví dụ: Tạo bảng employees có trường Salary có rằng buộc kiểm tra là salary > 0

CREATE TABLE employees (
   employee_id serial PRIMARY KEY,
   fullname character varying,
   salary numeric CHECK(salary > 0)
);

4. Định nghĩa rằng buộc kiểm tra khi cho bảng CSDL đã tồn tại
Chúng ta sử dụng lệnh SQL: ALTER TABLE với action ADD CONSTRAINT

Cú pháp lệnh:

ALTER TABLE <table_name> ADD CONSTRAINT <constraint_name> CHECK (
<check_condition>
);

5. Sử dụng lệnh SQL để thêm rằng buộc check cho bảng này

ALTER TABLE product ADD CONSTRAINT qty_price_check CHECK (
   qty > 0
   AND price > 100000
);
---------------------------------------------------------------------------
Rằng buộc duy nhất (UNIQUE Constraint)

1. Định nghĩa rằng buộc sử dụng cho 1 cột
Cú pháp lệnh: 

CREATE TABLE <table_name> (
<column_name> <data_type> UNIQUE
);
Ví dụ: Tạo bảng username có cột username có rằng buộc duy nhất Unique

CREATE TABLE users
(
    user_id serial NOT NULL PRIMARY KEY,
    username character varying UNIQUE,
    password character varying,
    email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);

2. Định nghĩa rằng buộc sử dụng cho 1 nhóm các cột
Cú pháp lệnh:

CREATE TABLE <table_name> (
<column_name_1> <data_type>
<column_name_2> <data_type>
UNIQUE(column_name_1, column_name_2)
);
Khi đó giá trị của 2 column_name_1 và column_name_2 sẽ là duy nhất khi dữ liệu của chúng cùng duy nhất.
---------------------------------------------------------------------------

Cú pháp lệnh của SELECT
[ WITH [ RECURSIVE ] with_query [, ...] ]
SELECT [ ALL | DISTINCT [ ON ( expression [, ...] ) ] ]
[ * | expression [ [ AS ] output_name ] [, ...] ]
[ FROM from_item [, ...] ]
[ WHERE condition ]
[ GROUP BY grouping_element [, ...] ]
[ HAVING condition [, ...] ]
[ WINDOW window_name AS ( window_definition ) [, ...] ]
[ { UNION | INTERSECT | EXCEPT } [ ALL | DISTINCT ] select ]
[ ORDER BY expression [ ASC | DESC | USING operator ] [ NULLS { FIRST | LAST } ] [, ...] ]
[ LIMIT { count | ALL } ]
[ OFFSET start [ ROW | ROWS ] ]
[ FETCH { FIRST | NEXT } [ count ] { ROW | ROWS } ONLY ]
[ FOR { UPDATE | NO KEY UPDATE | SHARE | KEY SHARE } [ OF table_name [, ...] ] [ NOWAIT | SKIP LOCKED ] [...] ]

---------------------------------------------------------------------------

1. Thêm 1 dòng (row) vào bảng
Cú pháp: 

INSERT INTO table(column_name_1, column_name_2, …) VALUES (value_1, value_2, …);

2. Lấy id của bản ghi vừa insert vào bảng
Sử dụng từ khóa RETURNING để lấy id của bản ghi vừa được thêm vào bảng

INSERT INTO groups (group_name, created_at) VALUES ('partner', '2019-09-30 04:00:00')
RETURNING group_id;

---------------------------------------------------------------------------

1. Update dữ liệu của 1 hoặc nhiều dòng (row) trong bảng
Khi thực hiện cập nhật dữ liệu của 1 hoặc nhiều dòng trong 1 bảng, chúng ta nên sử dụng kèm mệnh đề điều kiện WHERE

Ví dụ: bảng groups có dữ liệu như sau: ...
Giờ sửa group_name của bản ghi có group_id = 2 từ “admin” => “other”

UPDATE groups SET group_name = 'other' WHERE group_id = 2;

2. Update dữ liệu của toàn bộ dòng (row) trong bảng
Nếu muốn update toàn bộ dữ liệu trong bảng thì chúng ta không cần sử dụng mệnh đề điều kiện WHERE

Ví dụ: Cập nhật cột (column) của bảng groups là ngày tháng hiện tại

UPDATE groups SET updated_at = current_timestamp;

---------------------------------------------------------------------------

1. Xóa dữ liệu trong bảng với sử dụng DELETE
Ví dụ ta có bảng groups với dữ liệu hiện tại như sau: ...

Giờ chúng ta xóa bản ghi có group_id = 7 bằng câu lệnh SQL DELETE như sau:

DELETE FROM groups WHERE group_id = 7;

2. Xóa toàn bộ dữ liệu của 1 bảng
Để xóa toàn bộ dữ liệu của 1 bảng hãy loại bỏ mệnh đề điều kiện WHERE trong câu sql

Ví dụ xóa toàn bộ dữ liệu của bảng groups ở trên
DELETE FROM groups;

---------------------------------------------------------------------------

Cú pháp lệnh của INNER JOIN
SELECT
    Table_A.pk_column,
    Table_A.columns,
    Table_B.pk_column,
    Table_B.columns
FROM 
    Table_A
INNER JOIN 
    Table_B  ON Table_A.pk_column = Table_B.fk_column;

---------------------------------------------------------------------------

Cú pháp lệnh của LEFT JOIN
SELECT
	Table_A.pk_column,
	Table_A.columns,
	Table_B.pk_column,
	Table_B.columns
FROM 
	Table_A
LEFT JOIN 
	Table_B ON Table_A.pk_column = Table_B.fk_column;

---------------------------------------------------------------------------

FULL OUTER JOIN
 
Khi thực hiện lấy dữ liệu từ 2 hoặc nhiều bảng sử dụng FULL OUTER JOIN, thì dữ liệu tương ứng bị khuyến giữa các bảng sẽ hiển thị giá trị NULL
Ta có thể hiểu là hợp dữ liệu của 2 hoặc nhiều bảng.

Cú pháp lệnh của FULL OUTER JOIN
SELECT
	Table_A.pk_column,
	Table_A.columns,
	Table_B.pk_column,
	Table_B.columns
FROM
	ble_A
FULL OUTER JOIN
	Table_B ON Table_A.pk_column = Table_B.fk_column;

---------------------------------------------------------------------------

CROSS JOIN
Khái niệm CROSS JOIN có lẽ ít người biết và thực sự nó cũng rất ít được sử dụng. Chúng ta xem ví dụ sau:
Từ hình ảnh trên thì với mỗi phần tử của bảng A thì sẽ liên kết với tất cả các phần tử của bảng B. 
Vậy chúng ta có tổng cộng 2×3=6 bản ghi sẽ được hiển thị.

NATURAL JOIN
UNION

---------------------------------------------------------------------------

1. Tạo và quản lý chỉ mục / PostgreSQL Indexes

Các chỉ mục (Indexs) là các bảng tra cứu đặc biệt mà công cụ tìm kiếm dữ liệu (database search engine) sử dụng để tăng tốc độ truy xuất dữ liệu. Nói một cách đơn giản, một index là một con trỏ tới dữ liệu trong một bảng. Bạn có thể hiểu một index trong database rất giống với phụ lục của một cuốn sách.

Một chỉ mục giúp tăng tốc các truy vấn SELECT và các mệnh đề điều kiện WHERE, ORDER, GROUP. Tuy nhiên, nó làm chậm quá trình nhập dữ liệu, khi sử dụng các câu lệnh UPDATE và INSERT. Vì chúng phải bổ sung thêm các bản ghi vào các bảng chứa index. Các chỉ mục có thể được tạo hoặc loại bỏ đi mà không ảnh hưởng đến dữ liệu.

Để tạo một chỉ mục (Index) trong PostgreSQL chúng ta sử dụng câu lệnh CREATE INDEX

2. Cú pháp lệnh tạo chỉ mục (Index)

CREATE [ UNIQUE ] INDEX [ CONCURRENTLY ] [ [ IF NOT EXISTS ] name ] ON [ ONLY ] table_name [ USING method ]
( { column_name | ( expression ) } [ COLLATE collation ] [ opclass ] [ ASC | DESC ] [ NULLS { FIRST | LAST } ] [, ...] )
[ INCLUDE ( column_name [, ...] ) ]
[ WITH ( storage_parameter = value [, ... ] ) ]
[ TABLESPACE tablespace_name ]
[ WHERE predicate ]

VD: Đánh chỉ mục trên bảng Users, cho trường group_id, chúng ta sử dụng câu lệnh sql sau:
CREATE INDEX IDX_group_id ON users (group_id);

3. Các loại chỉ mục (Index) trong PostgreSQL
PostgreSQL cung cấp một số loại Index như: B-tree, Hash, GiST, SP-GiST và GIN. 
Mỗi loại index sử dụng một thuật toán khác nhau phù hợp nhất với các loại truy vấn khác nhau. 
Theo mặc định, lệnh CREATE INDEX tạo các index B-tree.

4. Chỉ mục trên một trường dữ liệu (Single-Column Indexes)
Chỉ mục được tạo ra chỉ cho 1 trường (Column) của database

CREATE INDEX index_name ON table_name (column_name);

5. Chỉ mục trên nhiều trường dữ liệu (Multicolumn Indexes)
Chỉ mục được tạo ra cho nhiều trường (column) của database

CREATE INDEX index_name ON table_name (column_name_1, column_name_2, ...);

6. Chỉ mục duy nhất (Unique Indexes)
Ngoài việc tăng tốc độ truy xuất dữ liệu, nó còn đảm bảo tính toàn vẹn của dữ liệu bằng việc ngăn không cho chèn các dữ liệu trùng lặp vào bảng CSDL.

CREATE UNIQUE INDEX index_name on table_name (column_name);

7. Chỉ mục một phần (Partial Indexes)
Chỉ mục một phần là một chỉ mục được xây dựng trên một tập hợp con (subset) của bảng dữ liệu, 
tập hợp con được xác định bởi một biểu thức điều kiện (condition).

CREATE INDEX index_name on table_name (conditional_expression);

8. Chỉ mục ngầm (Implicit Indexes)
Chỉ mục ngầm sẽ được tự động tạo bởi các máy chủ CSDL (Database Server) khi một đối tượng được tạo ra. 
Đối tượng ở đây là khóa chính (PRIMARY KEY) hoặc các trường được định nghĩa là duy nhất (UNIQUE Columns). 
Nó sẽ tự động tạo các ràng buộc khóa chính (PRIMARY KEY constraints) và ràng buộc duy nhất (UNIQUE constraints)

9. Xóa chỉ mục (Indexs) trong bảng CSDL
Để xóa các index trong bảng CSLD của PostgreSQL chúng ta sử dụng lệnh: DROP INDEX . Việc xóa index không làm ảnh hưởng tới dữ liệu, nhưng có thể ảnh hưởng tới tốc độ truy xuất dữ liệu.

Cú pháp xóa index

DROP INDEX index_name;

10. VD: Xóa index vừa tạo trên bảng users
DROP INDEX IDX_group_id;

Một số lưu ý khi sử dụng Index
	Index không nên sử dụng ở các bảng có dữ liệu nhỏ
	Bảng thường xuyên có thêm và cập nhật dữ liệu
	Bảng có nhiều dữ liệu NULL
	Các trường thường xuyên thao tác

---------------------------------------------------------------------------

MyISAM & InnoDB in MySQL: MySqlStorage engineTable engine
Khi tạo 1 bảng trong MySQL sẽ có nhiều kiểu Storage Engine để bạn lựa chọn. 
Trong bài viết này, mình sẽ đề cập đến 2 kiểu lưu trữ bảng được sử dụng nhiều nhất là InnoDB và MyISAM.

---------------------------------------------------------------------------

Các loại chỉ mục (Index) trong PostgreSQL
PostgreSQL cung cấp một số loại Index như: B-tree, Hash, GiST, SP-GiST và GIN. 
Mỗi loại index sử dụng một thuật toán khác nhau phù hợp nhất với các loại truy vấn khác nhau. 
Theo mặc định, lệnh CREATE INDEX tạo các index B-tree.


---------------------------------------------------------------------------

1. Transactions trong PostgreSQL
Một transaction trong PostgreSQL là một giao dịch (phiên làm việc) xử lý tổ hợp nhiều lệnh SQL cùng một lúc. 
Nếu chương trình có vấn đề hoặc lỗi trong xử lý nó sẽ gọi ROLLBACK để hủy quá trình thực hiện. 
Lúc đó dữ liệu trong database sẽ không thay đổi.

2. Các lệnh trong PostgreSQL Transactions
Các lệnh sau được sử dụng để kiểm soát các giao dịch –

BEGIN TRANSACTION – Để bắt đầu một Transaction
COMMIT – Để lưu các thay đổi vào database, hoặc bạn có thể sử dụng lệnh END TRANSACTION.
ROLLBACK – Hủy transaction và không thay đổi dữ liệu trong database.
Transaction chỉ được sử dụng với các lệnh DML là: INSERT, UPDATE, DELETE.

3. Sử dụng PostgreSQL Transaction
3.1 Để bắt đầu một transaction sử dụng lệnh:

BEGIN TRANSACTION;
-- Hoặc
BEGIN:

3.2 Để hoàn thành một transaction sử dụng lệnh:

COMMIT;
-- Hoặc
END TRANSACTION;

3.3 Để hủy một transaction

ROLLBACK;

4. Ví dụ:
4.1 Thêm dữ liệu cho bảng và commit dữ liệu:

BEGIN TRANSACTION;
INSERT INTO public.users(user_id, group_id, username, password, email)
VALUES 
(5, 1, 'HieuDT', '123456', 'hieudt@gmail.com'),
(6, 1, 'PhatML', '123456', 'phatml@gmail.com'),
(7, 1, 'Myttt', '123456', 'myttt@gmail.com');
COMMIT;

4.2 
BEGIN TRANSACTION;
INSERT INTO public.users(user_id, group_id, username, password, email, created_at)
VALUES (8, 1, 'HangNT', '123456', 'hangnt@gmail.com', '2019-12-14 00:00:05');

---------------------------------------------------------------------------

1. PostgreSQL Function: (Còn gọi là Stored Procedures) được sử dụng để thực thi các câu sql để thực hiện một mục đích nhất định. 
Nó cho phép tái sử dụng bằng cách gọi function thay vì phải viết lại các câu sql.

Tạo PostgreSQL Function
Để tạo một Function do người dùng định nghĩa mới trong PostgreSQL, bạn sử dụng câu lệnh CREATE FUNCTION như sau:

CREATE FUNCTION function_name(param_1 type, param_2 type)
RETURNS type AS
BEGIN
-- logic
END;
LANGUAGE language_name;

2. Giờ chúng ta sẽ viết 1 function đơn giản để lấy số lượng bản ghi của bảng.

CREATE OR REPLACE FUNCTION getStaffCount()
RETURNS integer
AS
$$
BEGIN
    RETURN (SELECT count(*) FROM staff);
END
$$
LANGUAGE plpgsql;


=> Để gọi function này sử dụng câu lệnh SQL Sau:
SELECT getStaffCount();

3. VD2: Lấy số lượng số bản ghi trong bảng staff theo vị trí (position)

CREATE OR REPLACE FUNCTION getStaffCountByPosition(_position character varying)
RETURNS integer
AS
$$
BEGIN
    RETURN (SELECT count(*) FROM staff WHERE position = _position);
END
$$
LANGUAGE plpgsql;

=> Để gọi function này sử dụng câu lệnh SQL Sau:
SELECT getStaffCountByPosition('dev');

4. Xóa PostgreSQL Function
Để xóa / drop PostgreSQL Function chúng ta sử dụng cú pháp sau:

DROP FUNCTION [ IF EXISTS ] function_name (param_1, param_2, ...)
[ CASCADE | RESTRICT ]

VD: Xóa 2 PostgreSQL function đã tạo ở bên trên chúng ta sử dụng câu sql sau:

DROP FUNCTION getStaffCount();
DROP FUNCTION getStaffCountByPosition(character varying);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

spring.jpa.database=POSTGRESQL
spring.datasource.platform=postgres
spring.datasource.url=jdbc:postgresql://yourhost:5432/databaseName?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory
spring.datasource.username=""
spring.datasource.password=""
spring.datasource.driver-class-name=org.postgresql.Driver
spring.datasource.testWhileIdle=true
spring.datasource.validationQuery=SELECT 1
spring.jpa.show-sql=true
spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.hibernate.naming-strategy=org.hibernate.cfg.ImprovedNamingStrategy
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect

--------------------------------------------------------------------------PostgreSQL INFO AND SPRING---------------------------------------------------------------------

PostgreSQL
Pass: 1234

1. Truy cập PostgreSQL
psql -U postgres
2. Tạo user cho DB
CREATE USER springexample WITH PASSWORD '123456';
CREATE USER eshopperdb WITH PASSWORD '123456';

3. Tạo database
CREATE DATABASE springexample OWNER springexample ENCODING = 'UTF8';
CREATE DATABASE eshopperdb OWNER eshopperdb ENCODING = 'UTF8';

4. Lệnh thoát ra khỏi account của root cmd: \q
5. Truy cập DB sau khi đã tạo (U: là user, d: là database)
psql -U springexample -d springexample
psql -U eshopperdb -d eshopperdb
6. Tạo schema
CREATE SCHEMA springexample;
CREATE SCHEMA eshopperdb
--------------------------------------------------------------
--psql -U postgre: access root account postgre
CREATE USER springexample WITH PASSWORD '123456';
CREATE DATABASE springexample OWNER springexample ENCODING = 'UTF8';
--psql -U emer -d emer (pass: 123456)
CREATE SCHEMA springexample;

--------------------------------------------------------------

jdbc.driverClassName = org.postgresql.Driver
jdbc.url = jdbc:postgresql://localhost:5432/emer
jdbc.username = emer
jdbc.password = 123456

hibernate.dialect = org.hibernate.dialect.PostgreSQLDialect
hibernate.show_sql = true
hibernate.format_sql = true
hibernate.default_schema = emer
--------------------------------------------------------------
Export Database của PostgreSQL
1. Ở thư mục chứa file export gõ cmd trên thanh toolbar
2. Gõ lệnh sau: pg_dump -U {Tên username của DB (vd: examplespring)} - d {{Tên của DB (vd: examplespring)}} > data.sql
3. Ở  màn hình cmd input pass DB
Note: data.sql là tên file export
--------------------------------------------------------------
set search_path to springexample;

insert into role(code, name) values ('ADMIN', 'Quan tri he thong');
insert into role(code, name) values ('USER', 'Nhan vien');
insert into role(code, name) values ('MANAGER', 'Quan ly');

insert into users(username, password, fullname)
values('admin', 'dfdsfdf3t546t5t5t5t5fdsfdf5fddsfdf', 'admin');
insert into users(username, password, fullname)
values('user', 'thrhgfhgfhdfdsfdf3t546t5t5t5t5fdsf', 'user');
insert into users(username, password, fullname)
values('manager', 'frfdfdsfdf3t546t5t5t5t5fdsfdf5fdds', 'manager');
insert into users(username, password, fullname)
values('test1', 'freferfrfrdfdsfdf3t546t5t5t5t5fdsf', 'test1');
insert into users(username, password, fullname)
values('test2', 'verferfredfdsfdf3t546t5t5t5t5fdsfy', 'test3');
insert into users(username, password, fullname)
values('test3', 'frefrfrdfdsfdf3t546t5t5t5t5fdsfdf5', 'test3');
insert into users(username, password, fullname)
values('test4', 'frefrfrdfdsfdyhtgfrfrfrfdsdsd5t5fd', 'test4');

insert into user_role(user_id, role_id) values (1,1);
insert into user_role(user_id, role_id) values (2,2);
insert into user_role(user_id, role_id) values (3,3);
insert into user_role(user_id, role_id) values (4,2);
insert into user_role(user_id, role_id) values (5,2);
insert into user_role(user_id, role_id) values (6,2);
insert into user_role(user_id, role_id) values (7,2);

---------------------------------------------SQL CREATE TABLE SAMPLE-----------------------------------------------------

DROP TABLE IF EXISTS "public"."tbl_images";
CREATE TABLE "public"."tbl_images" (
"fname" varchar(10) COLLATE "default" NOT NULL,
"type" varchar(6) COLLATE "default",
"date1" timestamp(6),
"from_address" varchar(60) COLLATE "default" NOT NULL,
"group_id" int4 NOT NULL,
"emp_no" varchar(6) COLLATE "default",
"ko_fax_flg" bool,
"ko_syoyo_month" float8,
"date2" timestamp(6),
"fsize" int4,
"staff_image" bytea,
"image_oid" oid,
"large_oid" varchar(50) COLLATE "default",
"bytea_shift_time" timestamp(6),
"image1" bytea,
"bytea_file_name" varchar(50) COLLATE "default"
"mei_kana" varchar(20) COLLATE "default",
"entryday" date,
"sex" int2,
"birthday" date,
"height" int2,
"weight" int2,
"morning_start" time(6),
"morning_finish" time(6),
"delete_reason" text COLLATE "default",
"updataday" timestamptz(6),
"exp_work" varchar(200) COLLATE "default",
"first_toroku_time" timestamp(6),
"wk_d_cnt" int4 DEFAULT 0
)
WITH (OIDS=FALSE);

COMMENT ON TABLE "public"."t_staff" IS 'スタッフマスタ';

CREATE INDEX "mei_kana_index" ON "public"."t_staff" USING btree (mei_kana);
CREATE INDEX "t_staff_pc_mail" ON "public"."t_staff" USING btree (pc_mail);

ALTER TABLE "public"."t_staff" ADD PRIMARY KEY ("staff_cd");
ALTER TABLE "public"."tbl_images" ADD PRIMARY KEY ("group_id", "fname");

-- ----------------------------
-- Triggers structure for table tbl_images
-- ----------------------------
CREATE TRIGGER "del_pict_object" BEFORE DELETE ON "public"."tbl_images"
FOR EACH ROW
EXECUTE PROCEDURE "delete_picture"();

------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE SEQUENCE tbl_shift_manage_w_id_seq;
CREATE SEQUENCE tbl_shift_manage_id_seq;

CREATE TABLE "public"."tbl_shift_manage_w" (
"id" int4 DEFAULT nextval('tbl_shift_manage_w_id_seq'::regclass) NOT NULL,
"ko_cd" varchar(20),
"gyoum_no" int2,
"staff_cd" varchar(10),
"work_monday_flg" varchar(3),
"work_tuesday_flg" varchar(3),
"work_wednesday_flg" varchar(3),
"work_thursday_flg" varchar(3),
"work_friday_flg" varchar(3),
"work_saturday_flg" varchar(3),
"work_sunday_flg" varchar(3),
"work_holiday_flg" varchar(3),
"ent_time" timestamp(0)
)
WITH OIDS;

ALTER TABLE "public"."tbl_shift_manage_w" ADD PRIMARY KEY ("id");

=======================================================================

CREATE SEQUENCE tbl_mail_template_id_seq;

CREATE TABLE "public"."tbl_mail_template"(
"id" int4 DEFAULT nextval('tbl_mail_template_id_seq'::regclass) NOT NULL,
"cd" VARCHAR(10),
"type" VARCHAR(3),
"title" VARCHAR(100),
"body" TEXT,
"ent_time" TIMESTAMP(0),
PRIMARY KEY(id)
)
WITH OIDS;

COMMENT ON COLUMN "public"."tbl_mail_template"."id" IS 'ID';
COMMENT ON COLUMN "public"."tbl_mail_template"."cd" IS '';
COMMENT ON COLUMN "public"."tbl_mail_template"."type" IS '';
COMMENT ON COLUMN "public"."tbl_mail_template"."title" IS '';
COMMENT ON COLUMN "public"."tbl_mail_template"."body" IS '';
COMMENT ON COLUMN "public"."tbl_mail_template"."ent_time" IS '';

=======================================================================

CREATE SEQUENCE tbl_use_fee_id_seq;
CREATE TABLE "public"."tbl_use_fee"(
"id" int8 NOT NULL,
"cd" VARCHAR(20) NOT NULL,
"name" VARCHAR(25),
"price" INT4,
"ent_time" DATE,
"delete_time" DATE,
"ent_time_up" timestamp(0),
"del_flg" varchar(3) DEFAULT 'f'
PRIMARY KEY ("id")
)
WITH OIDS;

ALTER TABLE "public"."tbl_use_fee" ADD COLUMN system_use INT4 DEFAULT NULL;
ALTER TABLE "public"."sysperson" ADD COLUMN enabled bool DEFAULT false;

=======================================================================

CREATE TABLE "public"."group_members" (
  "id" int4 NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1),
  "username" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "group_id" int4 NOT NULL,
  PRIMARY KEY ("id"),
  FOREIGN KEY ("group_id") REFERENCES "public"."groups" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

=======================================================================

CREATE TABLE "public"."groups" (
  "id" int4 NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1),
  "group_name" varchar(50) NOT NULL,
  PRIMARY KEY ("id")
);

insert into groups(group_name) values ('SYS-ADMIN');
insert into groups(group_name) values ('SYS-USER');

------------------------------------------------------------

insert into group_members(username, group_id) values ('user1', '1');

------------------------------------------------------------

CREATE TABLE "public"."user_location" (
  "id" int4 NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1),
  "country" varchar(50) NOT NULL,
  "username" varchar(50) NOT NULL,
  "enabled" bool,
  PRIMARY KEY ("id")
);


ALTER TABLE "public"."users" ADD COLUMN email_verified bool DEFAULT false;
ALTER TABLE users RENAME COLUMN email_verified TO emailVerified;

------------------------------------------------------------

CREATE TABLE "public"."verification_token" (
  "id" int8 NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1),
  "username" varchar(255) DEFAULT NULL,
  "token" varchar(255) DEFAULT NULL,
  "expirydate" DATE,
  "status" varchar(50) DEFAULT NULL,
  CONSTRAINT "FK_VERIFY_USER" FOREIGN KEY (username) REFERENCES users(username),
  PRIMARY KEY ("id")
);


ALTER TABLE "public"."verification_token" ADD COLUMN status varchar(50)

------------------------------------------------------------

password_reset_token


CREATE TABLE "public"."password_reset_token" (
  "id" int8 NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1),
  "username" varchar(255) DEFAULT NULL,
  "token" varchar(255) DEFAULT NULL,
  "expirydate" DATE,
  CONSTRAINT "FK_PWD_RESET_USER" FOREIGN KEY (username) REFERENCES users(username),
  PRIMARY KEY ("id")
);

------------------------------------------------------------

CREATE TABLE "public"."schedule_job_config" (
  "jobtype" varchar(255) NOT NULL,
  "cron_expression" varchar(255) DEFAULT NULL,
  "timezone" varchar(255) DEFAULT NULL,
  "enabled" bool,
  PRIMARY KEY ("jobtype")
);

insert into schedule_job_config(jobtype, cronExpression, timezone, enabled) values ('DELETE_TOKEN_EXPIRED', '0 0 5 * * * ?', 'Asia/Ho_Chi_Minh', true);


------------------------------------------------------------

CREATE TABLE "public"."user_oauth2_social_login" (
  "id" int8 NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1),
  "name" varchar(255) DEFAULT NULL,
  "email" varchar(50) DEFAULT NULL,
  "image_url" varchar(255) DEFAULT NULL,
  "password" varchar(50) DEFAULT NULL,
  "email_verified" bool,
  "provider_id" varchar(50) DEFAULT NULL,
  "provider" varchar(50) DEFAULT NULL,
  "created_date" DATE,
  "updated_date" DATE,
  PRIMARY KEY ("id")
);


-------------------------------------------------HEALTH CARE-----------------------------------------------------------------------------------------

DROP TABLE users;

CREATE TABLE "public"."users" (
  "id" int8 NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1),
  "first_name" varchar(255) DEFAULT NULL,
  "last_name" varchar(255) DEFAULT NULL,
  "email" varchar(50) DEFAULT NULL,
  "password" varchar(255) DEFAULT NULL,
  "address" varchar(255) DEFAULT NULL,
  "phone_number" varchar(50) DEFAULT NULL,
  "gender" bool,
  "image" varchar(50) DEFAULT NULL,
  "role_key" varchar(50) DEFAULT NULL,
  "position_key" varchar(50) DEFAULT NULL,
  "created_date" timestamp(0),
  "updated_date" timestamp(0),
  PRIMARY KEY ("id"),
  CONSTRAINT fk_user_role_key FOREIGN KEY ("role_key") REFERENCES all_code("key")
);

------------
ALTER TABLE "public"."users" ALTER COLUMN "gender" TYPE varchar(50);
ALTER TABLE users RENAME COLUMN role_id TO role_key;
ALTER TABLE users RENAME COLUMN position_id TO position_key;
ALTER TABLE "public"."users" ADD COLUMN position_key varchar(50) DEFAULT NULL;

--ALTER TABLE "public"."users" ADD FOREIGN KEY ("role_key") REFERENCES all_code("key");
ALTER TABLE "public"."users" ADD CONSTRAINT fk_user_role_key FOREIGN KEY ("role_key") REFERENCES all_code("key");

------------


CREATE TABLE "public"."all_code" (
  --"id" int8 NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1),
  "key" varchar(50) NOT NULL,
  "type" varchar(50) DEFAULT NULL,
  "value_en" varchar(255) DEFAULT NULL,
  "value_vi" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("key")
);

CREATE TABLE "public"."booking" (
  "id" int8 NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1),
  "doctor_id" int8 DEFAULT NULL,
  "patient_id" int8 DEFAULT NULL,
  "status_key" varchar(50) DEFAULT NULL,
  "time_key" varchar(50) DEFAULT NULL,
  "date" date DEFAULT NULL,
  "token" varchar(50) DEFAULT NULL,
  "reason" varchar(50) DEFAULT NULL,
  "birthday" varchar(50) DEFAULT NULL,
  "created_date" timestamp(0),
  "updated_date" timestamp(0),
  PRIMARY KEY ("id")
);

ALTER TABLE "public"."booking" ADD CONSTRAINT fk_booking_time_key FOREIGN KEY ("time_key") REFERENCES all_code("key");
ALTER TABLE "public"."booking" ADD CONSTRAINT fk_booking_status_key FOREIGN KEY ("status_key") REFERENCES all_code("key");
ALTER TABLE "public"."booking" ADD CONSTRAINT fk_booking_doctor_id FOREIGN KEY ("doctor_id") REFERENCES users("id");
ALTER TABLE "public"."booking" ADD CONSTRAINT fk_booking_patient_id FOREIGN KEY ("patient_id") REFERENCES users("id");
------------
CREATE TABLE "public"."schedule" (
  "id" int8 NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1),
  "doctor_id" int8 DEFAULT NULL,
  "date" date DEFAULT NULL,
  "time_key" varchar(50) DEFAULT NULL,
  "current_number" int8 DEFAULT NULL,
  "max_number" int8 DEFAULT NULL,
  "created_date" timestamp(0),
  "updated_date" timestamp(0),
  CONSTRAINT fk_schedule_time_key FOREIGN KEY ("time_key") REFERENCES all_code("key")
  PRIMARY KEY ("id")
);

------------
ALTER TABLE "public"."schedule" ADD CONSTRAINT fk_schedule_time_key FOREIGN KEY ("time_key") REFERENCES all_code("key");

------------


CREATE TABLE "public"."history" (
  "id" int8 NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1),
  "patient_key" int8 DEFAULT NULL,
  "doctor_key" int8 DEFAULT NULL,
  "description" varchar(255) DEFAULT NULL,
  "files" varchar(255) DEFAULT NULL,
  "created_date" timestamp(0),
  "updated_date" timestamp(0),
  PRIMARY KEY ("id")
);


CREATE TABLE "public"."clinic" (
  "id" int8 NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1),
  "name" varchar(255) DEFAULT NULL,  
  "address" varchar(255) DEFAULT NULL,
  "description" varchar(255) DEFAULT NULL,
  "image" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("id")
);

CREATE TABLE "public"."speciality" (
  "id" int8 NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1),
  "name" varchar(255) DEFAULT NULL,  
  "description" varchar(255) DEFAULT NULL,
  "image" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("id")
);

CREATE TABLE "public"."doctor_clinic_specialty" (
  "id" int8 NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1),
  "doctor_key" varchar(255) DEFAULT NULL,
  "clinic_key" varchar(255) DEFAULT NULL,
  "speciality_key" varchar(50) DEFAULT NULL,
  PRIMARY KEY ("id")
);


----------------------
CREATE TABLE "public"."doctor" (
  "id" int8 NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1),
  "doctor_id" int8 DEFAULT NULL,
  "price_key" varchar(255) DEFAULT NULL,
  "province_key" varchar(255) DEFAULT NULL,
  "payment_key" varchar(255) DEFAULT NULL,
  "address_clinic" varchar(255) DEFAULT NULL,
  "name_clinic" varchar(255) DEFAULT NULL,
  "note" varchar(255) DEFAULT NULL,
  "count" int8 DEFAULT NULL,
  "created_date" timestamp(0),
  "updated_date" timestamp(0),
  PRIMARY KEY ("id"),
  CONSTRAINT fk_doctor_price_key FOREIGN KEY ("price_key") REFERENCES all_code("key"),
  CONSTRAINT fk_doctor_province_key FOREIGN KEY ("province_key") REFERENCES all_code("key"),
  CONSTRAINT fk_doctor_payment_key FOREIGN KEY ("payment_key") REFERENCES all_code("key")
);

----------------------


CREATE TABLE "public"."markdown" (
  "id" int8 NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1),
  "doctor_id" int8 DEFAULT NULL,  
  "clinic_id" int8 DEFAULT NULL,
  "speciality_id" int8 DEFAULT NULL,
  "content_html" TEXT DEFAULT NULL,
  "content_markdown" TEXT DEFAULT NULL,
  "description" TEXT,
  "created_date" timestamp(0),
  "updated_date" timestamp(0),
  PRIMARY KEY ("id")
);


----------------------
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('ROLE', 'R1', 'Admin', 'Quản trị viên'); 
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('ROLE', 'R2', 'Doctor', 'Bác sĩ'); 
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('ROLE', 'R3', 'Patient', 'Bệnh nhân'); 
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('STATUS', 'S1', 'New', 'Lịch hẹn mới'); 
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('STATUS', 'S2', 'Confirmed', 'Đã xác nhận'); 
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('STATUS', 'S3', 'Done', 'Đã khám xong'); 
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('STATUS', 'S4', 'Cancel', 'Đã hủy');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('TIME', 'T1', '8:00 AM - 9:00 AM', '8:00-9:00'); 
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('TIME', 'T2', '9:00 AM - 10:00 AM', '9:00 - 10:00'); 
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('TIME', 'T3', '10:00 AM - 11:00 AM', '10:00 - 11:00'); 
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('TIME', 'T4', '11:00 AM - 0:00 PM', '11:00-12:00');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('TIME', 'T5', '1:00 PM - 2:00 PM', '13:00 - 14:00'); 
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('TIME', 'T6', '2:00 PM - 3:00 PM', '14:00 - 15:00'); 
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('TIME', 'T7', '3:00 PM - 4:00 PM', '15:00 - 16:00'); 
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('TIME', 'T8', '4:00 PM - 5:00 PM', '16:00 - 17:00');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('POSITION', 'P0', 'None', 'Bác sĩ'); 
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('POSITION', 'P1', 'Master', 'Thạc sĩ'); 
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('POSITION', 'P2', 'Doctor', 'Tiến sĩ');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('POSITION', 'P3', 'Associate Professor', 'Phó giáo sư'); 
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('POSITION', 'P4', 'Professor', 'Giáo sư');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('GENDER', 'M', 'Male', 'Nam'); 
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('GENDER', 'F', 'Female', 'Nữ'); 
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('GENDER', 'O', 'Other', 'Khác'); 
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('PRICE', 'PRI1', '10', '20000');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('PRICE', 'PRI2', '15', '25000');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('PRICE', 'PRI3', '20', '30000');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('PRICE', 'PRI4', '25', '50000');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('PRICE', 'PRI5', '30', '70000');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('PRICE', 'PRI6', '40', '80000');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('PRICE', 'PRI7', '50', '90000');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('PAYMENT', 'PAY1', 'Cash', 'Tiền mặt');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('PAYMENT', 'PAY2', 'Bank cards', 'Thẻ ATM');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('PAYMENT', 'PAY3', 'E-Wallets', 'Ví điện tử');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('PAYMENT', 'PAY4', 'All payment method', 'Tất cả');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('PROVINCE', 'PROV1', 'Ha Noi', 'Hà Nội');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('PROVINCE', 'PROV2', 'Sai Gon', 'Sài Gòn');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('PROVINCE', 'PROV3', 'Hue', 'Huế');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('PROVINCE', 'PROV4', 'Da Nang', 'Đà Nẵng');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('PROVINCE', 'PROV5', 'Can Tho', 'Cần Thơ');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('PROVINCE', 'PROV6', 'Hai Phong', 'Hải Phòng');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('PROVINCE', 'PROV7', 'Da Lat', 'Đà Lạt');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('PROVINCE', 'PROV8', 'Khanh Hoa', 'Khánh Hòa');
INSERT INTO all_code (type, key, "value_en", "value_vi") values ('PROVINCE', 'PROV9', 'Dong Nai', 'Đồng Nai');


----------
MAIL: App name -> healthcare
cpwd mjwy gpeo frrk

--------------------------------------------------------------------------------------------------------------



