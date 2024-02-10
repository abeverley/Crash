#!/usr/bin/perl

use strict; use warnings;

use FindBin;
use Text::CSV;
use lib "$FindBin::Bin/../lib";

use Crash::Schema;
use DateTime::Format::Strptime;
use Log::Report;
use Geo::Coordinates::OSGB qw/grid_to_ll ll_to_grid/;
use Cpanel::JSON::XS qw/encode_json/;
use Text::Autoformat qw/autoformat/;

my $east_min = 527789;
my $east_max = 528814;
my $north_min = 178786;
my $north_max = 179654;

my $polygon = [
    [grid_to_ll($east_min, $north_min)],
    [grid_to_ll($east_min, $north_max)],
    [grid_to_ll($east_max, $north_max)],
    [grid_to_ll($east_max, $north_min)],
];

my $csv = Text::CSV->new({ binary => 1 })
    or die "Cannot use CSV: ".Text::CSV->error_diag ();

my $file = '/home/abeverley/git/Crash/members.csv';
open my $fh, "<:encoding(utf8)", $file or die "$file: $!";


$csv->getline($fh); # header
my @points;
while (my $row = $csv->getline($fh))
{
    my $postcode = $row->[0];
    push @points, {
          type => "Feature",
          geometry => {
            type => "Point",
            coordinates => [$row->[6] + 0, $row->[5] + 0],
          },
          properties => {
            status => $row->[0],
            comments1 => "Joined ".$row->[7],
            comments2 => "",
            icon => 'blue',
            hpe => \1,
          }
    };
}

say STDOUT encode_json {
    layers => [
        {
            name => $_,
            geojson => {
                type => "FeatureCollection",
                features => \@points,
            }
        }
    ]
};
