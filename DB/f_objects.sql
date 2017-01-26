CREATE SCHEMA sh_f_objects AUTHORIZATION postgres;

CREATE OR REPLACE FUNCTION sh_f_objects.object_types_create(obj_type_name_Pc varchar DEFAULT NULL::varchar)
  RETURNS integer AS
$BODY$DECLARE
  count_recs_Vi  integer := 0;
  obj_type_id_Vi integer := 0;
  search_index_Vc character varying := null;
BEGIN
  if obj_type_name is null then return 2; end if; -- передано пустое знаечние

  search_index_Vc := lower(obj_type_name_Pc);
  search_index_Vc := sh_f_common.clean_name(search_index_Vc);
  if length(search_index_Vc) = 0 then return 3; end if; -- имя после очистки от запрещенных символов пусто

  select count(*)
  into count_recs_Vi
  from object_types c
  where c.obj_name = search_index_Vc;

  if count_recs_Vi > 0 then return 4; -- такая запись уже есть
  end if;

  insert into object_types (obj_name) values (search_index_Vc);

  return 0; -- успех, запись созадна
  exception
  when others then return 1;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
--ALTER FUNCTION public.object_types_create(text) OWNER TO shedule;

CREATE OR REPLACE FUNCTION sh_f_objects.objects_create(
    object_name_Vc      varchar DEFAULT NULL::varchar,
    object_type_id_Vi   integer DEFAULT NULL::integer,
    company_id_Vi       integer DEFAULT NULL::integer,
    parent_obj_id_Vi    integer DEFAULT NULL::integer,
    acitve_from_Vd      date DEFAULT clock_timestamp(),
    active_to_Vd        date DEFAULT NULL::date,
    active_tag_Vb       boolean DEFAULT true)
  RETURNS integer AS
$BODY$DECLARE
  count_recs_Vi   integer := null;
  search_index_Vc character varying := null;
BEGIN
  if object_name_Vc   is null then return 2; end if; -- передано пустое знаечние
  if object_type_id_Vi  is null then return 2; end if; -- передано пустое знаечние
  if company_id_Vi  is null then return 2; end if; -- передано пустое знаечние
  if parent_obj_id_Vi   is null then return 2; end if; -- передано пустое знаечние
  if acitve_from_Vd   is null then return 2; end if; -- передано пустое знаечние
  if active_to_Vd   is null then return 2; end if; -- передано пустое знаечние
  if active_tag_Vb  is null then return 2; end if; -- передано пустое знаечние
  
  search_index_Vc := lower(object_name_Vc);
  -- сделать убирание двух пробелов подряд
  search_index_Vc := clean_name(search_index_Vc);
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
    values  (object_name_Vc
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
--ALTER FUNCTION public.objects_create(text, integer, integer, integer, date, date, boolean) OWNER TO shedule;

COMMIT;