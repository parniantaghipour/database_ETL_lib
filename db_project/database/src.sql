-- Table: book

-- DROP TABLE book;

CREATE TABLE IF NOT EXISTS book 
(
    isbn bigint NOT NULL,
    title character(100)   NOT NULL,
    discription text  ,
    version_num integer NOT NULL,
    publisher character(50)   NOT NULL,
    release_date character(20)   NOT NULL,
    create_at date DEFAULT now(),
    CONSTRAINT book_pkey PRIMARY KEY (isbn)
)

TABLESPACE pg_default;

ALTER TABLE book
    OWNER to postgres;
-- Table: translator

-- DROP TABLE translator;

CREATE TABLE IF NOT EXISTS translator
(
    id serial,
    first_name character(20)   NOT NULL,
    middle_name character(20)  ,
    last_name character(20)   NOT NULL,
    create_at date DEFAULT now(),
    CONSTRAINT translator_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE translator
    OWNER to postgres;
-- Table: writer

-- DROP TABLE writer;

CREATE TABLE IF NOT EXISTS writer 
(
    id serial,
    first_name character(20)   NOT NULL,
    middle_name character(20)  ,
    last_name character(20)   NOT NULL,
    create_at date DEFAULT now(),

    CONSTRAINT writer_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE writer
    OWNER to postgres;
	
-- Table: member

-- DROP TABLE member;

CREATE TABLE IF NOT EXISTS member
(
    Fname character(20)   NOT NULL,
    mname character(20)  ,
    lname character(20)   NOT NULL,
    birth_date date NOT NULL,
    membership_date date NOT NULL,
    membership_id integer NOT NULL,
    phone_number numeric(12,0),
    address text  ,
    create_at date DEFAULT now(),

    CONSTRAINT member_pkey PRIMARY KEY (membership_id)
)

TABLESPACE pg_default;

ALTER TABLE member
    OWNER to postgres;
-- Table: book_genre

-- DROP TABLE book_genre;

CREATE TABLE IF NOT EXISTS book_genre
(
	id serial,
    book_id bigint NOT NULL REFERENCES book (isbn)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION ,
    genre character(20) NOT NULL,
    create_at date DEFAULT now(),

    CONSTRAINT book_genre_pkey PRIMARY KEY (id)

)

TABLESPACE pg_default;

ALTER TABLE book_genre
    OWNER to postgres;
-- Table: book_mainlanguage

-- DROP TABLE book_mainlanguage;

CREATE TABLE IF NOT EXISTS book_mainlanguage
(
	id serial,
    book_id bigint NOT NULL REFERENCES book (isbn)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    language character(20)  NOT NULL,
    create_at date DEFAULT now(),

    CONSTRAINT book_mainlanguage_pkey PRIMARY KEY (id)
        
)

TABLESPACE pg_default;

ALTER TABLE book_mainlanguage
    OWNER to postgres;
-- Table: book_tranlatation

-- DROP TABLE book_tranlatation;

CREATE TABLE IF NOT EXISTS book_tranlation
(
	id serial,
    book_id bigint NOT NULL REFERENCES book (isbn) 
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    translator_id integer NOT NULL REFERENCES translator (id) 
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    language character(10)   NOT NULL,
    create_at date DEFAULT now(),

    CONSTRAINT book_tranlator_pkey PRIMARY KEY (id)      
       
)

TABLESPACE pg_default;

ALTER TABLE book_tranlation
    OWNER to postgres;
-- Table: book_writer

-- DROP TABLE book_writer;

CREATE TABLE IF NOT EXISTS book_writer
(
	id serial,
    book_id bigint NOT NULL REFERENCES book (isbn) 
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    writer_id integer NOT NULL REFERENCES writer (id) 
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    create_at date DEFAULT now(),
	
    CONSTRAINT book_writer_pkey PRIMARY KEY (id)        
)

TABLESPACE pg_default;

ALTER TABLE book_writer
    OWNER to postgres;
-- Table: borrow_book

-- DROP TABLE borrow_book;

CREATE TABLE IF NOT EXISTS borrow_book 
(
	id serial,
    member_id integer NOT NULL REFERENCES member (membership_id) ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    book_id bigint NOT NULL REFERENCES book (isbn)ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    "number" integer,
    until date,    
	create_at date DEFAULT now(),	

    CONSTRAINT borrow_book_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE borrow_book
    OWNER to postgres;
-- Table: library

-- DROP TABLE library;

CREATE TABLE IF NOT EXISTS library 
(
	id  serial,
    isbn bigint NOT NULL REFERENCES book (isbn) ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	main_language_id int NOT NULL REFERENCES book_mainlanguage(id) ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    "number" integer NOT NULL,
    create_at date DEFAULT now(),

    CONSTRAINT library_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE library
    OWNER to postgres;
	
	
	
---deleted tables-----------------------------------------------------------
---updated table--------------------------------------------------
-- Table: book

-- DROP TABLE book;

CREATE TABLE IF NOT EXISTS book_updated 
(
    isbn bigint REFERENCES book(isbn) ON UPDATE NO ACTION ON DELETE NO ACTION,
    title character(100)   NOT NULL,
    discription text  ,
    version_num integer NOT NULL,
    publisher character(50)   NOT NULL,
    release_date character(20)   NOT NULL,
	update_at date DEFAULT now(),
    CONSTRAINT book_updated_pkey PRIMARY KEY (isbn, update_at)
)

TABLESPACE pg_default;

ALTER TABLE book_updated
    OWNER to postgres;
-- Table: translator

-- DROP TABLE translator;

CREATE TABLE IF NOT EXISTS translator_updated 
(
    id integer REFERENCES translator(id) ON UPDATE NO ACTION ON DELETE NO ACTION,
    first_name character(20)   NOT NULL,
    middle_name character(20)  ,
    last_name character(20)   NOT NULL,
	update_at date DEFAULT now(),
    CONSTRAINT translator_updated_pkey PRIMARY KEY (id, update_at)
)

TABLESPACE pg_default;

ALTER TABLE translator_updated
    OWNER to postgres;
-- Table: writer

-- DROP TABLE writer;

CREATE TABLE IF NOT EXISTS writer_updated 
(
    id integer REFERENCES writer(id) ON UPDATE NO ACTION ON DELETE NO ACTION,
    first_name character(20)   NOT NULL,
    middle_name character(20)  ,
    last_name character(20)   NOT NULL,
	update_at date DEFAULT now(),

    CONSTRAINT writer_updated_pkey PRIMARY KEY (id, update_at)
)

TABLESPACE pg_default;

ALTER TABLE writer_updated
    OWNER to postgres;
	
-- Table: member

-- DROP TABLE member;

CREATE TABLE IF NOT EXISTS member_updated 
(
    Fname character(20)   NOT NULL,
    mname character(20)  ,
    lname character(20)   NOT NULL,
    birth_date date NOT NULL,
    membership_date date NOT NULL,
    membership_id integer REFERENCES member(membership_id) ON UPDATE NO ACTION ON DELETE NO ACTION,
    phone_number numeric(12,0),
    address text  ,
	update_at date DEFAULT now(),

    CONSTRAINT member_updated_pkey PRIMARY KEY (membership_id, update_at)
)

TABLESPACE pg_default;

ALTER TABLE member_updated
    OWNER to postgres;
-- Table: book_genre

-- DROP TABLE book_genre;

CREATE TABLE IF NOT EXISTS book_genre_updated 
(
	id integer REFERENCES book_genre(id) ON UPDATE NO ACTION ON DELETE NO ACTION,
    book_id bigint NOT NULL,
    genre character(20)   NOT NULL,
	update_at date DEFAULT now(),

    CONSTRAINT book_genre_updated_pkey PRIMARY KEY (id, update_at)
)

TABLESPACE pg_default;

ALTER TABLE book_genre_updated
    OWNER to postgres;
-- Table: book_mainlanguage

-- DROP TABLE book_mainlanguage;

CREATE TABLE IF NOT EXISTS book_mainlanguage_updated 
(
	id integer REFERENCES book_mainlanguage(id) ON UPDATE NO ACTION ON DELETE NO ACTION,
    book_id bigint NOT NULL,
    language character(20)   NOT NULL,
	update_at date DEFAULT now(),

    CONSTRAINT book_mainlanguage_updated_pkey PRIMARY KEY (id, update_at)
)

TABLESPACE pg_default;

ALTER TABLE book_mainlanguage_updated
    OWNER to postgres;
-- Table: book_tranlatation

-- DROP TABLE book_tranlatation;

CREATE TABLE IF NOT EXISTS book_tranlation_updated 
(
	id integer REFERENCES book_tranlation(id) ON UPDATE NO ACTION ON DELETE NO ACTION,    book_id bigint NOT NULL,
    translator_id integer NOT NULL,
    language character(10)   NOT NULL,
	update_at date DEFAULT now(),

    CONSTRAINT book_tranlator_updated_pkey PRIMARY KEY (id, update_at)
)

TABLESPACE pg_default;

ALTER TABLE book_tranlation_updated
    OWNER to postgres;
-- Table: book_writer

-- DROP TABLE book_writer;

CREATE TABLE IF NOT EXISTS book_writer_updated 
(
	id integer REFERENCES book_writer(id) ON UPDATE NO ACTION ON DELETE NO ACTION,
    book_id bigint NOT NULL,
    writer_id integer NOT NULL,
	update_at date DEFAULT now(),
	
    CONSTRAINT book_writer_updated_pkey PRIMARY KEY (id, update_at)
)

TABLESPACE pg_default;

ALTER TABLE book_writer_updated
    OWNER to postgres;
-- Table: borrow_book

-- DROP TABLE borrow_book;

CREATE TABLE IF NOT EXISTS borrow_book_updated 
(
	id integer REFERENCES borrow_book(id) ON UPDATE NO ACTION ON DELETE NO ACTION,
    member_id integer NOT NULL,
    book_id bigint NOT NULL,
    "number" integer,
    until date,    
	update_at date DEFAULT now(),

    CONSTRAINT borrow_book_updated_pkey PRIMARY KEY (id, update_at)
)

TABLESPACE pg_default;

ALTER TABLE borrow_book_updated
    OWNER to postgres;
-- Table: library

-- DROP TABLE library;

CREATE TABLE IF NOT EXISTS library_updated 
(
	id integer REFERENCES library(id) ON UPDATE NO ACTION ON DELETE NO ACTION,
    isbn bigint NOT NULL,
	main_language_id int NOT NULL,
    "number" integer NOT NULL,
	update_at date DEFAULT now(),

    CONSTRAINT library_updated_pkey PRIMARY KEY (isbn, update_at)
)

TABLESPACE pg_default;

ALTER TABLE library_updated
    OWNER to postgres;
--update trigger
CREATE OR REPLACE FUNCTION UPDATE_book_fun()
	RETURNS TRIGGER AS
 $$
	BEGIN
		INSERT INTO book_updated(isbn, title, discription,
            version_num, release_date, publisher) 
		VALUES(old.isbn, old.title, old.discription,
            old.version_number, old.release_date, old.publisher);
		RETURN NULL;
	END
 $$
 LANGUAGE 'plpgsql';

CREATE TRIGGER UPDATE_book_fill
	BEFORE UPDATE 
	ON book
	FOR EACH ROW
	EXECUTE PROCEDURE UPDATE_book_fun();


CREATE OR REPLACE FUNCTION UPDATE_book_genre_fun()
	RETURNS TRIGGER AS
 $$
	BEGIN
		INSERT INTO book_genre_updated(id,book_id, genre) 
		VALUES(old.id, old.book_id, old.genre);
		RETURN NULL;
	END
 $$
 LANGUAGE 'plpgsql';

CREATE TRIGGER UPDATE_book_genre_fill
	BEFORE UPDATE 
	ON book_genre
	FOR EACH ROW
	EXECUTE PROCEDURE UPDATE_book_genre_fun();

CREATE OR REPLACE FUNCTION UPDATE_book_mainlanguage_fun()
	RETURNS TRIGGER AS
 $$
	BEGIN
		INSERT INTO book_mainlanguage_updated(id,book_id, language) 
		VALUES(old.id,old.book_id, old.language);
		RETURN NULL;
	END
 $$
 LANGUAGE 'plpgsql';

CREATE TRIGGER UPDATE_book_mainlanguage_fill
	BEFORE UPDATE 
	ON book_mainlanguage
	FOR EACH ROW
	EXECUTE PROCEDURE UPDATE_book_mainlanguage_fun();
	
CREATE OR REPLACE FUNCTION UPDATE_book_tranlation_fun()
	RETURNS TRIGGER AS
 $$
	BEGIN
		INSERT INTO book_genre_updated(id,book_id, translator_id, language) 
		VALUES(old.id, old.book_id, old.translator_id, old.language);
		RETURN NULL;
	END
 $$
 LANGUAGE 'plpgsql';

CREATE TRIGGER UPDATE_book_tranlation_fill
	BEFORE UPDATE 
	ON book_tranlation
	FOR EACH ROW
	EXECUTE PROCEDURE UPDATE_book_tranlation_fun();

CREATE OR REPLACE FUNCTION UPDATE_book_writer_fun()
	RETURNS TRIGGER AS
 $$
	BEGIN
		INSERT INTO book_writer_updated(id,book_id, writer_id) 
		VALUES(old.id, old.book_id, old.writer_id);
		RETURN NULL;
	END
 $$
 LANGUAGE 'plpgsql';

CREATE TRIGGER UPDATE_book_writer_fill
	BEFORE UPDATE 
	ON book_writer
	FOR EACH ROW
	EXECUTE PROCEDURE UPDATE_book_writer_fun();


CREATE OR REPLACE FUNCTION UPDATE_borrow_book_fun()
	RETURNS TRIGGER AS
 $$
	BEGIN
		INSERT INTO borrow_book_updated(id, member_id,book_id, number, until) 
		VALUES(old.id, old.member_id,old.book_id, old.number,old.until);
		RETURN NULL;
	END
 $$
 LANGUAGE 'plpgsql';

CREATE TRIGGER UPDATE_borrow_book_fill
	BEFORE UPDATE 
	ON borrow_book
	FOR EACH ROW
	EXECUTE PROCEDURE UPDATE_borrow_book_fun();

CREATE OR REPLACE FUNCTION UPDATE_library_fun()
	RETURNS TRIGGER AS
 $$
	BEGIN
		INSERT INTO library_updated(id,isbn,main_language_id, number) 
		VALUES(old.id, old.isbn,old.main_language_id, old.number);
		RETURN NULL;
	END
 $$
 LANGUAGE 'plpgsql';

CREATE TRIGGER UPDATE_library_fill
	BEFORE UPDATE 
	ON library
	FOR EACH ROW
	EXECUTE PROCEDURE UPDATE_library_fun();


CREATE OR REPLACE FUNCTION UPDATE_member_fun()
	RETURNS TRIGGER AS
 $$
	BEGIN
		INSERT INTO member_updated(Fname,mname,lname,birth_date,membership_date,
								   membership_id,phone_number,address) 
		VALUES(old.Fname,old.mname,old.lname,old.birth_date,old.membership_date,
								   old.membership_id,old.old.phone_number,old.address) ;
		RETURN NULL;
	END
 $$
 LANGUAGE 'plpgsql';

CREATE TRIGGER UPDATE_member_fill
	BEFORE UPDATE 
	ON member
	FOR EACH ROW
	EXECUTE PROCEDURE UPDATE_member_fun();


CREATE OR REPLACE FUNCTION UPDATE_translator_fun()
	RETURNS TRIGGER AS
 $$
	BEGIN
		INSERT INTO translator_updated(id,first_name,middle_name,last_name) 
		VALUES(old.id,old.first_name,old.middle_name,old.last_name);
		RETURN NULL;
	END
 $$
 LANGUAGE 'plpgsql';

CREATE TRIGGER UPDATE_translator_fill
	BEFORE UPDATE 
	ON translator
	FOR EACH ROW
	EXECUTE PROCEDURE UPDATE_translator_fun();
	
	
CREATE OR REPLACE FUNCTION UPDATE_writer_fun()
	RETURNS TRIGGER AS
 $$
	BEGIN
		INSERT INTO writer_updated(id,first_name,middle_name,last_name) 
		VALUES(old.id,old.first_name,old.middle_name,old.last_name);
		RETURN NULL;
	END
 $$
 LANGUAGE 'plpgsql';

CREATE TRIGGER UPDATE_writer_fill
	BEFORE UPDATE 
	ON writer
	FOR EACH ROW
	EXECUTE PROCEDURE UPDATE_writer_fun();
