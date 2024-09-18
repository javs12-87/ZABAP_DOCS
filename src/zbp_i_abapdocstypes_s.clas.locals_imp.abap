CLASS LHC_RAP_TDAT_CTS DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      GET
        RETURNING
          VALUE(RESULT) TYPE REF TO IF_MBC_CP_RAP_TABLE_CTS.

ENDCLASS.

CLASS LHC_RAP_TDAT_CTS IMPLEMENTATION.
  METHOD GET.
    result = mbc_cp_api=>rap_table_cts( table_entity_relations = VALUE #(
                                         ( entity = 'AbapDocsTypes' table = 'ZDOC_TYPE' )
                                         ( entity = 'AbapDocsTypesText' table = 'ZDOC_TYPE_TXT' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_ABAPDOCSTYPES_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR AbapDocsTypesAll
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION AbapDocsTypesAll~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR AbapDocsTypesAll
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_ABAPDOCSTYPES_S IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
    DATA: selecttransport_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled,
          edit_flag            TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.

    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
        iv_objectname = 'ZDOC_TYPE'
        iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    DATA(transport_service) = cl_bcfg_cd_reuse_api_factory=>get_transport_service_instance(
                                iv_objectname = 'ZDOC_TYPE'
                                iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table ).
    IF transport_service->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    READ ENTITIES OF ZI_AbapDocsTypes_S IN LOCAL MODE
    ENTITY AbapDocsTypesAll
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(all).
    IF all[ 1 ]-%IS_DRAFT = if_abap_behv=>mk-off.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result = VALUE #( (
               %TKY = all[ 1 ]-%TKY
               %ACTION-edit = edit_flag
               %ASSOC-_AbapDocsTypes = edit_flag
               %ACTION-SelectCustomizingTransptReq = selecttransport_flag ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
    MODIFY ENTITIES OF ZI_AbapDocsTypes_S IN LOCAL MODE
      ENTITY AbapDocsTypesAll
        UPDATE FIELDS ( TransportRequestID HideTransport )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                          HideTransport      = abap_false ) ).

    READ ENTITIES OF ZI_AbapDocsTypes_S IN LOCAL MODE
      ENTITY AbapDocsTypesAll
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_ABAPDOCSTYPES' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%UPDATE      = is_authorized.
    result-%ACTION-Edit = is_authorized.
    result-%ACTION-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
ENDCLASS.
CLASS LSC_ZI_ABAPDOCSTYPES_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION,
      CLEANUP_FINALIZE REDEFINITION.
ENDCLASS.

CLASS LSC_ZI_ABAPDOCSTYPES_S IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
    READ TABLE update-AbapDocsTypesAll INDEX 1 INTO DATA(all).
    IF all-TransportRequestID IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes(
                                  transport_request = all-TransportRequestID
                                  create            = REF #( create )
                                  update            = REF #( update )
                                  delete            = REF #( delete ) ).
    ENDIF.
  ENDMETHOD.
  METHOD CLEANUP_FINALIZE ##NEEDED.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_ABAPDOCSTYPESTEXT DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR AbapDocsTypesText~ValidateTransportRequest,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR AbapDocsTypesText
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_ABAPDOCSTYPESTEXT IMPLEMENTATION.
  METHOD VALIDATETRANSPORTREQUEST.
    DATA change TYPE REQUEST FOR CHANGE ZI_AbapDocsTypes_S.
    SELECT SINGLE TransportRequestID
      FROM ZDOC_TYPE_D_S
      WHERE SingletonID = 1
      INTO @DATA(TransportRequestID).
    lhc_rap_tdat_cts=>get( )->validate_changes(
                                transport_request = TransportRequestID
                                table             = 'ZDOC_TYPE_TXT'
                                keys              = REF #( keys )
                                reported          = REF #( reported )
                                failed            = REF #( failed )
                                change            = REF #( change-AbapDocsTypesText ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
         iv_objectname = 'ZDOC_TYPE_TXT'
         iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%DELETE = edit_flag.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_ABAPDOCSTYPES DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR AbapDocsTypes~ValidateTransportRequest,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR AbapDocsTypes
        RESULT result,
      COPYABAPDOCSTYPES FOR MODIFY
        IMPORTING
          KEYS FOR ACTION AbapDocsTypes~CopyAbapDocsTypes,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR AbapDocsTypes
        RESULT result,
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR AbapDocsTypes
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_ABAPDOCSTYPES IMPLEMENTATION.
  METHOD VALIDATETRANSPORTREQUEST.
    DATA change TYPE REQUEST FOR CHANGE ZI_AbapDocsTypes_S.
    SELECT SINGLE TransportRequestID
      FROM ZDOC_TYPE_D_S
      WHERE SingletonID = 1
      INTO @DATA(TransportRequestID).
    lhc_rap_tdat_cts=>get( )->validate_changes(
                                transport_request = TransportRequestID
                                table             = 'ZDOC_TYPE'
                                keys              = REF #( keys )
                                reported          = REF #( reported )
                                failed            = REF #( failed )
                                change            = REF #( change-AbapDocsTypes ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
         iv_objectname = 'ZDOC_TYPE'
         iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%DELETE = edit_flag.
    result-%ASSOC-_AbapDocsTypesText = edit_flag.
  ENDMETHOD.
  METHOD COPYABAPDOCSTYPES.
    DATA new_AbapDocsTypes TYPE TABLE FOR CREATE ZI_AbapDocsTypes_S\_AbapDocsTypes.
    DATA new_AbapDocsTypesText TYPE TABLE FOR CREATE ZI_AbapDocsTypes_S\\AbapDocsTypes\_AbapDocsTypesText.

    IF lines( keys ) > 1.
      INSERT mbc_cp_api=>message( )->get_select_only_one_entry( ) INTO TABLE reported-%other.
      failed-AbapDocsTypes = VALUE #( FOR fkey IN keys ( %TKY = fkey-%TKY ) ).
      RETURN.
    ENDIF.

    READ ENTITIES OF ZI_AbapDocsTypes_S IN LOCAL MODE
      ENTITY AbapDocsTypes
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(ref_AbapDocsTypes)
        FAILED DATA(read_failed).
    READ ENTITIES OF ZI_AbapDocsTypes_S IN LOCAL MODE
      ENTITY AbapDocsTypes BY \_AbapDocsTypesText
        ALL FIELDS WITH CORRESPONDING #( ref_AbapDocsTypes )
        RESULT DATA(ref_AbapDocsTypesText).

    IF ref_AbapDocsTypes IS NOT INITIAL.
      ASSIGN ref_AbapDocsTypes[ 1 ] TO FIELD-SYMBOL(<ref_AbapDocsTypes>).
      DATA(key) = keys[ KEY draft %TKY = <ref_AbapDocsTypes>-%TKY ].
      DATA(key_cid) = key-%CID.
      APPEND VALUE #(
        %TKY-SingletonID = 1
        %IS_DRAFT = <ref_AbapDocsTypes>-%IS_DRAFT
        %TARGET = VALUE #( (
          %CID = key_cid
          %IS_DRAFT = <ref_AbapDocsTypes>-%IS_DRAFT
          %DATA = CORRESPONDING #( <ref_AbapDocsTypes> EXCEPT
          SingletonID
          LastChangedAt
          LocalLastChangedAt
        ) ) )
      ) TO new_AbapDocsTypes ASSIGNING FIELD-SYMBOL(<new_AbapDocsTypes>).
      <new_AbapDocsTypes>-%TARGET[ 1 ]-Objecttype = key-%PARAM-Objecttype.
      FIELD-SYMBOLS <new_AbapDocsTypesText> LIKE LINE OF new_AbapDocsTypesText.
      UNASSIGN <new_AbapDocsTypesText>.
      LOOP AT ref_AbapDocsTypesText ASSIGNING FIELD-SYMBOL(<ref_AbapDocsTypesText>).
        DATA(cid_ref_AbapDocsTypesText) = key_cid.
        IF <new_AbapDocsTypesText> IS NOT ASSIGNED.
          INSERT VALUE #( %CID_REF  = cid_ref_AbapDocsTypesText
                          %IS_DRAFT = key-%IS_DRAFT ) INTO TABLE new_AbapDocsTypesText ASSIGNING <new_AbapDocsTypesText>.
        ENDIF.
        INSERT VALUE #( %IS_DRAFT = key-%IS_DRAFT
                        %DATA = CORRESPONDING #( <ref_AbapDocsTypesText> EXCEPT
                                                 SingletonID
                                                 LocalLastChangedAt
        ) ) INTO TABLE <new_AbapDocsTypesText>-%target ASSIGNING FIELD-SYMBOL(<target_AbapDocsTypesText>).
        <target_AbapDocsTypesText>-%KEY-Objecttype = key-%PARAM-Objecttype.
        <target_AbapDocsTypesText>-%cid = 'AbapDocsTypesText'
          && |#{ <ref_AbapDocsTypesText>-%KEY-Langu }|
          && |#{ <ref_AbapDocsTypesText>-%KEY-Objecttype }|.
      ENDLOOP.

      MODIFY ENTITIES OF ZI_AbapDocsTypes_S IN LOCAL MODE
        ENTITY AbapDocsTypesAll CREATE BY \_AbapDocsTypes
        FIELDS (
                 Objecttype
               ) WITH new_AbapDocsTypes
        ENTITY AbapDocsTypes CREATE BY \_AbapDocsTypesText
        FIELDS (
                 Langu
                 Objecttype
                 Description
               ) WITH new_AbapDocsTypesText
        MAPPED DATA(mapped_create)
        FAILED failed
        REPORTED reported.

      mapped-AbapDocsTypes = mapped_create-AbapDocsTypes.
    ENDIF.

    INSERT LINES OF read_failed-AbapDocsTypes INTO TABLE failed-AbapDocsTypes.

    IF failed-AbapDocsTypes IS INITIAL.
      reported-AbapDocsTypes = VALUE #( FOR created IN mapped-AbapDocsTypes (
                                                 %CID = created-%CID
                                                 %ACTION-CopyAbapDocsTypes = if_abap_behv=>mk-on
                                                 %MSG = mbc_cp_api=>message( )->get_item_copied( )
                                                 %PATH-AbapDocsTypesAll-%IS_DRAFT = created-%IS_DRAFT
                                                 %PATH-AbapDocsTypesAll-SingletonID = 1 ) ).
    ENDIF.
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_ABAPDOCSTYPES' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%ACTION-CopyAbapDocsTypes = is_authorized.
  ENDMETHOD.
  METHOD GET_INSTANCE_FEATURES.
    result = VALUE #( FOR row IN keys ( %TKY = row-%TKY
                                        %ACTION-CopyAbapDocsTypes = COND #( WHEN row-%IS_DRAFT = if_abap_behv=>mk-off THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
    ) ).
  ENDMETHOD.
ENDCLASS.
