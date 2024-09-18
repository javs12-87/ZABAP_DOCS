@EndUserText.label: 'ABAP Docs Root - Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_DOCS_P
  provider contract transactional_query
  as projection on ZI_DOCS_P
{
  key Objectid,
  key Objecttype,
      Repositoryid,
      Folderid,
      /* Associations */
      _docs : redirected to composition child ZC_DOCS_C
}
