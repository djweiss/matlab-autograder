#!/bin/bash

# Title for email header
title="Sample Test Results"

# Inputs are passed by the submit-system monitor.
project=$1   # turnin project
user=$2      # name of turnin submission (i.e. user or user.Z)
sendmail=$3  # whether or not to send mail

# Domain for emails
domain=seas.upenn.edu

# Path to autograder scripts.
srcdir=~/matlab-autograder

# Path to test_* and report_* scripts for this assignment.
testdir=~/matlab-autograder/demo/grade

# Path where the code will be evaluated (temporary directory)
rundir=~/tmp_run/$project/$user

# Path where the report will be stored
resultdir=~/grade_results/$project/$user

# Create runtime directory
mkdir -p $rundir || exit 1
cd $rundir  || exit 1
pwd

# clean out any old test runs
rm -rf * || exit 1

echo "Extracting submission $user"
if [[ $user == *\.Z ]]; then
    tar -zxf ~/submit/$project/$user || exit 1
else
    tar -xf ~/submit/$project/$user || exit 1
fi
# Get timestamp
submitted=`ls -lh ~/submit/$project/$user --time-style=iso | awk '{ print "Submitted:", $6, $7  ", Size:", $5 }'`

# Print out submitted files for posterity
echo "Submitted files:"
ls -lah *

# Run command
echo "Copying framework..."
cp -rvf $srcdir/+hwtest . || exit 1
cp -rvf $srcdir/extract_src_html.awk . || exit 1
cp -rvf $srcdir/missing.jpg . || exit 1
cp -rvf $srcdir/m2html . || exit 1

echo "Copying tests..."
cp -rvf $testdir/* . || exit 1
chmod -R 700 *

# Get actual username (for report and email)
if [[ $user == *\.Z ]]
then
    echo "stripping username"
    user=${user%\.Z}
    echo "new username: $user"
fi

# Generate header for report file
echo "<h1>$user - $project</h1>" > header.html
echo "<h2>$submitted</h2>" >> header.html

# Actually run the MATLAB test framework
echo "Running tests..."
matlab -nojvm <<EOF
grade.run_tests;
exit;
EOF

# MATLAB will have generated a results.txt which contains a summary
# of the test results. Print to stdout for logging purposes.
echo "Result:"
echo -e "\n" >> results.txt
cat results.txt
echo -n "Testing for completion: "
grep '### Tests finished' results.txt || exit 1
echo "FINISHED TESTS"

# Copy test results to grade directory.
mkdir -p $resultdir || exit 1
cp -vf *.css *.jpg *.html *.txt $resultdir
chmod -R 700 $resultdir

# Assume email is user@domain unless otherwise specified by email.txt
email=$user@$domain
if [ -e "./email.txt" ]
then
    email=`head -n 1 email.txt`
fi
echo "using email $email"

# Web submissions are prefixed by web_, so ignore this if there was no
# email.txt given.
if [[ $email == web_* ]] 
then
    echo "ignoring web email $email"
fi

# Check for sending mail enabled
if [[ $sendmail == nomail ]]
then
    echo "SENDING MAIL DISABLED"
else
    mail -s "CIS520: $title" $email < results.txt
fi

# Cleanup
rm -rvf $rundir || exit 1
