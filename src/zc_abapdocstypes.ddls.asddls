@EndUserText.label: 'Maintain ABAP Docs Types'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_AbapDocsTypes
  as projection on ZI_AbapDocsTypes
{
  key Objecttype,
  LastChangedAt,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _AbapDocsTypesAll : redirected to parent ZC_AbapDocsTypes_S,
  _AbapDocsTypesText : redirected to composition child ZC_AbapDocsTypesText,
  _AbapDocsTypesText.Description : localized
  
}
