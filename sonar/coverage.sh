echo "Running tests and coverage analysis..."
sonardir=sonar
. $sonardir/check.sh
rm -rf .coverage &> /dev/null

#Options: https://nose.readthedocs.io/en/latest/man.html
nosetests \
--with-coverage \
--cover-package=./ \
--cover-xml --cover-xml-file=$sonardir/coverage.xml \
--with-xunit --xunit-file=$sonardir/nosetests.xml \
--cover-html --cover-html-dir=$sonardir/coverage-html \

sed -i.bak 's/filename="/filename=".\//g' $sonardir/coverage.xml
