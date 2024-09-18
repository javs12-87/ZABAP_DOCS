@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ABAP Docs Root'
define root view entity ZI_DOCS_P
  as select from zdocs_p
  composition [1..*] of ZI_DOCS_C as _docs
{
  key objectid           as Objectid,
  key objecttype         as Objecttype,
      repositoryid       as Repositoryid,
      folderid           as Folderid,
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

      _docs
      //    _association_name // Make association public
}
