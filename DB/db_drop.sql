DROP TABLE sh_data.companies;
DROP TABLE sh_data.object_types;
DROP INDEX sh_data.object_types_obj_name_uniq;
DROP TABLE sh_data.objects;
DROP INDEX sh_data.fki_object_fkey_obj_types;
DROP INDEX sh_data.fki_object_fkey_object;
DROP TABLE sh_data.shedules;
DROP INDEX sh_data.fki_shedules_fkey_objects;
DROP TABLE sh_data.users;
commit;

