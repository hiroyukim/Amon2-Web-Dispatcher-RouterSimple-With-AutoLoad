use inc::Module::Install;
name 'Amon2-Web-Dispatcher-RouterSimple-With-AutoLoad';
all_from 'lib/Amon2/Web/Dispatcher/RouterSimple/With/AutoLoad.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
