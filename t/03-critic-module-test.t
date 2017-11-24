#!/usr/bin/perl

#
# Copyright (C) 2017 Joelle Maslak
# All Rights Reserved - See License
#

use Test2::Bundle::Extended 0.000058;
use File::FindStrings::Boilerplate 'script';

use Perl6::Slurp;

require Perl::Critic;

MAIN: {
    my (@tests) = (
        {
            file       => 't/data/Boilerplate.txt',
            conf       => 't/data/03.01.conf',
            violations => [ 'Bad string in source file: "Joelle Maslak"' ],
            note       => 'Perl file search with found word',
        },
        {
            file       => 't/data/Boilerplate.txt',
            conf       => 't/data/03.02.conf',
            violations => [ 'Bad string in source file: "Joelle Maslak"' ],
            note       => 'Perl file search with some found words',
        },
        {
            file       => 't/data/Boilerplate.txt',
            conf       => 't/data/03.03.conf',
            violations => [ ],
            note       => 'Perl file search without found word',
        },
        {
            file       => 't/data/Boilerplate.txt',
            conf       => 't/data/03.03.conf',
            violations => [ ],
            note       => 'Perl file search without any found word',
        },
    );

    foreach my $test (@tests) {
        my $str = slurp( $test->{file} );

        my $critic = Perl::Critic->new(
            '-profile'       => $test->{conf},
            '-single-policy' => 'BadStrings',
        );
        my (@violations) = $critic->critique( \$str );
        my (@descriptions) = map {$_->description} @violations;

        is( \@descriptions, $test->{violations}, $test->{note});
    }

    done_testing;
}

1;

