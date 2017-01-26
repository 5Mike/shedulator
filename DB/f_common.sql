CREATE SCHEMA sh_f_common AUTHORIZATION postgres;

CREATE OR REPLACE FUNCTION sh_f_common.clean_name(name_to_clean_vc character varying DEFAULT NULL::character varying)
  RETURNS character varying AS
$BODY$
DECLARE
    Search_index_Vc character varying := null;
BEGIN
    if name_to_clean_Vc is not null then
        Search_index_Vc := lower(name_to_clean_Vc);
        Search_index_Vc := regexp_replace(Search_index_Vc
                                       ,'^(q|w|e|r|t|y|u|i|o|p|a|s|d|f|g|h|j|k|l|z|x|c|v|b|n|m)
                                        |^(|1|2|3|4|5|6|7|8|9|0|-)
                                        |^(ё|й|ф|я|ц|ы|ч|у|в|с|к|а|м|е|п|и|н|р|т|г|о|ь|ш|л|б|щ|д|ю|з|ж|э|х|ъ| )'
                                       , ''
                                       );
    END If;
	RETURN Search_index_Vc;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION sh_f_common.clean_name(character varying)
  OWNER TO postgres;

COMMIT;