set echo on
set serveroutput on
spool E:\is480\table.txt
------------------------------------------------------------------------------------------------
---------------------------------------Creating Table-------------------------------------------
------------------------------------------------------------------------------------------------
--Drop table
drop table waitlist;
drop table enrollments;
drop table schclasses;
drop table courses;
drop table students;
drop table majors;
DROP SEQUENCE waitnum;
--create waitlist sequence number
CREATE SEQUENCE waitnum
  MINVALUE 0
  START WITH 0
  INCREMENT BY 1
  NOCACHE;
commit;
--Create table Majors
create table majors(
	major varchar2(5) primary key,
	mdesc varchar2(15));
--Insert values to table majors
insert into majors values('ACC', 'Accounting');
insert into majors values('FIN', 'Finance');
insert into majors values('IS', 'Info Sys');
insert into majors values('MKT', 'Marketing');
insert into majors values('MGT', 'Management');
commit;
--Create table Students;
create table STUDENTS 
	(snum varchar2(3) primary key,
	sname varchar2(10),
	standing number(1),
	major varchar2(3) constraint fk_students_major references majors(major),
	gpa number(2,1),
	major_gpa number(2,1));
--Insert values to table students
insert into students values ('101','Andy',3,'IS',2.8,3.2);
insert into students values ('102','Betty',3,null,3.2,null);
insert into students values ('103','Cindy',3,'IS',2.5,3.5);
insert into students values ('104','David',3,'FIN',3.3,3.0);
insert into students values ('105','Ellen',3,null,2.8,null);
insert into students values ('106','Frank',3,'MKT',3.1,2.9);
insert into students values ('107','George',3,'FIN',3.7,3.5);
insert into students values ('108','Hellen',3,'ACC',3.8,3.7);
insert into students values ('109','Ivy',3,'MKT',3.3, 2.9);
insert into students values ('110','John',3,'MGT',3.0,2.9);
insert into students values ('111','Kelly',4,'FIN',3.9,3.9);
insert into students values ('112','Louis',4,'MKT',3.8,3.2);
insert into students values ('113','Minh',4,'IS', 4.0, 4.0);
insert into students values ('114','Nathan',4,'IS',3.7,3.6);
insert into students values ('115','Oscar',4,'ACC',3.5, 3.2);
insert into students values ('116','Peter',4,'MKT',3.0,3.0);
insert into students values ('117','Queenie',4,'MGT',3.5,3.0);
insert into students values ('118','Richard',4,'MKT',3.8,3.6);
insert into students values ('119','Shawn',4,'FIN',3.0,2.5);
insert into students values ('120','Tim',4,'IS',3.3, 3.1);
commit;
--Create table Courses;
create table courses
	(dept varchar2(3) constraint fk_courses_dept references majors(major),
	cnum varchar2(3),
	ctitle varchar2(50),
	crhr number(3),
	standing number(1),
	primary key (dept,cnum));
--Insert values to table courses
insert into courses values ('IS','300','Intro to MIS',3,3);
insert into courses values ('IS','301','Business Communication',3,3);
insert into courses values ('IS','310','Business Statistics',3,3);
insert into courses values ('IS','320','Spreadsheet Modeling',3,3);
insert into courses values ('IS','340','Business Application Pro',3,3);
insert into courses values ('IS','355','Telecommunications',3,3);
insert into courses values ('IS','380','Database',3,3);
insert into courses values ('IS','385','Systems Analysis and Design',3,3);
insert into courses values ('IS','445','Internet Applications Development',3,4);
insert into courses values ('IS','456','Systems Integration and Security',3,4);
insert into courses values ('IS','457','Wireless Systems and Mobile Applications',3,4);
insert into courses values ('IS','464','Network Modeling and Simulation',3,4);
insert into courses values ('IS','470','Business Intelligence',3,4);
insert into courses values ('IS','480','Adv Database',3,4);
insert into courses values ('IS','482','Enterprise Systems',3,4);
insert into courses values ('IS','484','Electronic Commerce',3,4);
commit;
--Create table schclasses;
create table SCHCLASSES (
	callnum number(5) primary key,
	year number(4),
	semester varchar2(3),
	dept varchar2(3),
	cnum varchar2(3),
	section number(2),
	capacity number(3));
alter table schclasses 
	add constraint fk_schclasses_dept_cnum foreign key 
	(dept, cnum) references courses (dept,cnum);
--Insert values to table schclasses
insert into schclasses values (10110,2016,'FA','IS','300',1,4);
insert into schclasses values (10115,2016,'FA','IS','300',2,3);
insert into schclasses values (10120,2016,'FA','IS','301',1,4);
insert into schclasses values (10125,2016,'Fa','IS','301',2,3);
insert into schclasses values (10130,2016,'Fa','IS','310',1,4);
insert into schclasses values (10135,2016,'Fa','IS','310',2,3);
insert into schclasses values (10140,2016,'Fa','IS','320',1,4);
insert into schclasses values (10145,2016,'Fa','IS','320',2,3);
insert into schclasses values (10150,2016,'Fa','IS','340',1,4);
insert into schclasses values (10155,2016,'Fa','IS','340',2,3);
insert into schclasses values (10160,2016,'Fa','IS','355',1,4);
insert into schclasses values (10165,2016,'Fa','IS','355',2,3);
insert into schclasses values (10170,2016,'Fa','IS','380',1,4);
insert into schclasses values (10175,2016,'Fa','IS','380',2,3);
insert into schclasses values (10180,2016,'Fa','IS','385',1,4);
insert into schclasses values (10185,2016,'Fa','IS','385',2,3);
insert into schclasses values (10190,2016,'Fa','IS','445',1,4);
insert into schclasses values (10195,2016,'Fa','IS','445',2,3);
insert into schclasses values (10200,2016,'Fa','IS','456',1,4);
insert into schclasses values (10205,2016,'Fa','IS','456',2,3);
insert into schclasses values (10210,2016,'Fa','IS','457',1,4);
insert into schclasses values (10215,2016,'Fa','IS','457',2,3);
insert into schclasses values (10220,2016,'Fa','IS','464',1,4);
insert into schclasses values (10225,2016,'Fa','IS','464',2,3);
insert into schclasses values (10230,2016,'Fa','IS','470',1,4);
insert into schclasses values (10235,2016,'Fa','IS','470',2,3);
insert into schclasses values (10240,2016,'Fa','IS','480',1,4);
insert into schclasses values (10245,2016,'Fa','IS','480',2,3);
insert into schclasses values (10250,2016,'Fa','IS','482',1,4);
insert into schclasses values (10255,2016,'Fa','IS','482',2,3);
insert into schclasses values (10260,2016,'Fa','IS','484',1,4);
insert into schclasses values (10265,2016,'Fa','IS','484',2,3);
commit;
--Create table enrollments
create table ENROLLMENTS (
	snum varchar2(3) constraint fk_enrollments_snum references students(snum),
	callnum number(5) constraint fk_enrollments_callnum references schclasses(callnum),
	grade varchar2(2),
	primary key (snum, callnum));
--create table waitlist
create table waitlist(
  callnum number(8),
  waitlist_num number(3),
  snum varchar2(3),
  time date,
  constraint waitlist_pk primary key(snum, callnum),
  constraint waitlist_snum_fk foreign key(snum) references students(snum),
  constraint waitlist_callnum_fk foreign key(callnum) references schclasses(callnum)
);
--print out table structure
describe students;
describe enrollments;
describe schclasses;
describe courses;
describe waitlist;
describe majors;
--print out test data
select * from students;
select * from enrollments;
select * from schclasses;
select * from courses;
select * from waitlist;
select * from majors;

spool off