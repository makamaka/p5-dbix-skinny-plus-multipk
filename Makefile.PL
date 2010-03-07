use inc::Module::Install;
name 'DBIx-Skinny-Profiler-Plus-MultiPK';
all_from 'lib/DBIx/Skinny/Plus/MultiPK.pm';

requires 'DBIx::Skinny' => 0.05;

author_tests('xt');

build_requires 'Test::More';

use_test_base;
auto_include;
auto_set_repository;
WriteAll;

1;
__END__
