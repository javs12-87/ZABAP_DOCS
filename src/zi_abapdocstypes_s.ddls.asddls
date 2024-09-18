@EndUserText.label: 'ABAP Docs Types Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_AbapDocsTypes_S
  as select from I_Language
    left outer join ZDOC_TYPE on 0 = 0
  composition [0..*] of ZI_AbapDocsTypes as _AbapDocsTypes
{
  key 1 as SingletonID,
  _AbapDocsTypes,
  max( ZDOC_TYPE.LAST_CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
