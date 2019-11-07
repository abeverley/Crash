#!/usr/bin/perl

use strict; use warnings;

use FindBin;
use Text::CSV;
use lib "$FindBin::Bin/../lib";

use Crash::Schema;
use DateTime::Format::Strptime;
use Log::Report;

my $schema = Crash::Schema->connect(
  'dbi:Pg:database=crash;host=127.0.0.1',
  'crash',
  'crash',
  { AutoCommit => 1 },
);
 
my $csv =  Text::CSV->new({ binary => 1 })
        or error __"Cannot use CSV: {error}", error => Text::CSV->error_diag;

my $strp = DateTime::Format::Strptime->new(
    pattern   => '%d-%b-%y %H%M',
    locale    => 'en_GB',
    time_zone => 'UTC',
);

my @files = <csv/*>;

foreach my $file (@files) {
    open my $fh, "<:encoding(utf8)", $file or fault "Unable to open $file";
    say STDERR "doing file $file";
    $csv->getline ($fh); # Headings
    while (my $row = $csv->getline ($fh)) {
        if ($file =~ /attendant/)
        {
            my $severity = $row->[6];
            $severity =~ s/\h+.*//;
            my $d = $row->[9] . ' ' . $row->[11];
            $d =~ s/'//;
            my $date = $strp->parse_datetime($d)
                or error "Failed to parse date $d";
            $schema->resultset('Crash')->create({
                reference => $row->[0],
                easting   => $row->[3],
                northing  => $row->[4],
                location  => $row->[5],
                severity  => $severity,
                date      => $date,
            });
        }
        elsif ($file =~ /casualty/)
        {
            my $crash = $schema->resultset('Crash')->search({
                reference => $row->[0],
            })->next;
            my $class = $row->[6];
            $class =~ s/\h+.*//;
            my $severity = $row->[11];
            $severity =~ s/\h+.*//;
            my $mode = $row->[14];
            $mode =~ s/\h+.*//;
            $schema->resultset('Casualty')->create({
                crash_id       => $crash->id,
                casualty_class => $class,
                casualty_mode  => $mode,
                severity       => $severity,
            });
        }
        elsif ($file =~ /vehicle/)
        {
            my $crash = $schema->resultset('Crash')->search({
                reference => $row->[0],
            })->next;
            my $class = $row->[7];
            $class =~ s/\h+.*//;
            $schema->resultset('Vehicle')->create({
                crash_id     => $crash->id,
                vehicle_type => $class,
            });
        }
        else {
            error "Unrecognished file type $file";
        }
    }
}

