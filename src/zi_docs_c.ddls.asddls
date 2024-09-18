@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ABAP Docs Child'
define view entity ZI_DOCS_C
  as select from zdocs_c
  association to parent ZI_DOCS_P as _Parent on  $projection.Objectid   = _Parent.Objectid
                                             and $projection.Objecttype = _Parent.Objecttype
{
  key objectid           as Objectid,
  key objecttype         as Objecttype,
  key docnum             as Docnum,
      doctype            as Doctype,
      folderid           as Folderid,
      filename           as Filename,
      @Semantics.mimeType: true
      mimetype           as Mimetype,
      @Semantics.largeObject:
      { mimeType: 'Mimetype',
      fileName: 'Filename',
      contentDispositionPreference: #INLINE }
      attachment         as Attachment,
      @Semantics.user.createdBy: true
      localcreatedby     as Localcreatedby,
      @Semantics.systemDateTime.createdAt: true
      localcreatedat     as Localcreatedat,
      @Semantics.user.lastChangedBy: true
      locallastchangedby as Locallastchangedby,
      //local ETag field --> OData ETag
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      locallastchangedat as Locallastchangedat,
      //total ETag field
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat      as Lastchangedat,

      _Parent // Make association public
}
