set echo on
set serveroutput on
spool E:\is480\setup.txt
--Minh Le
--IS 480
--Final Project
--minhhoangle1104@gmail.com
/****Way to test the program ADDME and DROPME
  declare
  v_error varchar2(1000);
  begin
    enroll.addme(student number, class number,v_error);
  end;
  /
  --Way to test the DROPME
  execute enroll.dropme(student number, class number);
****/
------------------------------------------------------------------------------------------------
--------------------------------------Start Writing Programs------------------------------------
------------------------------------------------------------------------------------------------
create or replace package Enroll is
  --1/ create valid_student procedure
  Procedure validate_student(
  p_snum in students.snum%type,
  p_error_text out varchar2);
  --2/ create valid_callnum function
  Function validate_callnum(
  p_callnum schclasses.callnum%type)
  RETURN varchar2;
  --3/ Checked if the student is already enrolled
  Procedure already_enrolled(
  p_snum in students.snum%type,
  p_callnum in enrollments.callnum%type,
  p_error_text out varchar2);
  --4/ Double Enrollment: A student cannot enroll in other section of the same course unless he/she withdraw from another section
  Procedure double_enrollment(
  p_snum in students.snum%type,
  p_callnum in enrollments.callnum%type,
  p_error_text out varchar2);
  --5/ 15-hour RULE: create procedure to test total credit hours of the student do not exceed 15 credit hours
  Procedure validate_total_credit_hour(
  p_snum enrollments.snum%type,
  p_callnum schclasses.callnum%type,
  p_error_text out varchar2);
  --6/ Standing Requirement: a student's standing must be equal or higher than the standing requirement required by the courses
  Procedure standing_requirement(
  p_snum enrollments.snum%type,
  p_callnum enrollments.callnum%type,
  p_error_text out varchar2);
  --7/ create valid_class_capacity function
  Function valid_class_capacity(
  p_callnum schclasses.callnum%type)
  return varchar2;
  -- 8/ check if the student is already on waitlist
  Procedure checkwaitlist(
  p_snum students.snum%type,
  p_callnum enrollments.callnum%type,
  p_error_msg out varchar2);
  -- 9/ waitlist and where: if this student has fulfilled all the requirements but the class is full then add place him on the waiting list.
  Procedure addme(
  p_snum students.snum%type,
  p_callnum enrollments.callnum%type,
  p_error_msg out varchar2);
  --10/ check if the student has enrolled in the classed he wants to drop or not
  Procedure enroll_or_not(
  p_snum enrollments.snum%type,
  p_callnum enrollments.callnum%type,
  p_error_text out varchar2);
  --11/ check if the student has been graded
  Procedure check_if_graded(
  p_snum enrollments.snum%type,
  p_callnum enrollments.callnum%type,
  p_error_text out varchar2);
  --12/ create procedure DROP ME
  Procedure dropme(
  p_snum enrollments.snum%type,
  p_callnum enrollments.callnum%type);
end enroll;
/
show error;

create or replace Package Body Enroll is
  --1/ create valid_student procedure
  Procedure validate_student(
    p_snum in students.snum%type,
    p_error_text out varchar2) as
    v_count number(3);
  begin
    select count(*) into v_count
    from students
    where snum=p_snum;
    if v_count = 0 then
      p_error_text:='Sorry, the student with number ' || p_snum || ' is not in our database. ';
    end if;
  end;
  --2/ create valid_callnum function
  Function validate_callnum(
    p_callnum schclasses.callnum%type)
    RETURN varchar2 as
    v_callnum number(3);
  begin
    select count(*) into v_callnum
    from schclasses
    where callnum=p_callnum;
    if v_callnum = 0 then
      return 'Class number ' || p_callnum || ' is invalid. ';
    else
      return null;
    end if;
  end;
  --3/ Checked if the student is already enrolled
  Procedure already_enrolled(
    p_snum in students.snum%type,
    p_callnum in enrollments.callnum%type,
    p_error_text out varchar2) as
    v_count number(3);
  begin
    select count(*) into v_count
    from enrollments
    where snum = p_snum
    and callnum = p_callnum;
    if v_count != 0 then
      p_error_text:='Sorry, the student with number ' || p_snum || ' already enrolled in class number ' || p_callnum || '. ';
    end if;
  end;
  --4/ Double Enrollment: A student cannot enroll in other section of the same course unless he/she withdraw from another section
  Procedure double_enrollment(
    p_snum in students.snum%type,
    p_callnum in enrollments.callnum%type,
    p_error_text out varchar2) as
    v_dept schclasses.dept%type;
    v_cnum schclasses.dept%type;
    v_count number(3);
    v_section number(2);
  begin
    --to find the dept and cnum of the class the student wants to take
    select dept, cnum into v_dept, v_cnum
    from schclasses
    where callnum=p_callnum;
    --use exception no_data_found so that if the classnum is not in the enrollments table yet, the program will not crash
    begin
      --find the section of the class already took
      select section into v_section
      from schclasses, enrollments
      where schclasses.CALLNUM=enrollments.CALLNUM
      and p_snum = enrollments.snum
      and v_dept = schclasses.dept
      and v_cnum = schclasses.cnum;
    exception
      when NO_DATA_FOUND then
        null;
      when TOO_MANY_ROWS then
        null;
    end;
    --check if the student already took the same class but different sections
    select count(*) into v_count
    from enrollments, schclasses
    where enrollments.callnum = schclasses.callnum
    and dept=v_dept
    and cnum=v_cnum
    and snum=p_snum;
    if v_count != 0 then
      p_error_text:='You are already enrolled in this class ' || v_dept || v_cnum || ' in section ' || v_section || '. ';
      --dbms_output.put_line(p_error_text);
    end if;
  end;
  --5/ 15-hour RULE: create procedure to test total credit hours of the student do not exceed 15 credit hours
  Procedure validate_total_credit_hour(
    p_snum enrollments.snum%type,
    p_callnum schclasses.callnum%type,
    p_error_text out varchar2)
    as
    v_enrollment_crhr number(3);
    v_add_crhr number(3);
  begin
    --get credit hr of course want to add
    select crhr into v_add_crhr
    from schclasses sch, courses c
    where sch.callnum=p_callnum
    and sch.dept=c.dept
    and sch.cnum=c.cnum;
    --get credit of already enrollment
    select nvl(sum(crhr),0) into v_enrollment_crhr
    from enrollments e, schclasses sch, courses c
    where e.snum = p_snum 
    and e.callnum = sch.callnum
    and sch.dept=c.dept
    and sch.cnum=c.cnum
    and grade is null;
    
    if v_add_crhr + v_enrollment_crhr <=15 then
      p_error_text:= null;
    else
      p_error_text:='Sorry, the student with the number ' || p_snum || ' have reached the total limit units. ';
    end if;
  end;
  --6/ Standing Requirement: a student's standing must be equal or higher than the standing requirement required by the courses
  Procedure standing_requirement(
    p_snum enrollments.snum%type,
    p_callnum enrollments.callnum%type,
    p_error_text out varchar2) as
    v_stu_standing number(1);
    v_callnum_standing number(1);
    v_dept schclasses.dept%type;
    v_cnum schclasses.dept%type;
  begin
    -- get standing of the student
    select standing into v_stu_standing
    from students
    where snum=p_snum;
    -- get standing of the class
    select standing, courses.dept, courses.cnum into v_callnum_standing, v_dept, v_cnum
    from courses, schclasses
    where schclasses.callnum=p_callnum
    and courses.dept=schclasses.dept
    and courses.cnum=schclasses.cnum;
    -- compare between standing of student and standing of the class
    if v_stu_standing < v_callnum_standing then
      p_error_text:='Sorry, your standing is ' || v_stu_standing || '. It is lower than the standing of the class ' || v_dept || v_cnum || ' which has standing of ' || v_callnum_standing || '. ';
    end if;
  end;
  --7/ create valid_class_capacity function
  Function valid_class_capacity(
    p_callnum schclasses.callnum%type) 
    return varchar2 as
    v_capacity number(3);
    v_snum number(3);
  begin
    --find maximum capacity of the class
    select capacity into v_capacity
    from schclasses
    where p_callnum = schclasses.callnum;
    --find current space of the class
    select count(*) into v_snum
    from enrollments
    where enrollments.callnum=p_callnum
    and grade is null;
    if v_snum < v_capacity then
      return null;
    else
      return 'Sorry this class ' || p_callnum || ' is already full. Please choose another class. ';
    end if;
  end;
  -- 8/ check if the student is already on waitlist
  Procedure checkwaitlist(
    p_snum students.snum%type,
    p_callnum enrollments.callnum%type,
    p_error_msg out varchar2) as
    v_error_text varchar(10000);
    v_count number(3);
  begin
    select count(*) into v_count
    from waitlist
    where p_snum=snum
    and p_callnum=callnum;
    if v_count != 0 then
      p_error_msg:='The student with the student number ' || p_snum || ' is already on waiting list for the class ' || p_callnum || '. ';
    end if;
  end;
  -- 9/ waitlist and where: if this student has fulfilled all the requirements but the class is full then add place him on the waiting list.
  Procedure addme(
    p_snum students.snum%type,
    p_callnum enrollments.callnum%type,
    p_error_msg out varchar2) as
    v_error_text varchar2(10000);
    v_dept varchar2(3);
    v_cnum varchar2(30);
    v_section number(2);
    v_count number(3);
  begin
    --check student validation
    validate_student(p_snum, v_error_text);
    p_error_msg:=v_error_text;
    --check valid class number
    v_error_text:=validate_callnum(p_callnum);
    p_error_msg:=p_error_msg || v_error_text;
    if p_error_msg is null then
      --get the class description and section number of p_callnum
      select courses.dept, courses.cnum, schclasses.section into v_dept, v_cnum, v_section
      from courses, schclasses
      where p_callnum = callnum
      and schclasses.dept = courses.dept
      and schclasses.cnum = courses.cnum;
      --check if the student already enrolled in the class
      already_enrolled(p_snum, p_callnum, v_error_text);
      p_error_msg:=p_error_msg || v_error_text;
      --check if the student enrolled in the class, but different section
      if p_error_msg is null then      
        double_enrollment(p_snum, p_callnum, v_error_text);
        p_error_msg:=p_error_msg || v_error_text;
      end if;
      --check standing of student, compare to the standing requirement of the class
      standing_requirement(p_snum, p_callnum, v_error_text);
      p_error_msg:=p_error_msg || v_error_text;
      --check if student have more than 15 units
      validate_total_credit_hour(p_snum, p_callnum, v_error_text);
      p_error_msg:=p_error_msg || v_error_text;
      if p_error_msg is null then
        --check if class is full or not after the student enrolls
        v_error_text:=valid_class_capacity(p_callnum);
        p_error_msg:=p_error_msg || v_error_text;
        if p_error_msg is null then
          insert into enrollments values(p_snum, p_callnum, null);
          dbms_output.put_line('Congratulation !!! ' || 'The student number ' || p_snum || ' has successfully enrolled in class ' || p_callnum || ' which is ' || v_dept || ' ' || v_cnum || ' section ' || v_section || '. ');
          commit;
        else
          --check if student is already on the waiting list
          select count(*) into v_count
          from waitlist
          where callnum=p_callnum;
          checkwaitlist(p_snum, p_callnum, v_error_text);
          p_error_msg:=v_error_text;
          if p_error_msg is null then
            v_count := v_count + 1;
            insert into waitlist values(p_callnum, waitnum.nextval, p_snum, sysdate);        
            commit;
            dbms_output.put_line('Sorry the class ' || p_callnum || ' is already full. ' || 'Student with the ID number ' || p_snum || ' is on waitlist #' || v_count || ' for class ' || p_callnum || '. ');
          else
            dbms_output.put_line(p_snum || ' is already on waitlist number #' || v_count || ' for class number ' || p_callnum || '. ');
          end if;
        end if;
      else
        dbms_output.put_line(p_error_msg);
      end if;
    else
      dbms_output.put_line(p_error_msg);
    end if;
  end;
  --10/ check if the student has enrolled in the classed he wants to drop or not
  Procedure enroll_or_not(
    p_snum enrollments.snum%type,
    p_callnum enrollments.callnum%type,
    p_error_text out varchar2) as
    v_count number(8);
  begin
    select count(*) into v_count
    from enrollments
    where p_snum = snum
    and p_callnum = callnum;
    if v_count = 0 then
      p_error_text := 'Sorry, the student with the number ' || p_snum || ' is not enrolled in ' || p_callnum || '. Please do it again.';
    end if;
  end;
  --11/ check if the student has been graded
  Procedure check_if_graded(
  p_snum enrollments.snum%type,
  p_callnum enrollments.callnum%type,
  p_error_text out varchar2) as
  v_grade enrollments.grade%type;
  v_count number(8);
  v_dept schclasses.dept%type;
  v_cnum schclasses.cnum%type;
  v_section schclasses.section%type;
  begin
    --get the dept, cnum, and section of p_callnum
    select dept, cnum, section into v_dept, v_cnum, v_section
    from schclasses
    where callnum=p_callnum;
    --get grade of the snum and callnum
    select grade into v_grade
    from enrollments
    where p_snum = snum
    and p_callnum = callnum;
    if v_grade is not null then
      p_error_text:= 'Student with number ' || p_snum || ' has received ' || v_grade || ' for class ' || p_callnum || ' which is '|| v_dept || ' ' || v_cnum || ' section ' || v_section ||'. Cannot drop!!!';
    end if;
  end;
  --12/ create procedure DROP ME
  Procedure dropme(
    p_snum enrollments.snum%type,
    p_callnum enrollments.callnum%type) as
    v_error_text varchar2(10000);
    v_error_msg varchar2(10000);
    v_count_waitlist number(8);
    v_dept schclasses.dept%type;
    v_cnum schclasses.cnum%type;
    v_section schclasses.section%type;
    cursor cwaiting is
    select *
    from waitlist
    where p_callnum=callnum
    order by waitlist_num;
  begin
    --check student validation
      validate_student(p_snum, v_error_text);
      v_error_msg:=v_error_text;
    --check valid class number
      v_error_text:=validate_callnum(p_callnum);
      v_error_msg:=v_error_msg || v_error_text;
      if v_error_msg is null then
        --check if the student not enrollment in this class
        enroll_or_not(p_snum, p_callnum, v_error_text);
        v_error_msg:= v_error_msg || v_error_text;
        if v_error_msg is null then
          check_if_graded(p_snum, p_callnum, v_error_text);
          v_error_msg := v_error_text;
          if v_error_msg is null then
          --Drop the class that the student wants
            update enrollments
            set grade = 'W'
            where p_snum = snum
            and p_callnum = callnum;
            commit;
            --get the dept, cnum, and section of p_callnum
            select dept, cnum, section into v_dept, v_cnum, v_section
            from schclasses
            where callnum=p_callnum;
            dbms_output.put_line('The student with number '|| p_snum || ' has dropped the class number ' || p_callnum || ' which is '|| v_dept || ' ' || v_cnum || ' section ' || v_section ||' succesfully. ');
          --check if there are any students in waitlist
            select count(*) into v_count_waitlist
            from waitlist
            where p_callnum = callnum;
            if v_count_waitlist != 0 then
              for each_waiting_student in cwaiting loop
                double_enrollment(each_waiting_student.snum, each_waiting_student.callnum, v_error_text);
                v_error_msg := v_error_text;
                validate_total_credit_hour(each_waiting_student.snum, each_waiting_student.callnum, v_error_text);
                v_error_msg := v_error_text || v_error_msg;
                standing_requirement(each_waiting_student.snum, each_waiting_student.callnum, v_error_text);
                v_error_msg := v_error_text || v_error_msg;
                if v_error_msg is null then
                  insert into enrollments values(each_waiting_student.snum, each_waiting_student.callnum, null);
                  commit;
                  delete from waitlist
                  where callnum = each_waiting_student.callnum
                  and snum = each_waiting_student.snum;
                  commit;
                  exit;
                end if;
              end loop;
            end if;
          else
            dbms_output.put_line(v_error_msg);
          end if;
        else
          dbms_output.put_line(v_error_msg);
        end if;
      else
        dbms_output.put_line(v_error_msg);
      end if;    
  end;
End Enroll;
/
show error;
spool off