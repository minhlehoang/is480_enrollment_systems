set echo on
set serveroutput on
spool E:\is480\testing.txt
------------------------------------------------------------------------------------------------
---------------------------------------------Testing--------------------------------------------
------------------------------------------------------------------------------------------------
--test if the class is full, the student will be on waitlist for that class
declare
v_error varchar2(1000);
begin
  enroll.addme(101,10110,v_error);
  enroll.addme(102,10110,v_error);
  enroll.addme(103,10110,v_error);
  enroll.addme(104,10110,v_error);
  enroll.addme(105,10110,v_error);
  enroll.addme(106,10110,v_error);
  enroll.addme(107,10110,v_error);
  enroll.addme(108,10110,v_error);
  enroll.addme(109,10110,v_error);
  enroll.addme(110,10110,v_error);
  enroll.addme(111,10110,v_error);
end;
/
--test wrong student number and wrong class number
declare
v_error varchar2(1000);
begin
  --test wrong student number
  enroll.addme(1,10110,v_error);
  --test wrong class number
  enroll.addme(102,10110,v_error);
  --test both wrong
  enroll.addme(11,11,v_error);
end;
/
--test student who doesn't meet the requirement which is lower class standing
declare
v_error varchar2(1000);
begin
  enroll.addme(101,10265,v_error);
end;
/
--test student with more than 15 units
declare
v_error varchar2(1000);
begin
  enroll.addme(105,10120,v_error);
  enroll.addme(105,10140,v_error);
  enroll.addme(105,10150,v_error);
  enroll.addme(105,10160,v_error);
  enroll.addme(105,10170,v_error);
  enroll.addme(105,10180,v_error);
end;
/
--test student with class that he has already taken / also the class that he has already taken in another section
declare
v_error varchar2(1000);
begin
  enroll.addme(104,10110,v_error);
  enroll.addme(104,10115,v_error);
end;
/
--test if student is already on waitlist
declare
v_error varchar2(1000);
begin
  enroll.addme(111,10110,v_error);
end;
/
--Enrollments table and waitlist table after running addme program
select * from enrollments;
select * from waitlist;
--test drop me unsuccesfully because the student is not enrolled in the class
execute enroll.dropme(112,10120);
--test drop me unsuccesfully because the student is not in database
execute enroll.dropme(1,10120);
--test drop me unsuccesfully because the class is not in database
execute enroll.dropme(112,1);
--test drop me unsuccesfully because the student and the class are not in database
execute enroll.dropme(1,1);
--test a successful drop me
execute enroll.dropme(101,10110);
--test a not successful drop me because of already being graded
update enrollments set grade = 'A' where snum = 103;
update enrollments set grade = 'D' where snum = 106;
select * from enrollments;
execute enroll.dropme(103,10110);
execute enroll.dropme(106,10110);
spool off