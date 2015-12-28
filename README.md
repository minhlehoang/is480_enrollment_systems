<h1 align="center">IS 480 Final Project</h1>
<h3 align="center">CALIFORNIA STATE UNIVERSITY, LONG BEACH</h3>
<h3 align="center">Advanced Database Management</h3>
<h3 align="center">Fall 2015</h3>

<h1 align="center">Project Description</h1>
<p>
	This projects require you to:
    <ol>
        <li>analyze the following requirements</li>
        <li>program the following business logic in a PL/SQL package</li>
    </ol>
</p>
<p>
    <strong>Project Assumptions</strong>
    <ol>
        <li>Each course has multiple section. Each section is referred to as a "class".</li>
        <li>Each class has a call number. Assume we do not recycle the call number.
        </li>
    </ol>
</p>
<p>
    <strong>General Requirements</strong>
    <ol>
        <li>Your table/column names should be exactly as the beachboard script; however, you may add table/columns if needed.</li>
        <li>You need to create a package called Enroll. The following 2 procedures should be stored in this package.
        </li>
        <li>The procedure name and parameters should be exactly as specified below.
        </li>
    </ol>
</p>
<h1 align="center">Program 1: The AddMe procedure</h1>
<p align="center">
    <strong>Enroll.AddMe(p_snum, p_callnum, p_errormsg)</strong>
</p>
<p>
    This procedure is to enroll a student(SNum) to a class(CallNum). The procedure has 2 IN parameters (p_snum and p_callnum) and 1 OUT parameter p_errormsg
    <ol>
        <li>Validate Student Number, Validate Call Number: If the student number or call number is invalid, the systems would print an error message and does not proceed with the following checks</li>
        <li>Already Enrolled: A student cannot enroll in the same CallNum again. The systems prints an error message if there is repeat enrollment.</li>
        <li>Double Enrollment: A student cannot enroll in other section of the same course. That is, if a student is already enrolled in IS 380 section 1, he cannot be enrolled in IS 380 section 2. </li>
        <li>15-hr Rule: A student can enroll at most 15 credit hours per semester. The system prints an error message if 15-hr rule is violated.</li>
        <li>Standing requirement: A student's standing must be equal or higher than the standing requirement required by the course.</li>
        <li>Capacity: Each class has a capacity limit. This student can enroll only when after his/her enrollment, the class size is kept within the capacity limit.</li>
        <li>Waitlist and where: If this student has fulfilled all requirements but the class is full, then add his/her record to the waiting list. The system then prints "Student number xxxx is now on the waitiling list for class number xxxx" Your are number XYZ on the waiting list."</li>
        <li>Already on Waiting: if the student is already on the waiting list for this course, you should not place him on the waiting list again. Print a message to let the student know.</li>
        <li>A confirmation message is printed if the student is finally successfully enrolled in the course.</li>
        <li>Your program should check all requirements and store the error messages in p_errormsg. If there is no error, p_errormsg is NULL. The system also prints the error message.</li>
    </ol>
</p>
	

<h1 align="center">Program 2: The DropMe procedure</h1>
<p align="center">
    <strong>Enroll.DropMe(p_snum, p_callnum)</strong>
</p>
<p>
    This procedure is to DROP a student from a class
    <ol>
        <li>Validate Student Number, Validate Call Number: If the student number or call number is invalid, the systems would print an error message and does not proceed with the following checks</li>
        <li>
            Not enrolled: If the student is not enrolled in this class, he/she cannot be dropped. The system prints an error msg.
        </li>
        <li>
            Already graded: A student cannot drop if there is already a grade assigned(ie, grade is not null)
        </li>
        <li>
            When a student successfully drops from a course, the status of this enrollment is marked with a 'W'. A confirmation message is printed.
        </li>
        <li>
            Once a student drops from a course, your program should proceed to check if there are any students on the waiting list. If there is, you should move the student who requested the enrollment the earliest to the enrollment list.
            <ul>
                <li>
                    Note that a check on all enrollment requirements should be performed on this new student.
                </li>
                <li>
                    If this new student is enrolled, his record should be removed from the waiting list.
                </li>
                <li>
                    If this student cannot enroll for any reason(for instance, he now has too many units, etc), his record should remain on the waiting list and you should attempt to enroll the next student on the waiting list. Your program continues until either one student is enrolled or there is no (qualified) student on the waiting list.
                </li>
            </ul>
        </li>
    </ol>
</p>
<h1 align="center">Deliverables(due at the final exam)</h1>
<ol>
    <li>A setup.sql program on a flash disk or DVD. This program is to create all table structure, insert all test data, and create all packages. Please do not put it under any folder or subdirectory; put setup.sql under the root directory.
    </li>
    <li>
        A printed document that includes:
        <ol style="list-style-type: lower-alpha;">
            <li>Your name and email address.</li>
            <li>A print out of your table structure, that is, describe students;, for instance.</li>
            <li>A print out of your test data, that is, select * from students;, for instance.</li>
            <li>A print out of all of your programs.</li>
        </ol>
    </li>
</ol>
