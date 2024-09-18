@EndUserText.label: 'Maintain ABAP Docs Types Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZC_AbapDocsTypes_S
  provider contract transactional_query
  as projection on ZI_AbapDocsTypes_S
{
  key SingletonID,
  LastChangedAtMax,
  TransportRequestID,
  HideTransport,
  _AbapDocsTypes : redirected to composition child ZC_AbapDocsTypes
  
}
