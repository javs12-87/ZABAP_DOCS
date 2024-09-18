@EndUserText.label: 'ABAP Docs Child - Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_DOCS_C
  as projection on ZI_DOCS_C
{
  key Objectid,
  key Objecttype,
  key Docnum,
      Doctype,
      Folderid,
      Filename,
      Mimetype,
      Attachment,
      /* Associations */
      _Parent : redirected to parent ZC_DOCS_P
}
