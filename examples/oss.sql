CREATE OR REPLACE FUNCTION get_fk_by_constraint(constraint_name TEXT) RETURNS TEXT AS
$$
BEGIN
    RETURN (SELECT col.attname AS col
            FROM pg_constraint c
                     JOIN LATERAL UNNEST(c.conkey) WITH ORDINALITY AS u(attnum, attposition) ON TRUE
                     JOIN pg_class tbl ON tbl.oid = c.conrelid
                     JOIN pg_attribute col ON (col.attrelid = tbl.oid AND col.attnum = u.attnum)
            WHERE c.conname = constraint_name
            LIMIT 1)::text;
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fk_violation_hint(col_name TEXT, fk_value TEXT) RETURNS TEXT AS
$$
BEGIN
    CASE
        WHEN col_name = 'parent_id'
            THEN RETURN 'This entity''s parent does not exist. Try to export it first. MISSING PARENT UUID: ''' ||
                        fk_value || '''';
        WHEN col_name in ('object_type_id',
                          'object_class_id')
            THEN RETURN 'This entity refers to the missing object type. Try to export it first. MISSING OBJECT_TYPE UUID: ''' ||
                        fk_value || '''';
        WHEN col_name = 'attr_id'
            THEN RETURN 'This entity refers to the missing attribute. Try to export it first. MISSING ATTRIBUTE UUID: ''' ||
                        fk_value || '''';
        WHEN col_name = 'attr_type_def_id'
            THEN RETURN 'This entity refers to the missing attribute type definition. Try to export it first. MISSING ATTRIBUTE TYPE DEFINITION UUID: ''' ||
                        fk_value || '''';
        WHEN col_name = 'list_id'
            THEN RETURN 'This entity refers to the missing list. Try to export it first. MISSING LIST UUID: ''' ||
                        fk_value || '''';
        WHEN col_name = 'list_value_id'
            THEN RETURN 'This entity refers to the missing list value. Try to export it first. MISSING LIST VALUE UUID: ''' ||
                        fk_value || '''';
        WHEN col_name in ('source_object_id',
                          'project_id',
                          'object_id',
                          'reference_id')
            THEN RETURN 'This entity refers to the missing object. Try to export it first. MISSING OBJECT UUID: ''' ||
                        fk_value || '''';
        WHEN col_name = 'attachment_id'
            THEN RETURN 'This entity refers to the missing file. Try to export it first. MISSING FILE UUID: ''' ||
                        fk_value || '''';
        WHEN col_name = 'adapter_id'
            THEN RETURN 'This entity refers to the missing adapter. Try to export it first. MISSING ADAPTER UUID: ''' ||
                        fk_value || '''';
        ELSE
            RETURN 'Unknown foreign key violation. Column name: ' || col_name || '. Value: ''' || fk_value ||
                   '''. Try to export it first.';
        END CASE;
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION log_success(session_uuid UUID, entities UUID[], var_table_name nc_table,
                                       var_data TEXT) RETURNS VOID AS
$$
BEGIN

    INSERT INTO nc_ei_session_logs (session_id, entity_id, table_name, data, status, error_message, possible_solution)
    VALUES (session_uuid, entities, var_table_name, var_data, 'IMPORT_SUCCESS', NULL, NULL);

END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION log_fail(session_uuid UUID, entities UUID[], var_table_name nc_table,
                                    var_data TEXT, severity ei_session_log_status, var_error_message TEXT,
                                    var_possible_solution TEXT) RETURNS VOID AS
$$
BEGIN

    INSERT INTO nc_ei_session_logs (session_id, entity_id, table_name, data, status, error_message, possible_solution)
    VALUES (session_uuid, entities, var_table_name, var_data, severity, var_error_message, var_possible_solution);

END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_object_type_insert(ot NC_OBJECT_TYPES) RETURNS TEXT AS
$$
BEGIN
    RETURN ('INSERT INTO nc_object_types (object_type_id, name, description, parent_id, is_class, properties, icon, system_name) ' ||
            'VALUES('
                || coalesce('''' || ot.object_type_id::text || '''', 'null') || ', '
                || coalesce('''' || ot.name::text || '''', 'null') || ', '
                || coalesce('''' || ot.description::text || '''', 'null') || ', '
                || coalesce('''' || ot.parent_id::text || '''', 'null') || ', '
                || coalesce('''' || ot.is_class::text || '''', 'null') || ', '
                || coalesce('''' || ot.properties::text || '''', 'null') || ', '
                || coalesce('''' || ot.icon::text || '''', 'null') || ', '
                || coalesce('''' || ot.system_name::text || '''', 'null') || '' || ')');
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_object_type_update(ot NC_OBJECT_TYPES) RETURNS TEXT AS
$$
BEGIN
    RETURN ('UPDATE nc_object_types SET name = '
                || coalesce('''' || ot.name::text || '''', 'null') || ', description = '
                || coalesce('''' || ot.description::text || '''', 'null') || ', parent_id = '
                || coalesce('''' || ot.parent_id::text || '''', 'null') || ', is_class = '
                || coalesce('''' || ot.is_class::text || '''', 'null') || ', properties = '
                || coalesce('''' || ot.properties::text || '''', 'null') || ', icon = '
                || coalesce('''' || ot.icon::text || '''', 'null') || ', system_name = '
                || coalesce('''' || ot.system_name::text || '''', 'null') || ' WHERE object_type_id = '
        || coalesce('''' || ot.object_type_id::text || '''', 'null'));
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_attr_object_types_update(aot NC_ATTR_OBJECT_TYPES) RETURNS TEXT AS
$$
BEGIN
    RETURN ('UPDATE nc_attr_object_types SET default_value = '
                || coalesce('''' || aot.default_value::text || '''', 'null') || ', is_required = '
                || coalesce('''' || aot.is_required::text || '''', 'null') || ', is_binded = '
                || coalesce('''' || aot.is_binded::text || '''', 'null') || ' WHERE attr_id = '
                || coalesce('''' || aot.attr_id::text || '''', 'null') || ' AND object_type_id = '
        || coalesce('''' || aot.object_type_id::text || '''', 'null'));
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_adapters_update(adp NC_ADAPTERS) RETURNS TEXT AS
$$
BEGIN
    RETURN ('UPDATE nc_adapters SET name = '
                || coalesce('''' || adp.name::text || '''', 'null') || ', description = '
                || coalesce('''' || adp.description::text || '''', 'null') || ', type = '
                || coalesce('''' || adp.type::text || '''', 'null') || ', adapter_impl = '
                || coalesce('''' || adp.adapter_impl::text || '''', 'null') || ', params = '
                || coalesce('''' || adp.params::text || '''', 'null') || ', version = '
                || coalesce('''' || adp.version::text || '''', 'null') || ', created_when = '
                || coalesce('''' || adp.created_when::text || '''', 'null') || ', modified_when = '
                || coalesce('''' || adp.modified_when::text || '''', 'null') || ', created_by = '
                || coalesce('''' || adp.created_by::text || '''', 'null') || ', modified_by = '
                || coalesce('''' || adp.modified_by::text || '''', 'null') || 'WHERE adapter_id = '
        || coalesce('''' || adp.adapter_id::text || '''', 'null'));
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_adapters_insert(adp NC_ADAPTERS) RETURNS TEXT AS
$$
BEGIN
    RETURN ('INSERT INTO nc_adapters (adapter_id, name, description, type, ' ||
            'adapter_impl, params, version, created_when, modified_when, created_by, modified_by) VALUES('
                || coalesce('''' || adp.adapter_id::text || '''', 'null') || ', '
                || coalesce('''' || adp.name::text || '''', 'null') || ', '
                || coalesce('''' || adp.description::text || '''', 'null') || ', '
                || coalesce('''' || adp.type::text || '''', 'null') || ', '
                || coalesce('''' || adp.adapter_impl::text || '''', 'null') || ', '
                || coalesce('''' || adp.params::text || '''', 'null') || ', '
                || coalesce('''' || adp.version::text || '''', 'null') || ', '
                || coalesce('''' || adp.created_when::text || '''', 'null') || ', '
                || coalesce('''' || adp.modified_when::text || '''', 'null') || ', '
                || coalesce('''' || adp.created_by::text || '''', 'null') || ', '
                || coalesce('''' || adp.modified_by::text || '''', 'null') || '' || ')');
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_attr_object_types_insert(aot NC_ATTR_OBJECT_TYPES) RETURNS TEXT AS
$$
BEGIN
    RETURN ('INSERT INTO nc_attr_object_types (attr_id, object_type_id, default_value, is_required, is_binded) VALUES('
                || coalesce('''' || aot.attr_id::text || '''', 'null') || ', '
                || coalesce('''' || aot.object_type_id::text || '''', 'null') || ', '
                || coalesce('''' || aot.default_value::text || '''', 'null') || ', '
                || coalesce('''' || aot.is_required::text || '''', 'null') || ', '
                || coalesce('''' || aot.is_binded::text || '''', 'null') || '' || ')');
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_attr_type_defs_update(atd NC_ATTR_TYPE_DEFS) RETURNS TEXT AS
$$
BEGIN
    RETURN ('UPDATE nc_attr_type_defs SET name = '
                || coalesce('''' || atd.name::text || '''', 'null') || ', description = '
                || coalesce('''' || atd.description::text || '''', 'null') || ', type = '
                || coalesce('''' || atd.type::text || '''', 'null') || ' WHERE attr_type_def_id = '
        || coalesce('''' || atd.attr_type_def_id::text || '''', 'null'));
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_attr_type_defs_insert(atd NC_ATTR_TYPE_DEFS) RETURNS TEXT AS
$$
BEGIN
    RETURN ('INSERT INTO nc_attr_type_defs (attr_type_def_id, name, description, type) VALUES('
                || coalesce('''' || atd.attr_type_def_id::text || '''', 'null') || ', '
                || coalesce('''' || atd.name::text || '''', 'null') || ', '
                || coalesce('''' || atd.description::text || '''', 'null') || ', '
                || coalesce('''' || atd.type::text || '''', 'null') || '' || ')');
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_attr_type_def_object_types_insert(atd NC_ATTR_TYPE_DEF_OBJECT_TYPES) RETURNS TEXT AS
$$
BEGIN
    RETURN ('INSERT INTO nc_attr_type_def_object_types (attr_type_def_id, object_type_id) VALUES('
                || coalesce('''' || atd.attr_type_def_id::text || '''', 'null') || ', '
                || coalesce('''' || atd.object_type_id::text || '''', 'null') || '' || ')');
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_attributes_update(attr NC_ATTRIBUTES) RETURNS TEXT AS
$$
BEGIN
    RETURN ('UPDATE nc_attributes SET name = '
                || coalesce('''' || attr.name::text || '''', 'null') || ', description = '
                || coalesce('''' || attr.description::text || '''', 'null') || ', tooltip = '
                || coalesce('''' || attr.tooltip::text || '''', 'null') || ', is_multiple = '
                || coalesce('''' || attr.is_multiple::text || '''', 'null') || ', is_calculable = '
                || coalesce('''' || attr.is_calculable::text || '''', 'null') || ', properties = '
                || coalesce('''' || attr.properties::text || '''', 'null') || ', attr_type_id = '
                || coalesce('''' || attr.attr_type_id::text || '''', 'null') || ', list_id = '
                || coalesce('''' || attr.list_id::text || '''', 'null') || ', attr_type_def_id = '
                || coalesce('''' || attr.attr_type_def_id::text || '''', 'null') || ', system_name = '
                || coalesce('''' || attr.system_name::text || '''', 'null') || ' WHERE attr_id = '
        || coalesce('''' || attr.attr_id::text || '''', 'null'));
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_attributes_insert(attr NC_ATTRIBUTES) RETURNS TEXT AS
$$
BEGIN
    RETURN ('INSERT INTO nc_attributes (attr_id, name, description, tooltip, is_multiple, is_calculable, properties,' ||
            ' attr_type_id, list_id, attr_type_def_id, system_name) VALUES('
                || coalesce('''' || attr.attr_id::text || '''', 'null') || ', '
                || coalesce('''' || attr.name::text || '''', 'null') || ', '
                || coalesce('''' || attr.description::text || '''', 'null') || ', '
                || coalesce('''' || attr.tooltip::text || '''', 'null') || ', '
                || coalesce('''' || attr.is_multiple::text || '''', 'null') || ', '
                || coalesce('''' || attr.is_calculable::text || '''', 'null') || ', '
                || coalesce('''' || attr.properties::text || '''', 'null') || ', '
                || coalesce('''' || attr.attr_type_id::text || '''', 'null') || ', '
                || coalesce('''' || attr.list_id::text || '''', 'null') || ', '
                || coalesce('''' || attr.attr_type_def_id::text || '''', 'null') || ', '
                || coalesce('''' || attr.system_name::text || '''', 'null') || '' || ')');
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_lists_update(list NC_LISTS) RETURNS TEXT AS
$$
BEGIN
    RETURN ('UPDATE nc_lists SET name = '
                || coalesce('''' || list.name::text || '''', 'null') || ', description = '
                || coalesce('''' || list.description::text || '''', 'null') || ' WHERE list_id = '
        || coalesce('''' || list.list_id::text || '''', 'null'));
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_lists_insert(list NC_LISTS) RETURNS TEXT AS
$$
BEGIN
    RETURN ('INSERT INTO nc_lists (list_id, name, description) VALUES('
                || coalesce('''' || list.list_id::text || '''', 'null') || ', '
                || coalesce('''' || list.name::text || '''', 'null') || ', '
                || coalesce('''' || list.description::text || '''', 'null') || '' || ')');
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_lists_values_update(lv NC_LIST_VALUES) RETURNS TEXT AS
$$
BEGIN
    RETURN ('UPDATE nc_list_values SET value = '
                || coalesce('''' || lv.value::text || '''', 'null') || ', list_id = '
                || coalesce('''' || lv.list_id::text || '''', 'null') || ', color = '
                || coalesce('''' || lv.color::text || '''', 'null') || ', system_name = '
                || coalesce('''' || lv.system_name::text || '''', 'null') || ' WHERE list_value_id = '
        || coalesce('''' || lv.list_value_id::text || '''', 'null'));
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_lists_values_insert(lv NC_LIST_VALUES) RETURNS TEXT AS
$$
BEGIN
    RETURN ('INSERT INTO nc_list_values (list_value_id, value, list_id, color, system_name) VALUES('
                || coalesce('''' || lv.list_value_id::text || '''', 'null') || ', '
                || coalesce('''' || lv.value::text || '''', 'null') || ', '
                || coalesce('''' || lv.list_id::text || '''', 'null') || ', '
                || coalesce('''' || lv.color::text || '''', 'null') || ', '
                || coalesce('''' || lv.system_name::text || '''', 'null') || '' || ')');
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_objects_update(object NC_OBJECTS) RETURNS TEXT AS
$$
BEGIN
    RETURN ('UPDATE nc_objects SET name = '
                || coalesce('''' || object.name::text || '''', 'null') || ', description = '
                || coalesce('''' || object.description::text || '''', 'null') || ', object_type_id = '
                || coalesce('''' || object.object_type_id::text || '''', 'null') || ', object_class_id = '
                || coalesce('''' || object.object_class_id::text || '''', 'null') || ', source_object_id = '
                || coalesce('''' || object.source_object_id::text || '''', 'null') || ', parent_id = '
                || coalesce('''' || object.parent_id::text || '''', 'null') || ', project_id = '
                || coalesce('''' || object.project_id::text || '''', 'null') || ', created_by = '
                || coalesce('''' || object.created_by::text || '''', 'null') || ', created_when = '
                || coalesce('''' || object.created_when::text || '''', 'null') || ', modified_when = '
                || coalesce('''' || object.modified_when::text || '''', 'null') || ', order_number = '
                || coalesce('''' || object.order_number::text || '''', 'null') || ', modified_by = '
                || coalesce('''' || object.modified_by::text || '''', 'null') || ' WHERE object_id = '
        || coalesce('''' || object.object_id::text || '''', 'null'));
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_objects_insert(object NC_OBJECTS) RETURNS TEXT AS
$$
BEGIN
    RETURN ('INSERT INTO nc_objects (object_id, name, description, object_type_id, object_class_id, source_object_id, ' ||
            'parent_id, project_id, created_by, created_when, modified_when, order_number, modified_by) VALUES('
                || coalesce('''' || object.object_id::text || '''', 'null') || ', '
                || coalesce('''' || object.name::text || '''', 'null') || ', '
                || coalesce('''' || object.description::text || '''', 'null') || ', '
                || coalesce('''' || object.object_type_id::text || '''', 'null') || ', '
                || coalesce('''' || object.object_class_id::text || '''', 'null') || ', '
                || coalesce('''' || object.source_object_id::text || '''', 'null') || ', '
                || coalesce('''' || object.parent_id::text || '''', 'null') || ', '
                || coalesce('''' || object.project_id::text || '''', 'null') || ', '
                || coalesce('''' || object.created_by::text || '''', 'null') || ', '
                || coalesce('''' || object.created_when::text || '''', 'null') || ', '
                || coalesce('''' || object.modified_when::text || '''', 'null') || ', '
                || coalesce('''' || object.order_number::text || '''', 'null')
                || coalesce('''' || object.modified_by::text || '''', 'null') || '' || ')');
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_params_update(param NC_PARAMS) RETURNS TEXT AS
$$
BEGIN
    RETURN ('UPDATE nc_params SET value = '
                || coalesce('''' || param.value::text || '''', 'null') || ', list_value_id = '
                || coalesce('''' || param.list_value_id::text || '''', 'null') || ', attachment_id = '
                || coalesce('''' || param.attachment_id::text || '''', 'null') || ', data = '
                || coalesce('''' || param.data::text || '''', 'null') || ', date_value = '
                || coalesce('''' || param.date_value::text || '''', 'null') || ' WHERE attr_id = '
                || coalesce('''' || param.attr_id::text || '''', 'null') || ' AND object_id = '
        || coalesce('''' || param.object_id::text || '''', 'null'));
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_params_insert(param NC_PARAMS) RETURNS TEXT AS
$$
BEGIN
    RETURN ('INSERT INTO nc_params (attr_id, object_id, value, list_value_id, attachment_id, data, ' ||
            'date_value) VALUES('
                || coalesce('''' || param.attr_id::text || '''', 'null') || ', '
                || coalesce('''' || param.object_id::text || '''', 'null') || ', '
                || coalesce('''' || param.value::text || '''', 'null') || ', '
                || coalesce('''' || param.list_value_id::text || '''', 'null') || ', '
                || coalesce('''' || param.attachment_id::text || '''', 'null') || ', '
                || coalesce('''' || param.data::text || '''', 'null') || ', '
                || coalesce('''' || param.date_value::text || '''', 'null') || '' || ')');
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_references_update(reference NC_REFERENCES) RETURNS TEXT AS
$$
BEGIN
    RETURN ('UPDATE nc_references SET reference_id = '
                || coalesce('''' || reference.reference_id::text || '''', 'null') || ' WHERE attr_id = '
                || coalesce('''' || reference.attr_id::text || '''', 'null') || ' AND object_id = '
                || coalesce('''' || reference.object_id::text || '''', 'null') || ';');
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_references_insert(reference NC_REFERENCES) RETURNS TEXT AS
$$
BEGIN
    RETURN ('INSERT INTO nc_references (attr_id, object_id, reference_id) VALUES('
                || coalesce('''' || reference.attr_id::text || '''', 'null') || ', '
                || coalesce('''' || reference.object_id::text || '''', 'null') || ', '
                || coalesce('''' || reference.reference_id::text || '''', 'null') || '' || ')');
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_files_update(ncfile NC_FILES) RETURNS TEXT AS
$$
BEGIN
    RETURN ('UPDATE nc_files SET name = '
                || coalesce('''' || ncfile.name || '''', 'null') || ', description = '
                || coalesce('''' || ncfile.description || '''', 'null') || ', media_type = '
                || coalesce('''' || ncfile.media_type || '''', 'null') || ', file = '
                || coalesce('''' || ncfile.file::text || '''', 'null') || ' WHERE file_id = '
        || coalesce('''' || ncfile.file_id::text || '''', 'null'));
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nc_files_insert(ncfile NC_FILES) RETURNS TEXT AS
$$
BEGIN
    RETURN ('INSERT INTO nc_files (file_id, name, description, media_type, file) VALUES('
                || coalesce('''' || ncfile.file_id::text || '''', 'null') || ', '
                || coalesce('''' || ncfile.name || '''', 'null') || ', '
                || coalesce('''' || ncfile.description || '''', 'null') || ', '
                || coalesce('''' || ncfile.media_type || '''', 'null') || ', '
                || coalesce('''' || ncfile.file::text || '''', 'null') || '' || ')');
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION locales_insert(locale_id UUID, table_name TEXT, id_field TEXT, loc locale_dto) RETURNS TEXT AS
$$
BEGIN
    RETURN ('INSERT INTO '||table_name||' ('||id_field||', locale_id, value) VALUES('
                || coalesce('''' || loc.entity_id::text || '''', 'null') || ', '
                || coalesce('''' || locale_id::text || '''', 'null') || ', '
                || coalesce('''' || loc.target_value::text || '''', 'null') || '' || ')');
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION locales_update(locale_id UUID, table_name TEXT, id_field TEXT, loc locale_dto) RETURNS TEXT AS
$$
BEGIN
    RETURN ('UPDATE '||table_name||' SET value = '
                || coalesce('''' || loc.target_value::text || '''', 'null') || ' WHERE locale_id = '
                || coalesce('''' || locale_id::text || '''', 'null')||' AND '||id_field||' = '
        || coalesce('''' || loc.entity_id::text || '''', 'null'));
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION import_nc_lists_values(NC_LIST_VALUES[], session_id UUID, OUT err_message VARCHAR) AS
$$
DECLARE
    lv               NC_LIST_VALUES;
    err_mes          VARCHAR;
    err_det          VARCHAR;
    err_constraint   VARCHAR;
    err_column       VARCHAR;
    err_column_value VARCHAR;
    stage_update     BOOLEAN;
BEGIN
    err_message = '';

    FOREACH lv IN ARRAY $1
        LOOP
            BEGIN
                stage_update = TRUE;

                UPDATE NC_LIST_VALUES
                SET value       = lv.value,
                    list_id     = lv.list_id,
                    color       = lv.color,
                    system_name = lv.system_name
                WHERE list_value_id = lv.list_value_id;

                IF found
                THEN
                    PERFORM log_success(session_id, array [lv.list_value_id], 'NC_LIST_VALUES',
                                        nc_lists_values_update(lv));
                    CONTINUE;
                END IF;

                stage_update = FALSE;

                INSERT INTO NC_LIST_VALUES (list_value_id, list_id, value, color, system_name)
                VALUES (lv.list_value_id, lv.list_id, lv.value, lv.color, lv.system_name);

                PERFORM log_success(session_id, array [lv.list_value_id], 'NC_LIST_VALUES', nc_lists_values_insert(lv));

            EXCEPTION
                WHEN foreign_key_violation
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL, err_constraint = CONSTRAINT_NAME;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        err_column = get_fk_by_constraint(err_constraint);
                        EXECUTE 'SELECT $1.' || err_column INTO err_column_value USING lv;
                        PERFORM log_fail(
                                session_id,
                                array [lv.list_value_id],
                                'NC_LIST_VALUES',
                                (CASE
                                     WHEN (stage_update = TRUE) THEN (nc_lists_values_update(lv))
                                     ELSE (nc_lists_values_insert(lv)) END),
                                'IMPORT_ERROR',
                                err_det,
                                fk_violation_hint(err_column, err_column_value)
                            );
                WHEN OTHERS
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        PERFORM log_fail(
                                session_id,
                                array [lv.list_value_id],
                                'NC_LIST_VALUES',
                                (CASE
                                     WHEN (stage_update = TRUE) THEN (nc_lists_values_update(lv))
                                     ELSE (nc_lists_values_insert(lv)) END),
                                'IMPORT_ERROR',
                                err_det,
                                'Unknown error'
                            );
            END;
        END LOOP;

END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION import_nc_lists(NC_LISTS[], session_id UUID, OUT err_message VARCHAR) AS
$$
DECLARE
    list             NC_LISTS;
    err_mes          VARCHAR;
    err_det          VARCHAR;
    err_constraint   VARCHAR;
    err_column       VARCHAR;
    err_column_value VARCHAR;
    stage_update     BOOLEAN;
BEGIN
    err_message = '';

    FOREACH list IN ARRAY $1
        LOOP
            BEGIN
                stage_update = TRUE;

                UPDATE nc_lists
                SET name        = list.name,
                    description = list.description
                WHERE list_id = list.list_id;

                IF found
                THEN
                    PERFORM log_success(session_id, array [list.list_id], 'NC_LISTS', nc_lists_update(list));
                    CONTINUE;
                END IF;

                stage_update = FALSE;

                INSERT INTO nc_lists (list_id, name, description)
                VALUES (list.list_id, list.name, list.description);

                PERFORM log_success(session_id, array [list.list_id], 'NC_LISTS', nc_lists_insert(list));

            EXCEPTION
                WHEN foreign_key_violation
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL, err_constraint = CONSTRAINT_NAME;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        err_column = get_fk_by_constraint(err_constraint);
                        EXECUTE 'SELECT $1.' || err_column INTO err_column_value USING list;
                        PERFORM log_fail(
                                session_id,
                                array [list.list_id],
                                'NC_LISTS',
                                (CASE
                                     WHEN (stage_update = TRUE) THEN (nc_lists_update(list))
                                     ELSE (nc_lists_insert(list)) END),
                                'IMPORT_ERROR',
                                err_det,
                                fk_violation_hint(err_column, err_column_value)
                            );
                WHEN OTHERS
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        PERFORM log_fail(
                                session_id,
                                array [list.list_id],
                                'NC_LISTS',
                                (CASE
                                     WHEN (stage_update = TRUE) THEN (nc_lists_update(list))
                                     ELSE (nc_lists_insert(list)) END),
                                'IMPORT_ERROR',
                                err_det,
                                'Unknown error'
                            );
            END;
        END LOOP;

END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION import_nc_attributes(NC_ATTRIBUTES[], session_id UUID, OUT err_message VARCHAR) AS
$$
DECLARE
    attr             NC_ATTRIBUTES;
    err_mes          VARCHAR;
    err_det          VARCHAR;
    err_constraint   VARCHAR;
    err_column       VARCHAR;
    err_column_value VARCHAR;
    stage_update     BOOLEAN;
BEGIN
    err_message = '';

    FOREACH attr IN ARRAY $1
        LOOP
            BEGIN
                stage_update = TRUE;

                UPDATE nc_attributes
                SET name             = attr.name,
                    description      = attr.description,
                    tooltip          = attr.tooltip,
                    is_multiple      = attr.is_multiple,
                    is_calculable    = attr.is_calculable,
                    properties       = attr.properties,
                    attr_type_id     = attr.attr_type_id,
                    list_id          = attr.list_id,
                    attr_type_def_id = attr.attr_type_def_id,
                    system_name      = attr.system_name,
                    adapter_id       = attr.adapter_id
                WHERE attr_id = attr.attr_id;

                IF found
                THEN
                    PERFORM log_success(session_id, array [attr.attr_id], 'NC_ATTRIBUTES', nc_attributes_update(attr));
                    CONTINUE;
                END IF;

                stage_update = FALSE;

                INSERT INTO nc_attributes (attr_id, name, description, tooltip, is_multiple, is_calculable, properties,
                                           attr_type_id, list_id,
                                           attr_type_def_id, system_name, adapter_id)
                VALUES (attr.attr_id, attr.name, attr.description, attr.tooltip, attr.is_multiple, attr.is_calculable,
                        attr.properties,
                        attr.attr_type_id, attr.list_id, attr.attr_type_def_id, attr.system_name, attr.adapter_id);

                PERFORM log_success(session_id, array [attr.attr_id], 'NC_ATTRIBUTES', nc_attributes_insert(attr));

            EXCEPTION
                WHEN foreign_key_violation
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL, err_constraint = CONSTRAINT_NAME;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        err_column = get_fk_by_constraint(err_constraint);
                        EXECUTE 'SELECT $1.' || err_column INTO err_column_value USING attr;
                        PERFORM log_fail(
                                session_id,
                                array [attr.attr_id],
                                'NC_ATTRIBUTES',
                                (CASE
                                     WHEN (stage_update = TRUE) THEN (nc_attributes_update(attr))
                                     ELSE (nc_attributes_insert(attr)) END),
                                'IMPORT_ERROR',
                                err_det,
                                fk_violation_hint(err_column, err_column_value)
                            );
                WHEN OTHERS
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        PERFORM log_fail(
                                session_id,
                                array [attr.attr_id],
                                'NC_ATTRIBUTES',
                                (CASE
                                     WHEN (stage_update = TRUE) THEN (nc_attributes_update(attr))
                                     ELSE (nc_attributes_insert(attr)) END),
                                'IMPORT_ERROR',
                                err_det,
                                'Unknown error'
                            );
            END;
        END LOOP;

END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION import_nc_object_types(NC_OBJECT_TYPES[], session_id UUID, OUT err_message VARCHAR) AS
$$
DECLARE
    ot               NC_OBJECT_TYPES;
    err_mes          VARCHAR;
    err_det          VARCHAR;
    err_constraint   VARCHAR;
    err_column       VARCHAR;
    err_column_value VARCHAR;
    stage_update     BOOLEAN;
BEGIN
    err_message = '';

    FOREACH ot IN ARRAY $1
        LOOP
            BEGIN
                stage_update = TRUE;

                UPDATE nc_object_types
                SET name        = ot.name,
                    description = ot.description,
                    parent_id   = ot.parent_id,
                    is_class    = ot.is_class,
                    properties  = ot.properties,
                    icon        = ot.icon,
                    system_name = ot.system_name,
                    is_abstract = ot.is_abstract
                WHERE object_type_id = ot.object_type_id;

                IF found
                THEN
                    PERFORM log_success(session_id, array [ot.object_type_id], 'NC_OBJECT_TYPES',
                                        nc_object_type_update(ot));
                    CONTINUE;
                END IF;

                stage_update = FALSE;

                INSERT INTO nc_object_types (object_type_id, name, description, parent_id, is_class, properties, icon,
                                             system_name, is_abstract)
                VALUES (ot.object_type_id, ot.name, ot.description, ot.parent_id, ot.is_class, ot.properties, ot.icon,
                        ot.system_name, ot.is_abstract);

                PERFORM log_success(session_id, array [ot.object_type_id], 'NC_OBJECT_TYPES',
                                    nc_object_type_insert(ot));

            EXCEPTION
                WHEN foreign_key_violation
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL, err_constraint = CONSTRAINT_NAME;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        err_column = get_fk_by_constraint(err_constraint);
                        EXECUTE 'SELECT $1.' || err_column INTO err_column_value USING ot;
                        PERFORM log_fail(
                                session_id,
                                array [ot.object_type_id],
                                'NC_OBJECT_TYPES',
                                (CASE
                                     WHEN (stage_update = TRUE) THEN (nc_object_type_update(ot))
                                     ELSE (nc_object_type_insert(ot)) END),
                                'IMPORT_ERROR',
                                err_det,
                                fk_violation_hint(err_column, err_column_value)
                            );
                WHEN OTHERS
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        PERFORM log_fail(
                                session_id,
                                array [ot.object_type_id],
                                'NC_OBJECT_TYPES',
                                (CASE
                                     WHEN (stage_update = TRUE) THEN (nc_object_type_update(ot))
                                     ELSE (nc_object_type_insert(ot)) END),
                                'IMPORT_ERROR',
                                err_det,
                                'Unknown error'
                            );
            END;

        END LOOP;

END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION import_nc_attr_object_types(NC_ATTR_OBJECT_TYPES[], session_id UUID, OUT err_message VARCHAR) AS
$$
DECLARE
    aot              NC_ATTR_OBJECT_TYPES;
    err_mes          VARCHAR;
    err_det          VARCHAR;
    err_constraint   VARCHAR;
    err_column       VARCHAR;
    err_column_value VARCHAR;
    stage_update     BOOLEAN;
BEGIN
    err_message = '';

    FOREACH aot IN ARRAY $1
        LOOP
            BEGIN
                stage_update = TRUE;

                UPDATE nc_attr_object_types
                SET default_value = aot.default_value,
                    is_required   = aot.is_required,
                    is_binded     = aot.is_binded
                WHERE attr_id = aot.attr_id
                  AND object_type_id = aot.object_type_id;

                IF found
                THEN
                    PERFORM log_success(session_id, array [aot.attr_id, aot.object_type_id], 'NC_ATTR_OBJECT_TYPES',
                                        nc_attr_object_types_update(aot));
                    CONTINUE;
                END IF;

                stage_update = FALSE;

                INSERT INTO nc_attr_object_types (attr_id, object_type_id, default_value, is_required, is_binded)
                VALUES (aot.attr_id, aot.object_type_id, aot.default_value, aot.is_required, aot.is_binded);

                PERFORM log_success(session_id, array [aot.attr_id, aot.object_type_id], 'NC_ATTR_OBJECT_TYPES',
                                    nc_attr_object_types_insert(aot));

            EXCEPTION
                WHEN foreign_key_violation
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL, err_constraint = CONSTRAINT_NAME;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        err_column = get_fk_by_constraint(err_constraint);
                        EXECUTE 'SELECT $1.' || err_column INTO err_column_value USING aot;
                        PERFORM log_fail(
                                session_id,
                                array [aot.attr_id, aot.object_type_id],
                                'NC_ATTR_OBJECT_TYPES',
                                (CASE
                                     WHEN (stage_update = TRUE) THEN (nc_attr_object_types_update(aot))
                                     ELSE (nc_attr_object_types_insert(aot)) END),
                                'IMPORT_ERROR',
                                err_det,
                                fk_violation_hint(err_column, err_column_value)
                            );
                WHEN OTHERS
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        PERFORM log_fail(
                                session_id,
                                array [aot.attr_id, aot.object_type_id],
                                'NC_ATTR_OBJECT_TYPES',
                                (CASE
                                     WHEN (stage_update = TRUE) THEN (nc_attr_object_types_update(aot))
                                     ELSE (nc_attr_object_types_insert(aot)) END),
                                'IMPORT_ERROR',
                                err_det,
                                'Unknown error'
                            );
            END;
        END LOOP;

END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION import_nc_adapters(NC_ADAPTERS[], session_id UUID, OUT err_message VARCHAR) AS
$$
DECLARE
    adp              NC_ADAPTERS;
    err_mes          VARCHAR;
    err_det          VARCHAR;
    err_constraint   VARCHAR;
    err_column       VARCHAR;
    err_column_value VARCHAR;
    stage_update     BOOLEAN;
BEGIN
    err_message = '';

    FOREACH adp IN ARRAY $1
        LOOP
            BEGIN
                stage_update = TRUE;

                UPDATE nc_adapters
                SET name = adp.name,
                    description = adp.description,
                    type = adp.type,
                    adapter_impl = adp.adapter_impl,
                    params = adp.params,
                    version = adp.version,
                    created_when = adp.created_when,
                    modified_when = adp.modified_when,
                    created_by = adp.created_by,
                    modified_by = adp.modified_by
                WHERE adapter_id = adp.adapter_id;

                IF found
                THEN
                    PERFORM log_success(session_id, array [adp.adapter_id], 'NC_ADAPTERS',
                                        nc_adapters_update(adp));
                    CONTINUE;
                END IF;

                stage_update = FALSE;

                INSERT INTO nc_adapters (adapter_id, name, description, type, adapter_impl, params, version,
                                         created_when, modified_when, created_by, modified_by)
                VALUES (adp.adapter_id, adp.name, adp.description, adp.type, adp.adapter_impl, adp.params, adp.version,
                        adp.created_when, adp.modified_when, adp.created_by, adp.modified_by);

                PERFORM log_success(session_id, array [adp.adapter_id], 'NC_ADAPTERS',
                                    nc_adapters_insert(adp));

            EXCEPTION
                WHEN foreign_key_violation
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL, err_constraint = CONSTRAINT_NAME;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        err_column = get_fk_by_constraint(err_constraint);
                        EXECUTE 'SELECT $1.' || err_column INTO err_column_value USING adp;
                        PERFORM log_fail(
                                session_id,
                                array [adp.adapter_id],
                                'NC_ADAPTERS',
                                (CASE
                                     WHEN (stage_update = TRUE) THEN (nc_adapters_update(adp))
                                     ELSE (nc_adapters_insert(adp)) END),
                                'IMPORT_ERROR',
                                err_det,
                                fk_violation_hint(err_column, err_column_value)
                            );
                WHEN OTHERS
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        PERFORM log_fail(
                                session_id,
                                array [adp.adapter_id],
                                'NC_ADAPTERS',
                                (CASE
                                     WHEN (stage_update = TRUE) THEN (nc_adapters_update(adp))
                                     ELSE (nc_adapters_insert(adp)) END),
                                'IMPORT_ERROR',
                                err_det,
                                'Unknown error'
                            );
            END;
        END LOOP;

END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION import_nc_attr_type_defs(NC_ATTR_TYPE_DEFS[], session_id UUID, OUT err_message VARCHAR) AS
$$
DECLARE
    atd              NC_ATTR_TYPE_DEFS;
    err_mes          VARCHAR;
    err_det          VARCHAR;
    err_constraint   VARCHAR;
    err_column       VARCHAR;
    err_column_value VARCHAR;
    stage_update     BOOLEAN;
BEGIN
    err_message = '';

    FOREACH atd IN ARRAY $1
        LOOP
            BEGIN
                stage_update = TRUE;

                UPDATE nc_attr_type_defs
                SET name        = atd.name,
                    description = atd.description,
                    type        = atd.type
                WHERE attr_type_def_id = atd.attr_type_def_id;

                IF found
                THEN
                    PERFORM log_success(session_id, array [atd.attr_type_def_id], 'NC_ATTR_TYPE_DEFS',
                                        nc_attr_type_defs_update(atd));
                    CONTINUE;
                END IF;

                stage_update = FALSE;

                INSERT INTO nc_attr_type_defs (attr_type_def_id, name, description, type)
                VALUES (atd.attr_type_def_id, atd.name, atd.description, atd.type);

                PERFORM log_success(session_id, array [atd.attr_type_def_id], 'NC_ATTR_TYPE_DEFS',
                                    nc_attr_type_defs_insert(atd));

            EXCEPTION
                WHEN foreign_key_violation
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL, err_constraint = CONSTRAINT_NAME;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        err_column = get_fk_by_constraint(err_constraint);
                        EXECUTE 'SELECT $1.' || err_column INTO err_column_value USING atd;
                        PERFORM log_fail(
                                session_id,
                                array [atd.attr_type_def_id],
                                'NC_ATTR_TYPE_DEFS',
                                (CASE
                                     WHEN (stage_update = TRUE) THEN (nc_attr_type_defs_update(atd))
                                     ELSE (nc_attr_type_defs_insert(atd)) END),
                                'IMPORT_ERROR',
                                err_det,
                                fk_violation_hint(err_column, err_column_value)
                            );
                WHEN OTHERS
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        PERFORM log_fail(
                                session_id,
                                array [atd.attr_type_def_id],
                                'NC_ATTR_TYPE_DEFS',
                                (CASE
                                     WHEN (stage_update = TRUE) THEN (nc_attr_type_defs_update(atd))
                                     ELSE (nc_attr_type_defs_insert(atd)) END),
                                'IMPORT_ERROR',
                                err_det,
                                'Unknown error'
                            );
            END;
        END LOOP;

END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION import_nc_attr_type_def_object_types(NC_ATTR_TYPE_DEF_OBJECT_TYPES[], session_id UUID,
                                                                OUT err_message VARCHAR) AS
$$
DECLARE
    atd              NC_ATTR_TYPE_DEF_OBJECT_TYPES;
    err_mes          VARCHAR;
    err_det          VARCHAR;
    err_constraint   VARCHAR;
    err_column       VARCHAR;
    err_column_value VARCHAR;
BEGIN
    err_message = '';

    FOREACH atd IN ARRAY $1
        LOOP

            IF NOT EXISTS(SELECT 1
                          FROM nc_attr_type_def_object_types
                          WHERE attr_type_def_id = atd.attr_type_def_id
                            AND object_type_id = atd.object_type_id)
            THEN
                BEGIN

                    INSERT INTO nc_attr_type_def_object_types (attr_type_def_id, object_type_id)
                    VALUES (atd.attr_type_def_id, atd.object_type_id);

                    PERFORM log_success(session_id, array [atd.attr_type_def_id, atd.object_type_id],
                                        'NC_ATTR_TYPE_DEF_OBJECT_TYPES', nc_attr_type_def_object_types_insert(atd));

                EXCEPTION
                    WHEN foreign_key_violation
                        THEN
                            GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL, err_constraint = CONSTRAINT_NAME;
                            err_message = err_message || err_mes || ': ' || err_det || chr(10);
                            err_column = get_fk_by_constraint(err_constraint);
                            EXECUTE 'SELECT $1.' || err_column INTO err_column_value USING atd;
                            PERFORM log_fail(
                                    session_id,
                                    array [atd.attr_type_def_id, atd.object_type_id],
                                    'NC_ATTR_TYPE_DEF_OBJECT_TYPES',
                                    nc_attr_type_def_object_types_insert(atd),
                                    'IMPORT_ERROR',
                                    err_det,
                                    fk_violation_hint(err_column, err_column_value)
                                );
                    WHEN OTHERS
                        THEN
                            GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL;
                            err_message = err_message || err_mes || ': ' || err_det || chr(10);
                            PERFORM log_fail(
                                    session_id,
                                    array [atd.attr_type_def_id, atd.object_type_id],
                                    'NC_ATTR_TYPE_DEF_OBJECT_TYPES',
                                    nc_attr_type_def_object_types_insert(atd),
                                    'IMPORT_ERROR',
                                    err_det,
                                    'Unknown error'
                                );
                END;
            END IF;
        END LOOP;
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION import_nc_objects(NC_OBJECTS[], session_id UUID, OUT err_message VARCHAR) AS
$$
DECLARE
    object           NC_OBJECTS;
    err_mes          VARCHAR;
    err_det          VARCHAR;
    err_constraint   VARCHAR;
    err_column       VARCHAR;
    err_column_value VARCHAR;
    stage_update     BOOLEAN;
BEGIN
    err_message = '';

    FOREACH object IN ARRAY $1
        LOOP
            BEGIN
                stage_update = TRUE;

                UPDATE nc_objects
                SET name             = object.name,
                    description      = object.description,
                    object_type_id   = object.object_type_id,
                    object_class_id  = object.object_class_id,
                    source_object_id = object.source_object_id,
                    parent_id        = object.parent_id,
                    project_id       = object.project_id,
                    created_by       = object.created_by,
                    created_when     = object.created_when,
                    modified_when    = object.modified_when,
                    order_number     = object.order_number,
                    modified_by      = object.modified_by
                WHERE object_id = object.object_id;

                IF found
                THEN
                    PERFORM log_success(session_id, array [object.object_id],
                                        'NC_OBJECTS', nc_objects_update(object));
                    CONTINUE;
                END IF;

                stage_update = FALSE;

                INSERT INTO nc_objects (object_id, name, description, object_type_id, object_class_id, source_object_id,
                                        parent_id, project_id, created_by, created_when, modified_when, order_number, modified_by)
                VALUES (object.object_id, object.name, object.description, object.object_type_id,
                        object.object_class_id, object.source_object_id, object.parent_id, object.project_id,
                        object.created_by, object.created_when, object.modified_when, object.order_number, object.modified_by);

                PERFORM log_success(session_id, array [object.object_id], 'NC_OBJECTS',
                                    nc_objects_insert(object));

            EXCEPTION
                WHEN foreign_key_violation
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL, err_constraint = CONSTRAINT_NAME;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        err_column = get_fk_by_constraint(err_constraint);
                        EXECUTE 'SELECT $1.' || err_column INTO err_column_value USING object;
                        PERFORM log_fail(
                                session_id,
                                array [object.object_id],
                                'NC_OBJECTS',
                                (CASE
                                     WHEN (stage_update = TRUE) THEN (nc_objects_update(object))
                                     ELSE (nc_objects_insert(object)) END),
                                'IMPORT_ERROR',
                                err_det,
                                fk_violation_hint(err_column, err_column_value)
                            );
                WHEN OTHERS
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        PERFORM log_fail(
                                session_id,
                                array [object.object_id],
                                'NC_OBJECTS',
                                (CASE
                                     WHEN (stage_update = TRUE) THEN (nc_objects_update(object))
                                     ELSE (nc_objects_insert(object)) END),
                                'IMPORT_ERROR',
                                err_det,
                                'Unknown error'
                            );
            END;
        END LOOP;
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION import_nc_params(NC_PARAMS[], session_id UUID, OUT err_message VARCHAR) AS
$$
DECLARE
    param                    NC_PARAMS;
    multiple_attr_params     NC_PARAMS[];
    single_attr_params       NC_PARAMS[];
    single_attr_duplicates   NC_PARAMS[];
    err_mes                  VARCHAR;
    err_det                  VARCHAR;
    err_constraint           VARCHAR;
    err_column               VARCHAR;
    err_column_value         VARCHAR;
    stage_update             BOOLEAN;
BEGIN
    err_message = '';

    SELECT COALESCE(array_agg(params), '{}')
    INTO multiple_attr_params
    FROM (select * from unnest($1) p where (SELECT is_multiple FROM nc_attributes WHERE attr_id = p.attr_id)) params
    WHERE NOT EXISTS(
            SELECT *
            FROM nc_params
            WHERE nc_params = params
        );

    SELECT COALESCE(array_agg(
                    (params.attr_id, params.object_id, params.value, params.list_value_id, params.attachment_id,
                     params.data, params.date_value)) FILTER ( WHERE params.min_rn = params.rn ), '{}'),
           COALESCE(array_agg(
                    (params.attr_id, params.object_id, params.value, params.list_value_id, params.attachment_id,
                     params.data, params.date_value)) FILTER ( WHERE params.min_rn != params.rn ), '{}')
    INTO single_attr_params, single_attr_duplicates
    FROM (SELECT p.*, min(p.rn) OVER (PARTITION BY p.attr_id, p.object_id) min_rn
          FROM (SELECT single_params.*,
                       row_number() OVER (PARTITION BY single_params.attr_id, single_params.object_id) rn
                FROM unnest($1) single_params
                WHERE NOT (SELECT is_multiple FROM nc_attributes WHERE attr_id = single_params.attr_id)) p) params;

    FOREACH param IN ARRAY multiple_attr_params
        LOOP
            BEGIN
                INSERT INTO nc_params (attr_id, object_id, value, list_value_id, attachment_id, data, date_value)
                VALUES (param.attr_id, param.object_id, param.value, param.list_value_id, param.attachment_id,
                        param.data, param.date_value);
                PERFORM log_success(session_id, ARRAY [param.attr_id, param.object_id], 'NC_PARAMS',
                                    nc_params_insert(param));
            EXCEPTION
                WHEN foreign_key_violation
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL, err_constraint = CONSTRAINT_NAME;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        err_column = get_fk_by_constraint(err_constraint);
                        EXECUTE 'SELECT $1.' || err_column INTO err_column_value USING param;
                        PERFORM log_fail(
                                session_id,
                                ARRAY [param.attr_id, param.object_id],
                                'NC_PARAMS',
                                nc_params_insert(param),
                                'IMPORT_ERROR',
                                err_det,
                                fk_violation_hint(err_column, err_column_value)
                            );
                WHEN OTHERS
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        PERFORM log_fail(
                                session_id,
                                ARRAY [param.attr_id, param.object_id],
                                'NC_PARAMS',
                                nc_params_insert(param),
                                'IMPORT_ERROR',
                                err_det,
                                'Unknown error'
                            );
            END;
        END LOOP;

    FOREACH param IN ARRAY single_attr_params
        LOOP
            BEGIN
                stage_update = TRUE;
                UPDATE nc_params
                SET value         = param.value,
                    list_value_id = param.list_value_id,
                    attachment_id = param.attachment_id,
                    data          = param.data,
                    date_value    = param.date_value
                WHERE attr_id = param.attr_id
                  AND object_id = param.object_id;

                IF found
                THEN
                    PERFORM log_success(session_id, ARRAY [param.attr_id, param.object_id],
                                        'NC_PARAMS', nc_params_update(param));
                    CONTINUE;
                END IF;

                stage_update = FALSE;

                INSERT INTO nc_params (attr_id, object_id, value, list_value_id, attachment_id, data, date_value)
                VALUES (param.attr_id, param.object_id, param.value, param.list_value_id, param.attachment_id,
                        param.data, param.date_value);
                PERFORM log_success(session_id, ARRAY [param.attr_id, param.object_id], 'NC_PARAMS',
                                    nc_params_insert(param));
            EXCEPTION
                WHEN foreign_key_violation
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL, err_constraint = CONSTRAINT_NAME;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        err_column = get_fk_by_constraint(err_constraint);
                        EXECUTE 'SELECT $1.' || err_column INTO err_column_value USING param;
                        PERFORM log_fail(
                                session_id,
                                ARRAY [param.attr_id, param.object_id],
                                'NC_PARAMS',
                                (CASE
                                     WHEN (stage_update = TRUE) THEN (nc_params_update(param))
                                     ELSE (nc_params_insert(param)) END),
                                'IMPORT_ERROR',
                                err_det,
                                fk_violation_hint(err_column, err_column_value)
                            );
                WHEN OTHERS
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        PERFORM log_fail(
                                session_id,
                                ARRAY [param.attr_id, param.object_id],
                                'NC_PARAMS',
                                (CASE
                                     WHEN (stage_update = TRUE) THEN (nc_params_update(param))
                                     ELSE (nc_params_insert(param)) END),
                                'IMPORT_ERROR',
                                err_det,
                                'Unknown error'
                            );
            END;
        END LOOP;

    FOREACH param IN ARRAY single_attr_duplicates
        LOOP
            PERFORM log_fail(
                    session_id,
                    ARRAY [param.attr_id, param.object_id],
                    'NC_PARAMS',
                    nc_params_insert(param),
                    'IMPORT_WARNING',
                    'Attribute (' || param.attr_id ||
                    ') is not multiple, but imported data contains duplicates',
                    'Set attribute''s is_multiple = true or check data that has been used for import'
                );
        END LOOP;
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION import_nc_references(NC_REFERENCES[], session_id UUID, OUT err_message VARCHAR) AS
$$
DECLARE
    ref                      NC_REFERENCES;
    multiple_attr_refs       NC_REFERENCES[];
    single_attr_refs         NC_REFERENCES[];
    single_attr_duplicates   NC_REFERENCES[];
    err_mes                  VARCHAR;
    err_det                  VARCHAR;
    err_constraint           VARCHAR;
    err_column               VARCHAR;
    err_column_value         VARCHAR;
    stage_update             BOOLEAN;
BEGIN
    err_message = '';

    SELECT COALESCE(array_agg(refs), '{}')
    INTO multiple_attr_refs
    FROM (select * from unnest($1) r where (SELECT is_multiple FROM nc_attributes WHERE attr_id = r.attr_id)) refs
    WHERE NOT EXISTS(
            SELECT *
            FROM nc_references
            WHERE nc_references = refs
        );

    SELECT COALESCE(array_agg(
                    (refs.attr_id, refs.object_id, refs.reference_id)) FILTER ( WHERE refs.min_rn = refs.rn ), '{}'),
           COALESCE(array_agg(
                    (refs.attr_id, refs.object_id, refs.reference_id)) FILTER ( WHERE refs.min_rn != refs.rn ), '{}')
    INTO single_attr_refs, single_attr_duplicates
    FROM (SELECT r.*, min(r.rn) OVER (PARTITION BY r.attr_id, r.object_id) min_rn
          FROM (SELECT single_refs.*,
                       row_number() OVER (PARTITION BY single_refs.attr_id, single_refs.object_id) rn
                FROM unnest($1) single_refs
                WHERE NOT (SELECT is_multiple FROM nc_attributes WHERE attr_id = single_refs.attr_id)) r) refs;

    FOREACH ref IN ARRAY multiple_attr_refs
        LOOP
            BEGIN
                INSERT INTO nc_references (attr_id, object_id, reference_id)
                VALUES (ref.attr_id, ref.object_id, ref.reference_id);
                PERFORM log_success(session_id, array [ref.attr_id, ref.object_id, ref.reference_id],
                                    'NC_REFERENCES', nc_references_insert(ref));
            EXCEPTION
                WHEN foreign_key_violation
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL, err_constraint = CONSTRAINT_NAME;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        err_column = get_fk_by_constraint(err_constraint);
                        EXECUTE 'SELECT $1.' || err_column INTO err_column_value USING ref;
                        PERFORM log_fail(
                                session_id,
                                array [ref.attr_id, ref.object_id],
                                'NC_REFERENCES',
                                nc_references_insert(ref),
                                'IMPORT_ERROR',
                                err_det,
                                fk_violation_hint(err_column, err_column_value)
                            );
                WHEN OTHERS
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        PERFORM log_fail(
                                session_id,
                                array [ref.attr_id, ref.object_id],
                                'NC_REFERENCES',
                                nc_references_insert(ref),
                                'IMPORT_ERROR',
                                err_det,
                                'Unknown error'
                            );
            END;
        END LOOP;

    FOREACH ref IN ARRAY single_attr_refs
        LOOP
            BEGIN
                stage_update = TRUE;

                UPDATE nc_references
                SET reference_id = ref.reference_id
                WHERE attr_id = ref.attr_id
                  AND object_id = ref.object_id;

                IF found
                THEN
                    PERFORM log_success(session_id, array [ref.attr_id, ref.object_id],
                                        'NC_REFERENCES', nc_references_update(ref));
                    CONTINUE;
                END IF;

                stage_update = FALSE;

                INSERT INTO nc_references (attr_id, object_id, reference_id)
                VALUES (ref.attr_id, ref.object_id, ref.reference_id);
                PERFORM log_success(session_id, array [ref.attr_id, ref.object_id],
                                    'NC_REFERENCES', nc_references_insert(ref));
            EXCEPTION
                WHEN foreign_key_violation
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL, err_constraint = CONSTRAINT_NAME;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        err_column = get_fk_by_constraint(err_constraint);
                        EXECUTE 'SELECT $1.' || err_column INTO err_column_value USING ref;
                        PERFORM log_fail(
                                session_id,
                                array [ref.attr_id, ref.object_id],
                                'NC_REFERENCES',
                                (CASE
                                     WHEN (stage_update = TRUE) THEN (nc_references_update(ref))
                                     ELSE (nc_references_insert(ref)) END),
                                'IMPORT_ERROR',
                                err_det,
                                fk_violation_hint(err_column, err_column_value)
                            );
                WHEN OTHERS
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        PERFORM log_fail(
                                session_id,
                                array [ref.attr_id, ref.object_id],
                                'NC_REFERENCES',
                                (CASE
                                     WHEN (stage_update = TRUE) THEN (nc_references_update(ref))
                                     ELSE (nc_references_insert(ref)) END),
                                'IMPORT_ERROR',
                                err_det,
                                'Unknown error'
                            );
            END;
        END LOOP;

    FOREACH ref IN ARRAY single_attr_duplicates
        LOOP
            PERFORM log_fail(
                    session_id,
                    ARRAY [ref.attr_id, ref.object_id],
                    'NC_REFERENCES',
                    nc_references_insert(ref),
                    'IMPORT_WARNING',
                    'Attribute (' || ref.attr_id ||
                    ') is not multiple, but imported data contains duplicates',
                    'Set attribute''s is_multiple = true or check data that has been used for import'
                );
        END LOOP;
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION import_nc_files(f_id uuid, f_name character varying, f_description text,
                                           f_media_type character varying, f_file bytea, session_id uuid,
                                           OUT err_message character varying)
as
$$
DECLARE
    ncfile           NC_FILES;
    err_mes          VARCHAR;
    err_det          VARCHAR;
    err_constraint   VARCHAR;
    err_column       VARCHAR;
    err_column_value VARCHAR;
    stage_update     BOOLEAN;
BEGIN
    err_message = '';

    stage_update = TRUE;

    SELECT f_id, f_name, f_description, f_media_type, f_file INTO ncfile;

    UPDATE nc_files
    SET name        = ncfile.name,
        description = ncfile.description,
        media_type  = ncfile.media_type,
        file        = ncfile.file
    WHERE file_id = ncfile.file_id;

    IF found
    THEN
        PERFORM log_success(session_id, array [ncfile.file_id],
                            'NC_FILES', nc_files_update(ncfile));
    ELSE
        stage_update = FALSE;

        INSERT INTO nc_files (file_id, name, description, media_type, file)
        VALUES (ncfile.file_id, ncfile.name, ncfile.description, ncfile.media_type, ncfile.file);

        PERFORM log_success(session_id, array [ncfile.file_id], 'NC_FILES',
                            nc_files_insert(ncfile));
    END IF;


EXCEPTION
    WHEN foreign_key_violation
        THEN
            GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL, err_constraint = CONSTRAINT_NAME;
            err_message = err_message || err_mes || ': ' || err_det || chr(10);
            err_column = get_fk_by_constraint(err_constraint);
            EXECUTE 'SELECT $1.' || err_column INTO err_column_value USING ncfile;
            PERFORM log_fail(
                    session_id,
                    array [ncfile.file_id],
                    'NC_FILES',
                    (CASE
                         WHEN (stage_update = TRUE) THEN (nc_files_update(ncfile))
                         ELSE (nc_files_insert(ncfile)) END),
                    'IMPORT_ERROR',
                    err_det,
                    fk_violation_hint(err_column, err_column_value)
                );
    WHEN OTHERS
        THEN
            GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL;
            err_message = err_message || err_mes || ': ' || err_det || chr(10);
            PERFORM log_fail(
                    session_id,
                    array [ncfile.file_id],
                    'NC_FILES',
                    (CASE
                         WHEN (stage_update = TRUE) THEN (nc_files_update(ncfile))
                         ELSE (nc_files_insert(ncfile)) END),
                    'IMPORT_ERROR',
                    err_det,
                    'Unknown error'
                );

END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION import_locales_insert_new_only(session_id UUID, locale_id UUID, t_name TEXT, id_field TEXT, locales locale_dto[], OUT err_message VARCHAR) AS
$$
DECLARE
    loc locale_dto;
    exist boolean;
    err_mes          VARCHAR;
    err_det          VARCHAR;
    err_constraint   VARCHAR;
    err_column       VARCHAR;
    err_column_value VARCHAR;
BEGIN
    FOREACH loc IN ARRAY locales
        LOOP
            BEGIN
                EXECUTE format('SELECT true FROM %I WHERE locale_id = $1 AND %I = $2 LIMIT 1', t_name, id_field)
                    INTO exist USING locale_id, loc.entity_id;
                IF exist IS NULL THEN
                    EXECUTE format('INSERT INTO %I (%I, locale_id, value) VALUES($1, $2, $3)', t_name, id_field)
                        USING loc.entity_id, locale_id, loc.target_value;
                    PERFORM log_success(session_id, array [loc.entity_id, locale_id], UPPER(t_name)::nc_table,
                                        locales_insert(locale_id, t_name, id_field, loc));
                    CONTINUE;
                END IF;
                PERFORM log_fail(session_id,array[loc.entity_id, locale_id], UPPER(t_name)::nc_table,
                                 null,
                                 'IMPORT_WARNING'::ei_session_log_status,
                                 'Conflict strategy does not allow overwriting existing values.'::text,
                                 'Re-run import with FORCE_UPDATE conflict strategy.');
            EXCEPTION
                WHEN foreign_key_violation
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL, err_constraint = CONSTRAINT_NAME;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        err_column = get_fk_by_constraint(err_constraint);
                        err_column_value = loc.entity_id;
                        PERFORM log_fail(
                                session_id,
                                array [loc.entity_id, locale_id],
                                UPPER(t_name)::nc_table,
                                locales_insert(locale_id, t_name, id_field, loc),
                                'IMPORT_ERROR'::ei_session_log_status,
                                err_det,
                                fk_violation_hint(err_column, err_column_value)
                            );
                WHEN OTHERS
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        PERFORM log_fail(
                                session_id,
                                array [loc.entity_id, locale_id],
                                UPPER(t_name)::nc_table,
                                locales_insert(locale_id, t_name, id_field, loc),
                                'IMPORT_ERROR'::ei_session_log_status,
                                err_det,
                                'Unknown error'::text
                            );
            END;
        END LOOP;
END
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION import_locales_force_update(session_id UUID, locale_id UUID, t_name TEXT, id_field TEXT, locales locale_dto[], OUT err_message VARCHAR) AS
$$
DECLARE
    loc locale_dto;
    err_mes          VARCHAR;
    err_det          VARCHAR;
    err_constraint   VARCHAR;
    err_column       VARCHAR;
    err_column_value VARCHAR;
    stage_update     BOOLEAN;
    rowcount INT;
BEGIN
    err_message = '';
    FOREACH loc IN ARRAY locales
        LOOP
            BEGIN
                stage_update = TRUE;
                EXECUTE format('UPDATE %I SET value = $1 WHERE %I = $2 AND locale_id = $3', t_name, id_field)
                    USING loc.target_value, loc.entity_id, locale_id;

                GET DIAGNOSTICS rowcount = ROW_COUNT;
                IF rowcount <> 0
                THEN
                    PERFORM log_success(session_id, array [loc.entity_id, locale_id], UPPER(t_name)::nc_table,
                                        locales_update(locale_id, t_name, id_field, loc));
                    CONTINUE;
                END IF;

                stage_update = FALSE;
                EXECUTE format('INSERT INTO %I (%I, locale_id, value) VALUES($1, $2, $3)', t_name, id_field)
                    USING loc.entity_id, locale_id, loc.target_value;

                PERFORM log_success(session_id, array [loc.entity_id, locale_id], UPPER(t_name)::nc_table,
                                    locales_insert(locale_id, t_name, id_field, loc));

            EXCEPTION
                WHEN foreign_key_violation
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL, err_constraint = CONSTRAINT_NAME;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        err_column = get_fk_by_constraint(err_constraint);
                        err_column_value = loc.entity_id;
                        PERFORM log_fail(
                                session_id,
                                array [loc.entity_id, locale_id],
                                UPPER(t_name)::nc_table,
                                (CASE WHEN (stage_update = TRUE)
                                          THEN (locales_update(locale_id, t_name, id_field, loc))
                                      ELSE (locales_insert(locale_id, t_name, id_field, loc)) END),
                                'IMPORT_ERROR'::ei_session_log_status,
                                err_det,
                                fk_violation_hint(err_column, err_column_value)
                            );
                WHEN OTHERS
                    THEN
                        GET STACKED DIAGNOSTICS err_mes = MESSAGE_TEXT, err_det = PG_EXCEPTION_DETAIL;
                        err_message = err_message || err_mes || ': ' || err_det || chr(10);
                        PERFORM log_fail(
                                session_id,
                                array [loc.entity_id, locale_id],
                                UPPER(t_name)::nc_table,
                                (CASE WHEN (stage_update = TRUE)
                                          THEN (locales_update(locale_id,t_name, id_field, loc))
                                      ELSE (locales_insert(locale_id,t_name, id_field, loc)) END),
                                'IMPORT_ERROR'::ei_session_log_status,
                                err_det,
                                'Unknown error'::text
                            );
            END;
        END LOOP;
END
$$
    LANGUAGE plpgsql;

