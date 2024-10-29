CLASS lhc_ZR_STUDENT DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zr_student RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zr_student RESULT result.

    METHODS setAdmitted FOR MODIFY
      IMPORTING keys FOR ACTION zr_student~setAdmitted RESULT result.

    METHODS UpdateCourseDuration FOR DETERMINE ON SAVE
      IMPORTING keys FOR zr_student~UpdateCourseDuration.

    METHODS validateAge FOR VALIDATE ON SAVE
      IMPORTING keys FOR zr_student~validateAge.

ENDCLASS.

CLASS lhc_ZR_STUDENT IMPLEMENTATION.

  METHOD get_instance_features.

   READ ENTITIES OF zr_student IN LOCAL MODE
   ENTITY zr_student
   FIELDS ( Status ) WITH CORRESPONDING #( keys )
   RESULT DATA(studentadmitted)
   FAILED failed.

    result = VALUE #( FOR stud IN studentadmitted
                      LET statusval = COND #( WHEN stud-Status = abap_true
                                              THEN if_abap_behv=>fc-o-disabled
                                              ELSE  if_abap_behv=>fc-o-enabled )

                                              IN ( %tky = stud-%tky
                                                   %action-setAdmitted = statusval )
    ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD setAdmitted.

    MODIFY ENTITIES OF zr_student IN LOCAL MODE
      ENTITY zr_student
      UPDATE
      FIELDS ( Status )
      WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = abap_true ) )

      FAILED failed
      REPORTED reported.

    "// Get updated record after updating info
    READ ENTITIES OF zr_student IN LOCAL MODE
    ENTITY zr_student
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(studentdata).

    result = VALUE #( FOR studentrec IN studentdata
     ( %tky = studentrec-%tky %param = studentrec )
      ).

  ENDMETHOD.

  METHOD UpdateCourseDuration.

  READ ENTITIES OF zr_student IN LOCAL MODE
  ENTITY zr_student
  FIELDS ( Course ) WITH CORRESPONDING #( keys )
  RESULT DATA(studentsCourse).

    LOOP AT studentsCourse INTO DATA(studentCourse).
      IF studentcourse-Course = 'Operating Systems'.
        MODIFY ENTITIES OF zr_student IN LOCAL MODE
        ENTITY zr_student
        UPDATE
        FIELDS ( CourseDuration ) WITH VALUE #( ( %tky = studentcourse-%tky CourseDuration = 1 ) ).
      ENDIF.

      IF studentcourse-Course = 'Computer Network'.
        MODIFY ENTITIES OF zr_student IN LOCAL MODE
        ENTITY zr_student
        UPDATE
        FIELDS ( CourseDuration ) WITH VALUE #( ( %tky = studentcourse-%tky CourseDuration = 3 ) ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateAge.

    READ ENTITIES OF zr_student IN LOCAL MODE
      ENTITY zr_student
      FIELDS ( Age ) WITH CORRESPONDING #( keys )
      RESULT DATA(studentsAge).

    LOOP AT studentsAge INTO DATA(studentAge).

      IF studentAge-Age < 18.
        APPEND VALUE #( %tky = studentage-%tky ) TO failed-zr_student.


        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                        %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text = 'Age can not be less then 18' ) )
                        TO reported-zr_student.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
