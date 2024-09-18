@EndUserText.label: 'ABAP Docs Types'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_AbapDocsTypes
  as select from ZDOC_TYPE
  association to parent ZI_AbapDocsTypes_S as _AbapDocsTypesAll on $projection.SingletonID = _AbapDocsTypesAll.SingletonID
  composition [0..*] of ZI_AbapDocsTypesText as _AbapDocsTypesText
{
  key OBJECTTYPE as Objecttype,
  @Semantics.systemDateTime.lastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  1 as SingletonID,
  _AbapDocsTypesAll,
  _AbapDocsTypesText
  
}
