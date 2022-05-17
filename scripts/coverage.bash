#!/bin/bash

OK=0
TRY_AGAIN=11
PKG_NOT_INSTALLED=65

ANSI_RED='\033[0;31m'
ANSI_GREEN='\033[0;32m'
ANSI_BROWN='\033[0;33m'
ANSI_CLEAR='\033[0m'


function run_tests_generate_coverage() {
    dart pub global run coverage:test_with_coverage
}

function build_html_for_coverage_results() {
    genhtml -o coverage coverage/lcov.info
}

function info_log() {
    echo -e "$ANSI_GREEN[info]$ANSI_CLEAR $1"
}

function warning_log() {
    echo -e "$ANSI_BROWN[warning]$ANSI_CLEAR $1"
}

function error_log() {
    echo -e "$ANSI_RED[error]$ANSI_CLEAR $1"
}

info_log 'Running tests and generating coverage...'

run_tests_generate_coverage

if [ $? -eq $PKG_NOT_INSTALLED ]
then
    warning_log 'Package coverage is not installed. Installing...'

    dart pub global activate coverage

    run_tests_generate_coverage
fi

if [ ! $? -eq $OK ]
then
    error_log 'Could not generate coverage! Are you sure you are in a directory that has test folders?'
    exit $TRY_AGAIN
fi

info_log 'Generating HTML webpages for viewing coverage results.'

build_html_for_coverage_results

if [ ! $? -eq $OK ]
then
    error_log 'Could not build HTML webpages using lcov command! Maybe the program is not available?'
    exit $TRY_AGAIN
fi

info_log 'All done. The following command opens the main HTML webpage.'
echo 'open coverage/index.html'