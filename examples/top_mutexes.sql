INSERT INTO nc_object_types(object_type_id, name, description, parent_id, is_class, properties, icon, system_name, is_abstract)
VALUES ('00000000-0000-0000-0000-000000000000', 'Root', 'Root for object types', NULL, TRUE, NULL, NULL, 'root', TRUE),
       ('ac61ccfc-d6f3-b517-8261-40672b21ab58', 'Document Projects', 'Root for Document projects', '00000000-0000-0000-0000-000000000000', true, NULL, NULL, 'document-projects', true),
       ('a2001f0d-c4a2-6f50-716c-39c1f02ea19e', 'Navigation Container', NULL, '00000000-0000-0000-0000-000000000000', false, NULL, NULL, 'navigation-container', false),
       ('639425d8-cdc4-1b61-1d33-c7ba2a7fc2bc', 'Navigation Item', NULL, 'a2001f0d-c4a2-6f50-716c-39c1f02ea19e', false, NULL, NULL, 'navigation-item', false)
ON CONFLICT (object_type_id)
    DO NOTHING;


INSERT INTO nc_attr_types (attr_type_id, name)
VALUES (0, 'ATTR_TYPE_TEXT'),
       (1, 'ATTR_TYPE_MEMO'),
       (2, 'ATTR_TYPE_NUMBER'),
       (3, 'ATTR_TYPE_DECIMAL'),
       (4, 'ATTR_TYPE_DATE'),
       (5, 'ATTR_TYPE_MASKED'),
       (6, 'ATTR_TYPE_URL'),
       (7, 'ATTR_TYPE_LIST'),
       (8, 'ATTR_TYPE_TABLE'),
       (9, 'ATTR_TYPE_REFERENCE'),
       (10, 'ATTR_TYPE_PASSWORD'),
       (11, 'ATTR_TYPE_ATTR_REF'),
       (12, 'ATTR_TYPE_JAVA_OBJECT'),
       (13, 'ATTR_TYPE_ATTACHMENT'),
       (14, 'ATTR_TYPE_HTML'),
       (15, 'ATTR_TYPE_XML'),
       (16, 'ATTR_TYPE_CURRENCY'),
       (17, 'ATTR_TYPE_REF_TO_OBJECT_TYPE'),
       (18, 'ATTR_TYPE_REF_TO_ATTR_DEF'),
       (19, 'ATTR_TYPE_TIME_AGO')
ON CONFLICT (attr_type_id)
    DO NOTHING;

INSERT INTO nc_locales (locale_code, name, active)
VALUES ('af','Afrikaans',FALSE),
       ('af_NA','Afrikaans (Namibia)',FALSE),
       ('af_ZA','Afrikaans (South Africa)',FALSE),
       ('ak','Akan',FALSE),
       ('ak_GH','Akan (Ghana)',FALSE),
       ('sq','Albanian',FALSE),
       ('sq_AL','Albanian (Albania)',FALSE),
       ('sq_XK','Albanian (Kosovo)',FALSE),
       ('sq_MK','Albanian (Macedonia)',FALSE),
       ('am','Amharic',FALSE),
       ('am_ET','Amharic (Ethiopia)',FALSE),
       ('ar','Arabic',FALSE),
       ('ar_DZ','Arabic (Algeria)',FALSE),
       ('ar_BH','Arabic (Bahrain)',FALSE),
       ('ar_TD','Arabic (Chad)',FALSE),
       ('ar_KM','Arabic (Comoros)',FALSE),
       ('ar_DJ','Arabic (Djibouti)',FALSE),
       ('ar_EG','Arabic (Egypt)',FALSE),
       ('ar_ER','Arabic (Eritrea)',FALSE),
       ('ar_IQ','Arabic (Iraq)',FALSE),
       ('ar_IL','Arabic (Israel)',FALSE),
       ('ar_JO','Arabic (Jordan)',FALSE),
       ('ar_KW','Arabic (Kuwait)',FALSE),
       ('ar_LB','Arabic (Lebanon)',FALSE),
       ('ar_LY','Arabic (Libya)',FALSE),
       ('ar_MR','Arabic (Mauritania)',FALSE),
       ('ar_MA','Arabic (Morocco)',FALSE),
       ('ar_OM','Arabic (Oman)',FALSE),
       ('ar_PS','Arabic (Palestinian Territories)',FALSE),
       ('ar_QA','Arabic (Qatar)',FALSE),
       ('ar_SA','Arabic (Saudi Arabia)',FALSE),
       ('ar_SO','Arabic (Somalia)',FALSE),
       ('ar_SS','Arabic (South Sudan)',FALSE),
       ('ar_SD','Arabic (Sudan)',FALSE),
       ('ar_SY','Arabic (Syria)',FALSE),
       ('ar_TN','Arabic (Tunisia)',FALSE),
       ('ar_AE','Arabic (United Arab Emirates)',FALSE),
       ('ar_EH','Arabic (Western Sahara)',FALSE),
       ('ar_YE','Arabic (Yemen)',FALSE),
       ('hy','Armenian',FALSE),
       ('hy_AM','Armenian (Armenia)',FALSE),
       ('as','Assamese',FALSE),
       ('as_IN','Assamese (India)',FALSE),
       ('az','Azerbaijani',FALSE),
       ('az_AZ','Azerbaijani (Azerbaijan)',FALSE),
       ('az_Cyrl_AZ','Azerbaijani (Cyrillic, Azerbaijan)',FALSE),
       ('az_Cyrl','Azerbaijani (Cyrillic)',FALSE),
       ('az_Latn_AZ','Azerbaijani (Latin, Azerbaijan)',FALSE),
       ('az_Latn','Azerbaijani (Latin)',FALSE),
       ('bm','Bambara',FALSE),
       ('bm_Latn_ML','Bambara (Latin, Mali)',FALSE),
       ('bm_Latn','Bambara (Latin)',FALSE),
       ('eu','Basque',FALSE),
       ('eu_ES','Basque (Spain)',FALSE),
       ('be','Belarusian',FALSE),
       ('be_BY','Belarusian (Belarus)',FALSE),
       ('bn','Bengali',FALSE),
       ('bn_BD','Bengali (Bangladesh)',FALSE),
       ('bn_IN','Bengali (India)',FALSE),
       ('bs','Bosnian',FALSE),
       ('bs_BA','Bosnian (Bosnia & Herzegovina)',FALSE),
       ('bs_Cyrl_BA','Bosnian (Cyrillic, Bosnia & Herzegovina)',FALSE),
       ('bs_Cyrl','Bosnian (Cyrillic)',FALSE),
       ('bs_Latn_BA','Bosnian (Latin, Bosnia & Herzegovina)',FALSE),
       ('bs_Latn','Bosnian (Latin)',FALSE),
       ('br','Breton',FALSE),
       ('br_FR','Breton (France)',FALSE),
       ('bg','Bulgarian',FALSE),
       ('bg_BG','Bulgarian (Bulgaria)',FALSE),
       ('my','Burmese',FALSE),
       ('my_MM','Burmese (Myanmar (Burma))',FALSE),
       ('ca','Catalan',FALSE),
       ('ca_AD','Catalan (Andorra)',FALSE),
       ('ca_FR','Catalan (France)',FALSE),
       ('ca_IT','Catalan (Italy)',FALSE),
       ('ca_ES','Catalan (Spain)',FALSE),
       ('zh','Chinese',FALSE),
       ('zh_CN','Chinese (China)',FALSE),
       ('zh_HK','Chinese (Hong Kong SAR China)',FALSE),
       ('zh_MO','Chinese (Macau SAR China)',FALSE),
       ('zh_Hans_CN','Chinese (Simplified, China)',FALSE),
       ('zh_Hans_HK','Chinese (Simplified, Hong Kong SAR China)',FALSE),
       ('zh_Hans_MO','Chinese (Simplified, Macau SAR China)',FALSE),
       ('zh_Hans_SG','Chinese (Simplified, Singapore)',FALSE),
       ('zh_Hans','Chinese (Simplified)',FALSE),
       ('zh_SG','Chinese (Singapore)',FALSE),
       ('zh_TW','Chinese (Taiwan)',FALSE),
       ('zh_Hant_HK','Chinese (Traditional, Hong Kong SAR China)',FALSE),
       ('zh_Hant_MO','Chinese (Traditional, Macau SAR China)',FALSE),
       ('zh_Hant_TW','Chinese (Traditional, Taiwan)',FALSE),
       ('zh_Hant','Chinese (Traditional)',FALSE),
       ('kw','Cornish',FALSE),
       ('kw_GB','Cornish (United Kingdom)',FALSE),
       ('hr','Croatian',FALSE),
       ('hr_BA','Croatian (Bosnia & Herzegovina)',FALSE),
       ('hr_HR','Croatian (Croatia)',FALSE),
       ('cs','Czech',FALSE),
       ('cs_CZ','Czech (Czech Republic)',FALSE),
       ('da','Danish',FALSE),
       ('da_DK','Danish (Denmark)',FALSE),
       ('da_GL','Danish (Greenland)',FALSE),
       ('nl','Dutch',FALSE),
       ('nl_AW','Dutch (Aruba)',FALSE),
       ('nl_BE','Dutch (Belgium)',FALSE),
       ('nl_BQ','Dutch (Caribbean Netherlands)',FALSE),
       ('nl_CW','Dutch (Curaçao)',FALSE),
       ('nl_NL','Dutch (Netherlands)',FALSE),
       ('nl_SX','Dutch (Sint Maarten)',FALSE),
       ('nl_SR','Dutch (Suriname)',FALSE),
       ('dz','Dzongkha',FALSE),
       ('dz_BT','Dzongkha (Bhutan)',FALSE),
       ('en','English',TRUE),
       ('en_AS','English (American Samoa)',FALSE),
       ('en_AI','English (Anguilla)',FALSE),
       ('en_AG','English (Antigua & Barbuda)',FALSE),
       ('en_AU','English (Australia)',FALSE),
       ('en_BS','English (Bahamas)',FALSE),
       ('en_BB','English (Barbados)',FALSE),
       ('en_BE','English (Belgium)',FALSE),
       ('en_BZ','English (Belize)',FALSE),
       ('en_BM','English (Bermuda)',FALSE),
       ('en_BW','English (Botswana)',FALSE),
       ('en_IO','English (British Indian Ocean Territory)',FALSE),
       ('en_VG','English (British Virgin Islands)',FALSE),
       ('en_CM','English (Cameroon)',FALSE),
       ('en_CA','English (Canada)',FALSE),
       ('en_KY','English (Cayman Islands)',FALSE),
       ('en_CX','English (Christmas Island)',FALSE),
       ('en_CC','English (Cocos (Keeling) Islands)',FALSE),
       ('en_CK','English (Cook Islands)',FALSE),
       ('en_DG','English (Diego Garcia)',FALSE),
       ('en_DM','English (Dominica)',FALSE),
       ('en_ER','English (Eritrea)',FALSE),
       ('en_FK','English (Falkland Islands)',FALSE),
       ('en_FJ','English (Fiji)',FALSE),
       ('en_GM','English (Gambia)',FALSE),
       ('en_GH','English (Ghana)',FALSE),
       ('en_GI','English (Gibraltar)',FALSE),
       ('en_GD','English (Grenada)',FALSE),
       ('en_GU','English (Guam)',FALSE),
       ('en_GG','English (Guernsey)',FALSE),
       ('en_GY','English (Guyana)',FALSE),
       ('en_HK','English (Hong Kong SAR China)',FALSE),
       ('en_IN','English (India)',FALSE),
       ('en_IE','English (Ireland)',FALSE),
       ('en_IM','English (Isle of Man)',FALSE),
       ('en_JM','English (Jamaica)',FALSE),
       ('en_JE','English (Jersey)',FALSE),
       ('en_KE','English (Kenya)',FALSE),
       ('en_KI','English (Kiribati)',FALSE),
       ('en_LS','English (Lesotho)',FALSE),
       ('en_LR','English (Liberia)',FALSE),
       ('en_MO','English (Macau SAR China)',FALSE),
       ('en_MG','English (Madagascar)',FALSE),
       ('en_MW','English (Malawi)',FALSE),
       ('en_MY','English (Malaysia)',FALSE),
       ('en_MT','English (Malta)',FALSE),
       ('en_MH','English (Marshall Islands)',FALSE),
       ('en_MU','English (Mauritius)',FALSE),
       ('en_FM','English (Micronesia)',FALSE),
       ('en_MS','English (Montserrat)',FALSE),
       ('en_NA','English (Namibia)',FALSE),
       ('en_NR','English (Nauru)',FALSE),
       ('en_NZ','English (New Zealand)',FALSE),
       ('en_NG','English (Nigeria)',FALSE),
       ('en_NU','English (Niue)',FALSE),
       ('en_NF','English (Norfolk Island)',FALSE),
       ('en_MP','English (Northern Mariana Islands)',FALSE),
       ('en_PK','English (Pakistan)',FALSE),
       ('en_PW','English (Palau)',FALSE),
       ('en_PG','English (Papua New Guinea)',FALSE),
       ('en_PH','English (Philippines)',FALSE),
       ('en_PN','English (Pitcairn Islands)',FALSE),
       ('en_PR','English (Puerto Rico)',FALSE),
       ('en_RW','English (Rwanda)',FALSE),
       ('en_WS','English (Samoa)',FALSE),
       ('en_SC','English (Seychelles)',FALSE),
       ('en_SL','English (Sierra Leone)',FALSE),
       ('en_SG','English (Singapore)',FALSE),
       ('en_SX','English (Sint Maarten)',FALSE),
       ('en_SB','English (Solomon Islands)',FALSE),
       ('en_ZA','English (South Africa)',FALSE),
       ('en_SS','English (South Sudan)',FALSE),
       ('en_SH','English (St. Helena)',FALSE),
       ('en_KN','English (St. Kitts & Nevis)',FALSE),
       ('en_LC','English (St. Lucia)',FALSE),
       ('en_VC','English (St. Vincent & Grenadines)',FALSE),
       ('en_SD','English (Sudan)',FALSE),
       ('en_SZ','English (Swaziland)',FALSE),
       ('en_TZ','English (Tanzania)',FALSE),
       ('en_TK','English (Tokelau)',FALSE),
       ('en_TO','English (Tonga)',FALSE),
       ('en_TT','English (Trinidad & Tobago)',FALSE),
       ('en_TC','English (Turks & Caicos Islands)',FALSE),
       ('en_TV','English (Tuvalu)',FALSE),
       ('en_UM','English (U.S. Outlying Islands)',FALSE),
       ('en_VI','English (U.S. Virgin Islands)',FALSE),
       ('en_UG','English (Uganda)',FALSE),
       ('en_GB','English (United Kingdom)',FALSE),
       ('en_US','English (United States)',FALSE),
       ('en_VU','English (Vanuatu)',FALSE),
       ('en_ZM','English (Zambia)',FALSE),
       ('en_ZW','English (Zimbabwe)',FALSE),
       ('eo','Esperanto',FALSE),
       ('et','Estonian',FALSE),
       ('et_EE','Estonian (Estonia)',FALSE),
       ('ee','Ewe',FALSE),
       ('ee_GH','Ewe (Ghana)',FALSE),
       ('ee_TG','Ewe (Togo)',FALSE),
       ('fo','Faroese',FALSE),
       ('fo_FO','Faroese (Faroe Islands)',FALSE),
       ('fi','Finnish',FALSE),
       ('fi_FI','Finnish (Finland)',FALSE),
       ('fr','French',FALSE),
       ('fr_DZ','French (Algeria)',FALSE),
       ('fr_BE','French (Belgium)',FALSE),
       ('fr_BJ','French (Benin)',FALSE),
       ('fr_BF','French (Burkina Faso)',FALSE),
       ('fr_BI','French (Burundi)',FALSE),
       ('fr_CM','French (Cameroon)',FALSE),
       ('fr_CA','French (Canada)',FALSE),
       ('fr_CF','French (Central African Republic)',FALSE),
       ('fr_TD','French (Chad)',FALSE),
       ('fr_KM','French (Comoros)',FALSE),
       ('fr_CG','French (Congo - Brazzaville)',FALSE),
       ('fr_CD','French (Congo - Kinshasa)',FALSE),
       ('fr_CI','French (Côte d’Ivoire)',FALSE),
       ('fr_DJ','French (Djibouti)',FALSE),
       ('fr_GQ','French (Equatorial Guinea)',FALSE),
       ('fr_FR','French (France)',FALSE),
       ('fr_GF','French (French Guiana)',FALSE),
       ('fr_PF','French (French Polynesia)',FALSE),
       ('fr_GA','French (Gabon)',FALSE),
       ('fr_GP','French (Guadeloupe)',FALSE),
       ('fr_GN','French (Guinea)',FALSE),
       ('fr_HT','French (Haiti)',FALSE),
       ('fr_LU','French (Luxembourg)',FALSE),
       ('fr_MG','French (Madagascar)',FALSE),
       ('fr_ML','French (Mali)',FALSE),
       ('fr_MQ','French (Martinique)',FALSE),
       ('fr_MR','French (Mauritania)',FALSE),
       ('fr_MU','French (Mauritius)',FALSE),
       ('fr_YT','French (Mayotte)',FALSE),
       ('fr_MC','French (Monaco)',FALSE),
       ('fr_MA','French (Morocco)',FALSE),
       ('fr_NC','French (New Caledonia)',FALSE),
       ('fr_NE','French (Niger)',FALSE),
       ('fr_RE','French (Réunion)',FALSE),
       ('fr_RW','French (Rwanda)',FALSE),
       ('fr_SN','French (Senegal)',FALSE),
       ('fr_SC','French (Seychelles)',FALSE),
       ('fr_BL','French (St. Barthélemy)',FALSE),
       ('fr_MF','French (St. Martin)',FALSE),
       ('fr_PM','French (St. Pierre & Miquelon)',FALSE),
       ('fr_CH','French (Switzerland)',FALSE),
       ('fr_SY','French (Syria)',FALSE),
       ('fr_TG','French (Togo)',FALSE),
       ('fr_TN','French (Tunisia)',FALSE),
       ('fr_VU','French (Vanuatu)',FALSE),
       ('fr_WF','French (Wallis & Futuna)',FALSE),
       ('ff','Fulah',FALSE),
       ('ff_CM','Fulah (Cameroon)',FALSE),
       ('ff_GN','Fulah (Guinea)',FALSE),
       ('ff_MR','Fulah (Mauritania)',FALSE),
       ('ff_SN','Fulah (Senegal)',FALSE),
       ('gl','Galician',FALSE),
       ('gl_ES','Galician (Spain)',FALSE),
       ('lg','Ganda',FALSE),
       ('lg_UG','Ganda (Uganda)',FALSE),
       ('ka','Georgian',FALSE),
       ('ka_GE','Georgian (Georgia)',FALSE),
       ('de','German',FALSE),
       ('de_AT','German (Austria)',FALSE),
       ('de_BE','German (Belgium)',FALSE),
       ('de_DE','German (Germany)',FALSE),
       ('de_LI','German (Liechtenstein)',FALSE),
       ('de_LU','German (Luxembourg)',FALSE),
       ('de_CH','German (Switzerland)',FALSE),
       ('el','Greek',FALSE),
       ('el_CY','Greek (Cyprus)',FALSE),
       ('el_GR','Greek (Greece)',FALSE),
       ('gu','Gujarati',FALSE),
       ('gu_IN','Gujarati (India)',FALSE),
       ('ha','Hausa',FALSE),
       ('ha_GH','Hausa (Ghana)',FALSE),
       ('ha_Latn_GH','Hausa (Latin, Ghana)',FALSE),
       ('ha_Latn_NE','Hausa (Latin, Niger)',FALSE),
       ('ha_Latn_NG','Hausa (Latin, Nigeria)',FALSE),
       ('ha_Latn','Hausa (Latin)',FALSE),
       ('ha_NE','Hausa (Niger)',FALSE),
       ('ha_NG','Hausa (Nigeria)',FALSE),
       ('he','Hebrew',FALSE),
       ('he_IL','Hebrew (Israel)',FALSE),
       ('hi','Hindi',FALSE),
       ('hi_IN','Hindi (India)',FALSE),
       ('hu','Hungarian',FALSE),
       ('hu_HU','Hungarian (Hungary)',FALSE),
       ('is','Icelandic',FALSE),
       ('is_IS','Icelandic (Iceland)',FALSE),
       ('ig','Igbo',FALSE),
       ('ig_NG','Igbo (Nigeria)',FALSE),
       ('id','Indonesian',FALSE),
       ('id_ID','Indonesian (Indonesia)',FALSE),
       ('ga','Irish',FALSE),
       ('ga_IE','Irish (Ireland)',FALSE),
       ('it','Italian',FALSE),
       ('it_IT','Italian (Italy)',FALSE),
       ('it_SM','Italian (San Marino)',FALSE),
       ('it_CH','Italian (Switzerland)',FALSE),
       ('ja','Japanese',FALSE),
       ('ja_JP','Japanese (Japan)',FALSE),
       ('kl','Kalaallisut',FALSE),
       ('kl_GL','Kalaallisut (Greenland)',FALSE),
       ('kn','Kannada',FALSE),
       ('kn_IN','Kannada (India)',FALSE),
       ('ks','Kashmiri',FALSE),
       ('ks_Arab_IN','Kashmiri (Arabic, India)',FALSE),
       ('ks_Arab','Kashmiri (Arabic)',FALSE),
       ('ks_IN','Kashmiri (India)',FALSE),
       ('kk','Kazakh',FALSE),
       ('kk_Cyrl_KZ','Kazakh (Cyrillic, Kazakhstan)',FALSE),
       ('kk_Cyrl','Kazakh (Cyrillic)',FALSE),
       ('kk_KZ','Kazakh (Kazakhstan)',FALSE),
       ('km','Khmer',FALSE),
       ('km_KH','Khmer (Cambodia)',FALSE),
       ('ki','Kikuyu',FALSE),
       ('ki_KE','Kikuyu (Kenya)',FALSE),
       ('rw','Kinyarwanda',FALSE),
       ('rw_RW','Kinyarwanda (Rwanda)',FALSE),
       ('ko','Korean',FALSE),
       ('ko_KP','Korean (North Korea)',FALSE),
       ('ko_KR','Korean (South Korea)',FALSE),
       ('ky','Kyrgyz',FALSE),
       ('ky_Cyrl_KG','Kyrgyz (Cyrillic, Kyrgyzstan)',FALSE),
       ('ky_Cyrl','Kyrgyz (Cyrillic)',FALSE),
       ('ky_KG','Kyrgyz (Kyrgyzstan)',FALSE),
       ('lo','Lao',FALSE),
       ('lo_LA','Lao (Laos)',FALSE),
       ('lv','Latvian',FALSE),
       ('lv_LV','Latvian (Latvia)',FALSE),
       ('ln','Lingala',FALSE),
       ('ln_AO','Lingala (Angola)',FALSE),
       ('ln_CF','Lingala (Central African Republic)',FALSE),
       ('ln_CG','Lingala (Congo - Brazzaville)',FALSE),
       ('ln_CD','Lingala (Congo - Kinshasa)',FALSE),
       ('lt','Lithuanian',FALSE),
       ('lt_LT','Lithuanian (Lithuania)',FALSE),
       ('lu','Luba-Katanga',FALSE),
       ('lu_CD','Luba-Katanga (Congo - Kinshasa)',FALSE),
       ('lb','Luxembourgish',FALSE),
       ('lb_LU','Luxembourgish (Luxembourg)',FALSE),
       ('mk','Macedonian',FALSE),
       ('mk_MK','Macedonian (Macedonia)',FALSE),
       ('mg','Malagasy',FALSE),
       ('mg_MG','Malagasy (Madagascar)',FALSE),
       ('ms','Malay',FALSE),
       ('ms_BN','Malay (Brunei)',FALSE),
       ('ms_Latn_BN','Malay (Latin, Brunei)',FALSE),
       ('ms_Latn_MY','Malay (Latin, Malaysia)',FALSE),
       ('ms_Latn_SG','Malay (Latin, Singapore)',FALSE),
       ('ms_Latn','Malay (Latin)',FALSE),
       ('ms_MY','Malay (Malaysia)',FALSE),
       ('ms_SG','Malay (Singapore)',FALSE),
       ('ml','Malayalam',FALSE),
       ('ml_IN','Malayalam (India)',FALSE),
       ('mt','Maltese',FALSE),
       ('mt_MT','Maltese (Malta)',FALSE),
       ('gv','Manx',FALSE),
       ('gv_IM','Manx (Isle of Man)',FALSE),
       ('mr','Marathi',FALSE),
       ('mr_IN','Marathi (India)',FALSE),
       ('mn','Mongolian',FALSE),
       ('mn_Cyrl_MN','Mongolian (Cyrillic, Mongolia)',FALSE),
       ('mn_Cyrl','Mongolian (Cyrillic)',FALSE),
       ('mn_MN','Mongolian (Mongolia)',FALSE),
       ('ne','Nepali',FALSE),
       ('ne_IN','Nepali (India)',FALSE),
       ('ne_NP','Nepali (Nepal)',FALSE),
       ('nd','North Ndebele',FALSE),
       ('nd_ZW','North Ndebele (Zimbabwe)',FALSE),
       ('se','Northern Sami',FALSE),
       ('se_FI','Northern Sami (Finland)',FALSE),
       ('se_NO','Northern Sami (Norway)',FALSE),
       ('se_SE','Northern Sami (Sweden)',FALSE),
       ('no','Norwegian',FALSE),
       ('no_NO','Norwegian (Norway)',FALSE),
       ('nb','Norwegian Bokmål',FALSE),
       ('nb_NO','Norwegian Bokmål (Norway)',FALSE),
       ('nb_SJ','Norwegian Bokmål (Svalbard & Jan Mayen)',FALSE),
       ('nn','Norwegian Nynorsk',FALSE),
       ('nn_NO','Norwegian Nynorsk (Norway)',FALSE),
       ('or','Oriya',FALSE),
       ('or_IN','Oriya (India)',FALSE),
       ('om','Oromo',FALSE),
       ('om_ET','Oromo (Ethiopia)',FALSE),
       ('om_KE','Oromo (Kenya)',FALSE),
       ('os','Ossetic',FALSE),
       ('os_GE','Ossetic (Georgia)',FALSE),
       ('os_RU','Ossetic (Russia)',FALSE),
       ('ps','Pashto',FALSE),
       ('ps_AF','Pashto (Afghanistan)',FALSE),
       ('fa','Persian',FALSE),
       ('fa_AF','Persian (Afghanistan)',FALSE),
       ('fa_IR','Persian (Iran)',FALSE),
       ('pl','Polish',FALSE),
       ('pl_PL','Polish (Poland)',FALSE),
       ('pt','Portuguese',FALSE),
       ('pt_AO','Portuguese (Angola)',FALSE),
       ('pt_BR','Portuguese (Brazil)',FALSE),
       ('pt_CV','Portuguese (Cape Verde)',FALSE),
       ('pt_GW','Portuguese (Guinea-Bissau)',FALSE),
       ('pt_MO','Portuguese (Macau SAR China)',FALSE),
       ('pt_MZ','Portuguese (Mozambique)',FALSE),
       ('pt_PT','Portuguese (Portugal)',FALSE),
       ('pt_ST','Portuguese (São Tomé & Príncipe)',FALSE),
       ('pt_TL','Portuguese (Timor-Leste)',FALSE),
       ('pa','Punjabi',FALSE),
       ('pa_Arab_PK','Punjabi (Arabic, Pakistan)',FALSE),
       ('pa_Arab','Punjabi (Arabic)',FALSE),
       ('pa_Guru_IN','Punjabi (Gurmukhi, India)',FALSE),
       ('pa_Guru','Punjabi (Gurmukhi)',FALSE),
       ('pa_IN','Punjabi (India)',FALSE),
       ('pa_PK','Punjabi (Pakistan)',FALSE),
       ('qu','Quechua',FALSE),
       ('qu_BO','Quechua (Bolivia)',FALSE),
       ('qu_EC','Quechua (Ecuador)',FALSE),
       ('qu_PE','Quechua (Peru)',FALSE),
       ('ro','Romanian',FALSE),
       ('ro_MD','Romanian (Moldova)',FALSE),
       ('ro_RO','Romanian (Romania)',FALSE),
       ('rm','Romansh',FALSE),
       ('rm_CH','Romansh (Switzerland)',FALSE),
       ('rn','Rundi',FALSE),
       ('rn_BI','Rundi (Burundi)',FALSE),
       ('ru','Russian',FALSE),
       ('ru_BY','Russian (Belarus)',FALSE),
       ('ru_KZ','Russian (Kazakhstan)',FALSE),
       ('ru_KG','Russian (Kyrgyzstan)',FALSE),
       ('ru_MD','Russian (Moldova)',FALSE),
       ('ru_RU','Russian (Russia)',FALSE),
       ('ru_UA','Russian (Ukraine)',FALSE),
       ('sg','Sango',FALSE),
       ('sg_CF','Sango (Central African Republic)',FALSE),
       ('gd','Scottish Gaelic',FALSE),
       ('gd_GB','Scottish Gaelic (United Kingdom)',FALSE),
       ('sr','Serbian',FALSE),
       ('sr_BA','Serbian (Bosnia & Herzegovina)',FALSE),
       ('sr_Cyrl_BA','Serbian (Cyrillic, Bosnia & Herzegovina)',FALSE),
       ('sr_Cyrl_XK','Serbian (Cyrillic, Kosovo)',FALSE),
       ('sr_Cyrl_ME','Serbian (Cyrillic, Montenegro)',FALSE),
       ('sr_Cyrl_RS','Serbian (Cyrillic, Serbia)',FALSE),
       ('sr_Cyrl','Serbian (Cyrillic)',FALSE),
       ('sr_XK','Serbian (Kosovo)',FALSE),
       ('sr_Latn_BA','Serbian (Latin, Bosnia & Herzegovina)',FALSE),
       ('sr_Latn_XK','Serbian (Latin, Kosovo)',FALSE),
       ('sr_Latn_ME','Serbian (Latin, Montenegro)',FALSE),
       ('sr_Latn_RS','Serbian (Latin, Serbia)',FALSE),
       ('sr_Latn','Serbian (Latin)',FALSE),
       ('sr_ME','Serbian (Montenegro)',FALSE),
       ('sr_RS','Serbian (Serbia)',FALSE),
       ('sh','Serbo-Croatian',FALSE),
       ('sh_BA','Serbo-Croatian (Bosnia & Herzegovina)',FALSE),
       ('sn','Shona',FALSE),
       ('sn_ZW','Shona (Zimbabwe)',FALSE),
       ('ii','Sichuan Yi',FALSE),
       ('ii_CN','Sichuan Yi (China)',FALSE),
       ('si','Sinhala',FALSE),
       ('si_LK','Sinhala (Sri Lanka)',FALSE),
       ('sk','Slovak',FALSE),
       ('sk_SK','Slovak (Slovakia)',FALSE),
       ('sl','Slovenian',FALSE),
       ('sl_SI','Slovenian (Slovenia)',FALSE),
       ('so','Somali',FALSE),
       ('so_DJ','Somali (Djibouti)',FALSE),
       ('so_ET','Somali (Ethiopia)',FALSE),
       ('so_KE','Somali (Kenya)',FALSE),
       ('so_SO','Somali (Somalia)',FALSE),
       ('es','Spanish',FALSE),
       ('es_AR','Spanish (Argentina)',FALSE),
       ('es_BO','Spanish (Bolivia)',FALSE),
       ('es_IC','Spanish (Canary Islands)',FALSE),
       ('es_EA','Spanish (Ceuta & Melilla)',FALSE),
       ('es_CL','Spanish (Chile)',FALSE),
       ('es_CO','Spanish (Colombia)',FALSE),
       ('es_CR','Spanish (Costa Rica)',FALSE),
       ('es_CU','Spanish (Cuba)',FALSE),
       ('es_DO','Spanish (Dominican Republic)',FALSE),
       ('es_EC','Spanish (Ecuador)',FALSE),
       ('es_SV','Spanish (El Salvador)',FALSE),
       ('es_GQ','Spanish (Equatorial Guinea)',FALSE),
       ('es_GT','Spanish (Guatemala)',FALSE),
       ('es_HN','Spanish (Honduras)',FALSE),
       ('es_MX','Spanish (Mexico)',FALSE),
       ('es_NI','Spanish (Nicaragua)',FALSE),
       ('es_PA','Spanish (Panama)',FALSE),
       ('es_PY','Spanish (Paraguay)',FALSE),
       ('es_PE','Spanish (Peru)',FALSE),
       ('es_PH','Spanish (Philippines)',FALSE),
       ('es_PR','Spanish (Puerto Rico)',FALSE),
       ('es_ES','Spanish (Spain)',FALSE),
       ('es_US','Spanish (United States)',FALSE),
       ('es_UY','Spanish (Uruguay)',FALSE),
       ('es_VE','Spanish (Venezuela)',FALSE),
       ('sw','Swahili',FALSE),
       ('sw_KE','Swahili (Kenya)',FALSE),
       ('sw_TZ','Swahili (Tanzania)',FALSE),
       ('sw_UG','Swahili (Uganda)',FALSE),
       ('sv','Swedish',FALSE),
       ('sv_AX','Swedish (Åland Islands)',FALSE),
       ('sv_FI','Swedish (Finland)',FALSE),
       ('sv_SE','Swedish (Sweden)',FALSE),
       ('tl','Tagalog',FALSE),
       ('tl_PH','Tagalog (Philippines)',FALSE),
       ('ta','Tamil',FALSE),
       ('ta_IN','Tamil (India)',FALSE),
       ('ta_MY','Tamil (Malaysia)',FALSE),
       ('ta_SG','Tamil (Singapore)',FALSE),
       ('ta_LK','Tamil (Sri Lanka)',FALSE),
       ('te','Telugu',FALSE),
       ('te_IN','Telugu (India)',FALSE),
       ('th','Thai',FALSE),
       ('th_TH','Thai (Thailand)',FALSE),
       ('bo','Tibetan',FALSE),
       ('bo_CN','Tibetan (China)',FALSE),
       ('bo_IN','Tibetan (India)',FALSE),
       ('ti','Tigrinya',FALSE),
       ('ti_ER','Tigrinya (Eritrea)',FALSE),
       ('ti_ET','Tigrinya (Ethiopia)',FALSE),
       ('to','Tongan',FALSE),
       ('to_TO','Tongan (Tonga)',FALSE),
       ('tr','Turkish',FALSE),
       ('tr_CY','Turkish (Cyprus)',FALSE),
       ('tr_TR','Turkish (Turkey)',FALSE),
       ('uk','Ukrainian',FALSE),
       ('uk_UA','Ukrainian (Ukraine)',FALSE),
       ('ur','Urdu',FALSE),
       ('ur_IN','Urdu (India)',FALSE),
       ('ur_PK','Urdu (Pakistan)',FALSE),
       ('ug','Uyghur',FALSE),
       ('ug_Arab_CN','Uyghur (Arabic, China)',FALSE),
       ('ug_Arab','Uyghur (Arabic)',FALSE),
       ('ug_CN','Uyghur (China)',FALSE),
       ('uz','Uzbek',FALSE),
       ('uz_AF','Uzbek (Afghanistan)',FALSE),
       ('uz_Arab_AF','Uzbek (Arabic, Afghanistan)',FALSE),
       ('uz_Arab','Uzbek (Arabic)',FALSE),
       ('uz_Cyrl_UZ','Uzbek (Cyrillic, Uzbekistan)',FALSE),
       ('uz_Cyrl','Uzbek (Cyrillic)',FALSE),
       ('uz_Latn_UZ','Uzbek (Latin, Uzbekistan)',FALSE),
       ('uz_Latn','Uzbek (Latin)',FALSE),
       ('uz_UZ','Uzbek (Uzbekistan)',FALSE),
       ('vi','Vietnamese',FALSE),
       ('vi_VN','Vietnamese (Vietnam)',FALSE),
       ('cy','Welsh',FALSE),
       ('cy_GB','Welsh (United Kingdom)',FALSE),
       ('fy','Western Frisian',FALSE),
       ('fy_NL','Western Frisian (Netherlands)',FALSE),
       ('yi','Yiddish',FALSE),
       ('yo','Yoruba',FALSE),
       ('yo_BJ','Yoruba (Benin)',FALSE),
       ('yo_NG','Yoruba (Nigeria)',FALSE),
       ('zu','Zulu',FALSE),
       ('zu_ZA','Zulu (South Africa)',FALSE)
ON CONFLICT (locale_code)
    DO NOTHING;

INSERT INTO nc_attributes(attr_id, name, description, tooltip, is_multiple, properties, attr_type_id, list_id, attr_type_def_id, system_name)
VALUES  ('11111111-1111-1111-1111-111111111111', 'Name', NULL, NULL, false, NULL, 0, NULL, NULL, 'system-name'),
        ('22222222-2222-2222-2222-222222222222', 'Description', NULL, NULL, false, NULL, 1, NULL, NULL, 'system-description'),
        ('33333333-3333-3333-3333-333333333333', 'Created By', NULL, NULL, false, NULL, 0, NULL, NULL, 'system-created-by'),
        ('44444444-4444-4444-4444-444444444444', 'Created When', NULL, NULL, false, NULL, 4, NULL, NULL, 'system-created-when'),
        ('55555555-5555-5555-5555-555555555555', 'Modified When', NULL, NULL, false, NULL, 4, NULL, NULL, 'system-modified-when'),
        ('66666666-6666-6666-6666-666666666666', 'Type', NULL, NULL, false, NULL, 0, NULL, NULL, 'system-type'),
        ('77777777-7777-7777-7777-777777777777', 'Name', NULL, NULL, false, NULL, 9, NULL, NULL, 'system-name-ref'),
        ('88888888-8888-8888-8888-888888888888', 'Order Number', NULL, NULL, false, NULL, 0, NULL, NULL, 'system-order-number'),
        ('18ca5bc8-f41e-ffd2-ec81-6f5e58f434e7', 'Url', NULL, NULL, false, NULL, 0, NULL, NULL, 'resource-url'),
        ('afedd9b3-6658-0052-1f5a-8c01e75a2f0d', 'Icon', NULL, NULL, false, NULL, 0, NULL, NULL, 'icon')
ON CONFLICT (attr_id)
    DO NOTHING;


INSERT INTO nc_attr_object_types (attr_id, object_type_id, default_value, is_required, is_binded) VALUES
('18ca5bc8-f41e-ffd2-ec81-6f5e58f434e7', '639425d8-cdc4-1b61-1d33-c7ba2a7fc2bc', NULL, false, true),
('afedd9b3-6658-0052-1f5a-8c01e75a2f0d', 'a2001f0d-c4a2-6f50-716c-39c1f02ea19e', NULL, false, true)
ON CONFLICT (attr_id, object_type_id) DO NOTHING;
