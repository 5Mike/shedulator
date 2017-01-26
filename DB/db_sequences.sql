-- Sequence: sh_data.companies_id_seq
DROP SEQUENCE sh_data.companies_id_seq;
CREATE SEQUENCE sh_data.companies_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE sh_data.companies_id_seq
  OWNER TO postgre;

-- Sequence: sh_data.object_types_obj_id_seq
DROP  SEQUENCE sh_data.object_types_obj_id_seq;
CREATE SEQUENCE sh_data.object_types_obj_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE sh_data.object_types_obj_id_seq
  OWNER TO shedule;

-- Sequence: sh_data.objects_company_id_seq
DROP  SEQUENCE sh_data.objects_company_id_seq;
CREATE SEQUENCE sh_data.objects_company_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE sh_data.objects_company_id_seq
  OWNER TO shedule;

-- Sequence: sh_data.objects_id_seq
DROP  SEQUENCE sh_data.objects_id_seq;
CREATE SEQUENCE sh_data.objects_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE sh_data.objects_id_seq
  OWNER TO shedule;

-- Sequence: sh_data.objects_obj_type_id_seq
DROP  SEQUENCE sh_data.objects_obj_type_id_seq;
CREATE SEQUENCE sh_data.objects_obj_type_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE sh_data.objects_obj_type_id_seq
  OWNER TO shedule;

-- Sequence: sh_data.objects_parent_obj_id_seq
DROP  SEQUENCE sh_data.objects_parent_obj_id_seq;
CREATE SEQUENCE sh_data.objects_parent_obj_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE sh_data.objects_parent_obj_id_seq
  OWNER TO shedule;

-- Sequence: sh_data.shedules_id_seq
DROP  SEQUENCE sh_data.shedules_id_seq;
CREATE SEQUENCE sh_data.shedules_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE sh_data.shedules_id_seq
  OWNER TO shedule;

-- Sequence: sh_data.users_id_seq
DROP  SEQUENCE sh_data.users_id_seq;
CREATE SEQUENCE sh_data.users_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE sh_data.users_id_seq
  OWNER TO shedule;

commit;