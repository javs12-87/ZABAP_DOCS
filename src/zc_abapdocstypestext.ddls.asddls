@EndUserText.label: 'Maintain ABAP Docs Types Text'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_AbapDocsTypesText
  as projection on ZI_AbapDocsTypesText
{
  @ObjectModel.text.element: [ 'LanguageName' ]
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'I_Language', 
      element: 'Language'
    }
  } ]
  key Langu,
  key Objecttype,
  Description,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _LanguageText.LanguageName : localized,
  _AbapDocsTypes : redirected to parent ZC_AbapDocsTypes,
  _AbapDocsTypesAll : redirected to ZC_AbapDocsTypes_S
  
}
