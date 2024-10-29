@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Student Base View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@Metadata.allowExtensions: true
@OData.publish: true

define root view entity ZR_STUDENT
  as select from zda_a_stdnt
  association to ZI_GENDER                 as _Gender on $projection.Gender = _Gender.Value
  composition [0..*] of ZR_ACADEMIC_RESULT as _Academicres
{

      @EndUserText.label: 'Student ID'
  key id                  as Id,
      @EndUserText.label: 'First Name'
      firstname           as FirstName,
      @EndUserText.label: 'Last Name'
      lastname            as LastName,
      @EndUserText.label: 'Age'
      age                 as Age,
      @EndUserText.label: 'Course'
      course              as Course,
      @EndUserText.label: 'Course Duration'
      courseduration      as CourseDuration,
      @EndUserText.label: 'Status'
      studentstatus       as Status,
      @EndUserText.label: 'Gender'
      gender              as Gender,
      @EndUserText.label: 'DOB'
      dob                 as Dob,
      lastchangedat,
      locallastchangedat,

      _Gender,
      _Gender.Description as GenderDesc,
      _Academicres
}
