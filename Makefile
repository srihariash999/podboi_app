
# Flutter test and generate HTML coverage report
testcov:
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html
