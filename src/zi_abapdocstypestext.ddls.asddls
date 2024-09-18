@EndUserText.label: 'ABAP Docs Types Text'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.dataCategory: #TEXT
define view entity ZI_AbapDocsTypesText
  as select from ZDOC_TYPE_TXT
  association [1..1] to ZI_AbapDocsTypes_S as _AbapDocsTypesAll on $projection.SingletonID = _AbapDocsTypesAll.SingletonID
  association to parent ZI_AbapDocsTypes as _AbapDocsTypes on $projection.Objecttype = _AbapDocsTypes.Objecttype
  association [0..*] to I_LanguageText as _LanguageText on $projection.Langu = _LanguageText.LanguageCode
{
  @Semantics.language: true
  key LANGU as Langu,
  key OBJECTTYPE as Objecttype,
  @Semantics.text: true
  DESCRIPTION as Description,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  1 as SingletonID,
  _AbapDocsTypesAll,
  _AbapDocsTypes,
  _LanguageText
  
}
