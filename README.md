matlab-autograder
=================

A MATLAB testing framework designed for automatically grading/handling
assignments.

Installation
------------

This is designed to work with the `submit-system` project using the
`turnin` (or `project`) unix homework submission system, but you could
still make it work however you want.

Just clone the repository and put it anywhere.

Demo
-----------

**Matlab assignment testing**

In the `demo` folder, there are two sub-folders: `grade` and
`submit`. `submit` is an example homework submission that a student
might submit, where they are required to implement two functions,
`myfun` and `myfun2`, as well as generate two plots and write two
written answers. Note that there are some bugs in their assignment.

To see how to use the system, create a temporary directory anywhere
and run the following (assuming you put the git in `~/matlab-autograder`)

```unix
cp -r ~/matlab-autograder/* .  cp -r
~/matlab-autograder/demo/grade/* .  cp -r
~/matlab-autograder/demo/submit/* .
``` 

At this point you now have, in order, copied the test framework, the
specific tests for that assignment, and then the actual submitted
files to the same folder. When setup this way, calling
`grade.run_tests` will run all test scripts (functions beginning with
`test_`) and generate all reports (functions beginning with `report_`)
into a single HTML file `report.html` and a text file `results.txt`.

Try running it and loading up `report.html` and you see the output of
the system. The idea is that this final output is useful for the TAs
for grading, and can be printed and handed back to the students with
comments.

**Integrating with submit-system and turnin**

The idea is that the above steps should be completed every time a
student submits an assignment electronically,

The script `test_sample_turnin.sh` gives an example of a Bash script
that would be called by `submit-system`'s
`monitor_ssh_location.py`. This untars a student's submission, copies
over the framework, tests, and student submissions to a temporary
private directory, runs the tests, and then saves the report.html to a
a safe place.

