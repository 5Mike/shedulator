-- psql -h localhost -U postgres -d shedulator -f /home/mike/PycharmProjects/shedulator/DB/f_companies.sql
CREATE SCHEMA sh_f_companies AUTHORIZATION postgres;

CREATE OR REPLACE FUNCTION sh_f_companies.company_create(company_name_pc character varying DEFAULT NULL::character varying)
  RETURNS integer AS
$BODY$DECLARE
  result_Vi  integer := 0;
  count_recs_Vi  integer := 0;
  search_index_Vc character varying := null;
BEGIN
  if company_name_pc is null then return 2; end if; -- передано пустое знаечние

  search_index_Vc := lower(company_name_pc);
  search_index_Vc := sh_f_common.clean_name(search_index_Vc);
  if length(search_index_Vc) = 0 then return 3; end if; -- имя компании после очистки от запрещенных символов пусто

  select count(*)
  into count_recs_Vi
  from sh_data.companies c
  where c.search_index = search_index_Vc;

  if count_recs_Vi > 0 then return 4; -- такая компания уже есть
  end if;

  insert into sh_data.companies (name,search_index) values (company_name_pc,search_index_Vc);

  return 0; -- успех, компания созадна
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

CREATE OR REPLACE FUNCTION sh_f_companies.company_search(company_name_pc character varying DEFAULT NULL::character varying)
  RETURNS integer AS
$BODY$DECLARE
  result_Vi       integer := 0;
  company_id_Vi   integer := null;
  count_recs_Vi   integer := 0;
  search_index_Vc character varying := null;
BEGIN
  if company_name_pc is null then
    RAISE EXCEPTION 'Company name is empty' USING ERRCODE = '00001';
  end if; -- передано пустое знаечние

  search_index_Vc := lower(company_name_pc);
  search_index_Vc := sh_f_common.clean_name(search_index_Vc);
  if length(search_index_Vc) = 0 then
    RAISE EXCEPTION 'Company name after cleaning is empty' USING ERRCODE = '00001';
  end if; -- имя компании после очистки от запрещенных символов пусто

  select count(*), max(c.id)
  into count_recs_Vi, company_id_Vi
  from sh_data.companies c
  where c.search_index = search_index_Vc;

  if count_recs_Vi = 0 then
    return null;
  end if;

  return company_id_Vi; -- успех, компания найдена
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

COMMIT;