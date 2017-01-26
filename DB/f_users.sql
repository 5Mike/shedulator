CREATE SCHEMA sh_f_users AUTHORIZATION postgres;

CREATE OR REPLACE FUNCTION sh_f_users.users_create(
    user_name_Pc    varchar  DEFAULT NULL::varchar
    ,company_id_Pi  integer DEFAULT NULL::integer
    ,phone_num_Pc   varchar DEFAULT NULL::varchar
    ,result_Pi      out integer
    )
  RETURNS integer AS
$BODY$DECLARE
  count_recs_Vi  integer := 0;
  user_id_Vi     integer := 0;
  search_index_Vc character varying := null;
BEGIN
  if user_name_Pc is null then return 2; end if; -- передано пустое знаечние
  if company_id_Pi is null then return 2; end if; -- передано пустое знаечние
  
  search_index_Vc := lower(user_name_Pc);
  -- сделать убирание двух пробелов подряд
  search_index_Vc := clean_name(search_index_Vc);
  if length(search_index_Vc) = 0 then return 3; end if; -- имя компании после очистки от запрещенных символов пусто

  select count(*)
  into count_recs_Vi
  from companies c
  where c.id = company_id_Pi;
  
  if count_recs_Vi <> 1 then 
    result_Pi := 4; -- некорректное количество компаний найдено
    return;
  end if;

  select count(*)
  into count_recs_Vi
  from users u
  where u.company_id = company_id
  and u.name = search_index_Vc;

  if count_recs_Vi > 0 then 
    result_Pi := 5; -- такой пользователь уже существует
    return;
  end if;

  insert into users (name,company_id,phone_num) values (user_name_Pc,company_id_Pi,phone_num_Pc);

  result_Pi := 0;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
--ALTER FUNCTION public.users_create(text, integer, text) OWNER TO shedule;

COMMIT;