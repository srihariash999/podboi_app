
# Flutter test and generate HTML coverage report
testcov:
	flutter test --coverage
	lcov --remove coverage/lcov.info 'lib/DataModels/*' 'lib/Constants/*' -o coverage/lcov.info
	genhtml coverage/lcov.info -o coverage/html

open-testcov:
	open coverage/html/index.html