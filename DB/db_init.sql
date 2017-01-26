-- Table: sh_data.companies
CREATE TABLE sh_data.companies
(
  id integer NOT NULL DEFAULT nextval('companies_id_seq'),
  name character varying(20) NOT NULL,
  search_index character varying(20) NOT NULL,
  CONSTRAINT companies_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE);
ALTER TABLE sh_data.companies OWNER TO postgres;

-- Table: sh_data.object_types
CREATE TABLE sh_data.object_types
(
  obj_id integer NOT NULL DEFAULT nextval('object_types_obj_id_seq'::regclass),
  obj_name character varying(20)[] NOT NULL,
  CONSTRAINT object_types_pkey PRIMARY KEY (obj_id)
)
WITH (OIDS=FALSE);
ALTER TABLE sh_data.object_types OWNER TO postgres;

CREATE UNIQUE INDEX object_types_obj_name_uniq
  ON sh_data.object_types
  USING btree
  (obj_name COLLATE pg_catalog."default");

-- Table: sh_data.objects
CREATE TABLE sh_data.objects
(
  id integer NOT NULL DEFAULT nextval('objects_id_seq'::regclass),
  name character varying(20)[] NOT NULL,
  obj_type_id integer NOT NULL,
  company_id integer NOT NULL,
  parent_obj_id integer NOT NULL,
  acitve_from date NOT NULL DEFAULT clock_timestamp(),
  active_to date,
  active_tag boolean NOT NULL, -- Is helpful when needed to seek by date with active_to is null by index.
  CONSTRAINT objects_pkey PRIMARY KEY (id),
  CONSTRAINT object_fkey_obj_types FOREIGN KEY (obj_type_id)
      REFERENCES sh_data.object_types (obj_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT object_fkey_object FOREIGN KEY (parent_obj_id)
      REFERENCES sh_data.objects (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT objects_fkey_companies FOREIGN KEY (company_id)
      REFERENCES sh_data.companies (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT objects_uniq UNIQUE (company_id, obj_type_id, name, parent_obj_id),
  CONSTRAINT object_check_active_tag CHECK (active_tag IS TRUE AND active_to IS NULL OR active_tag IS FALSE AND active_to IS NOT NULL)
)
WITH (OIDS=FALSE);
ALTER TABLE sh_data.objects OWNER TO postgres;
COMMENT ON COLUMN sh_data.objects.active_tag IS 'Is helpful when needed to seek by date with active_to is null by index.';

CREATE INDEX fki_object_fkey_obj_types
  ON sh_data.objects
  USING btree
  (obj_type_id);

CREATE INDEX fki_object_fkey_object
  ON sh_data.objects
  USING btree
  (parent_obj_id);

-- Table: sh_data.shedules
CREATE TABLE sh_data.shedules
(
  id integer NOT NULL DEFAULT nextval('shedules_id_seq'::regclass),
  object_id integer NOT NULL,
  time_start timestamp(0) with time zone[] NOT NULL,
  time_stop timestamp(0) with time zone[] NOT NULL,
  user_id integer NOT NULL,
  CONSTRAINT shedules_pkey PRIMARY KEY (id),
  CONSTRAINT shedules_fkey_objects FOREIGN KEY (object_id)
      REFERENCES sh_data.objects (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT time_check CHECK (time_start < time_stop)
)
WITH (OIDS=FALSE);
ALTER TABLE sh_data.shedules OWNER TO postgres;

CREATE INDEX fki_shedules_fkey_objects
  ON sh_data.shedules
  USING btree
  (object_id);

-- Table: sh_data.users
CREATE TABLE sh_data.users
(
  id integer NOT NULL DEFAULT nextval('users_id_seq'::regclass),
  name character varying(20)[] NOT NULL,
  company_id integer NOT NULL,
  phone_num character varying(10)[],
  CONSTRAINT users_pkey PRIMARY KEY (id),
  CONSTRAINT users_fkey_companies FOREIGN KEY (company_id)
      REFERENCES sh_data.companies (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT
)
WITH (OIDS=FALSE);
ALTER TABLE sh_data.users OWNER TO postgres;

COMMIT;