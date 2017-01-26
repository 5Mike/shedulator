-- Function: public.clean_name(character varying)

-- DROP FUNCTION public.clean_name(character varying);

CREATE OR REPLACE FUNCTION public.clean_name(name_to_clean_vc character varying DEFAULT NULL::character varying)
  RETURNS character varying AS
$BODY$	 
DECLARE
    vSearch_index character varying := null;
BEGIN		 	
    if name_to_clean_Vc is not null then
        vSearch_index := lower(name_to_clean_Vc);
        vSearch_index := regexp_replace(vSearch_index
                                       ,'^(q|w|e|r|t|y|u|i|o|p|a|s|d|f|g|h|j|k|l|z|x|c|v|b|n|m)
                                        |^(|1|2|3|4|5|6|7|8|9|0|-)
                                        |^()ё|й|ф|я|ц|ы|ч|у|в|с|к|а|м|е|п|и|н|р|т|г|о|ь|ш|л|б|щ|д|ю|з|ж|э|х|ъ| )'
                                       , '' 
                                       );
    END If;
	RETURN vSearch_index;
END; 	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.clean_name(character varying)
  OWNER TO shedule;

-- Function: public.company_create(text)

-- DROP FUNCTION public.company_create(text);

CREATE OR REPLACE FUNCTION public.company_create(company_name text DEFAULT NULL::text)
  RETURNS integer AS
$BODY$DECLARE
  result  integer := 0;
  count_recs$i  integer := 0;
  vSearch_index character varying := null;
BEGIN
  if company_name is null then return 2; end if; -- передано пустое знаечние
  
  vSearch_index := lower(company_name);
  vSearch_index := clean_name(vSearch_index);
  if length(vSearch_index) = 0 then return 3; end if; -- имя компании после очистки от запрещенных символов пусто

  select count(*)
  into count_recs$i
  from companies c
  where c.search_index = vSearch_index;
  
  if count_recs$i > 0 then return 4; -- такая компания уже есть
  end if;

  insert into companies (name,search_index) values (company_name,vSearch_index);

  return 0; -- успех, компания созадна
  exception
  when others then return 1;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.company_create(text)
  OWNER TO shedule;

-- Function: public.object_types_create(text)

-- DROP FUNCTION public.object_types_create(text);

CREATE OR REPLACE FUNCTION public.object_types_create(obj_name text DEFAULT NULL::text)
  RETURNS integer AS
$BODY$DECLARE
  result  integer := 0;
  count_recs$i  integer := 0;
  obj_type_id$i integer := 0;
  vSearch_index character varying := null;
BEGIN
  if obj_type_name is null then return 2; end if; -- передано пустое знаечние
  
  vSearch_index := lower(obj_type_name);
  vSearch_index := clean_name(vSearch_index);
  if length(vSearch_index) = 0 then return 3; end if; -- имя после очистки от запрещенных символов пусто

  select count(*)
  into count_recs$i
  from object_types c
  where c.obj_name = vSearch_index;
  
  if count_recs$i > 0 then return 4; -- такая запись уже есть
  end if;

  insert into object_types (obj_name) values (vSearch_index);

  return 0; -- успех, запись созадна
  exception
  when others then return 1;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.object_types_create(text)
  OWNER TO shedule;

-- Function: public.objects_create(text, integer, integer, integer, date, date, boolean)

-- DROP FUNCTION public.objects_create(text, integer, integer, integer, date, date, boolean);

CREATE OR REPLACE FUNCTION public.objects_create(
    object_name_vs text DEFAULT NULL::text,
    object_type_id_vi integer DEFAULT NULL::integer,
    company_id_vi integer DEFAULT NULL::integer,
    parent_obj_id_vi integer DEFAULT NULL::integer,
    acitve_from_vd date DEFAULT clock_timestamp(),
    active_to_vd date DEFAULT NULL::date,
    active_tag_vb boolean DEFAULT true)
  RETURNS integer AS
$BODY$DECLARE
  result_Vi     integer := 0;
  count_recs_Vi   integer := null;
  search_index_Vc character varying := null;
BEGIN
  if object_name_Vs   is null then return 2; end if; -- передано пустое знаечние
  if object_type_id_Vi  is null then return 2; end if; -- передано пустое знаечние
  if company_id_Vi  is null then return 2; end if; -- передано пустое знаечние
  if parent_obj_id_Vi   is null then return 2; end if; -- передано пустое знаечние
  if acitve_from_Vd   is null then return 2; end if; -- передано пустое знаечние
  if active_to_Vd   is null then return 2; end if; -- передано пустое знаечние
  if active_tag_Vb  is null then return 2; end if; -- передано пустое знаечние
  
  search_index_Vc := lower(object_name_Vs);
  -- сделать убирание двух пробелов подряд
  search_index_Vc := clean_name(vSearch_index);
  if length(search_index_Vc) = 0 then return 3; end if; -- имя компании после очистки от запрещенных символов пусто

  select count(*)
  into count_recs_Vi
  from objects o
  where o.name = search_index_Vc
  and o.company_id = company_id_Vi
  and o.object_type_id = object_type_id_Vi
  and o.parent_obj_id = parent_obj_id_Vi
  and o.acitve_from = acitve_from_Vd
  and o.active_tag  = active_tag_Vb;
  --and active_to

  if count_recs_Vi > 0 then return 4; end if; -- запись уже существует или пересекается с другой
  

  insert into objects   (name -- character varying(20)[] NOT NULL
      ,obj_type_id  -- integer NOT NULL
      ,company_id -- integer NOT NULL
      ,parent_obj_id -- integer NOT NULL
      ,acitve_from --date NOT NULL DEFAULT clock_timestamp()
      ,active_to -- date
      ,active_tag -- boolean NOT NULL
      )
    values  (object_name_Vs
      ,object_type_id_Vi
      ,company_id_Vi
      ,parent_obj_id_Vi
      ,acitve_from_Vd
      ,active_to_Vd
      ,active_tag_Vb
      );

  return 0; -- успех, пользователь создан
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.objects_create(text, integer, integer, integer, date, date, boolean)
  OWNER TO shedule;

-- Function: public.users_create(text, integer, text)

-- DROP FUNCTION public.users_create(text, integer, text);

CREATE OR REPLACE FUNCTION public.users_create(
    user_name text DEFAULT NULL::text,
    company_id integer DEFAULT NULL::integer,
    phone_num text DEFAULT NULL::text)
  RETURNS integer AS
$BODY$DECLARE
  result  integer := 0;
  count_recs$i  integer := 0;
  user_id$i integer := 0;
  vSearch_index character varying := null;
BEGIN
  if user_name is null then return 2; end if; -- передано пустое знаечние
  if company_id is null then return 2; end if; -- передано пустое знаечние
  
  vSearch_index := lower(user_name);
  -- сделать убирание двух пробелов подряд
  vSearch_index := clean_name(vSearch_index);
  if length(vSearch_index) = 0 then return 3; end if; -- имя компании после очистки от запрещенных символов пусто

  select count(*)
  into count_recs$i
  from companies c
  where c.id = company_id;
  
  if count_recs$i <> 1 then return 4; -- некорректное количество компаний найдено
  end if;

  select count(*)
  into count_recs$i
  from users u
  where u.company_id = company_id
  and u.name = vSearch_index;

  if count_recs$i > 0 then return 5; -- такой пользователь уже существует
  end if;

  insert into users (name,company_id,phone_num) values (user_name,company_id,phone_num);

  return 0; -- успех, пользователь создан
  exception
  when others then return 1;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.users_create(text, integer, text)
  OWNER TO shedule;
