@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Academic Result Base View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@Metadata.allowExtensions: true


define view entity ZR_ACADEMIC_RESULT
  as select from zda_a_stdnt_ar
  association to parent ZR_STUDENT  as _Student  on $projection.Id = _Student.Id
  association to ZI_COURSE          as _Course   on $projection.Course = _Course.Value
  association to ZI_SEMESTER        as _Semester on $projection.Semester = _Semester.Value
  association to ZI_SEMESTER_RESULT as _Semres   on $projection.Semresult = _Semres.Value
{
  key id                    as Id,
  key course                as Course,
  key semester              as Semester,
      _Course. Description  as CourseDesc,
      _Semester.Description as SemDesc,
      semresult             as Semresult,
      _Semres.Description   as SemresDesc,
      lastchangedat,
      locallastchangedat,

      _Student
}
