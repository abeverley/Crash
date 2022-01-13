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

my $schema = Crash::Schema->connect(
  'dbi:Pg:database=crash;host=127.0.0.1',
  'crash',
  'crash',
  { AutoCommit => 1 },
);

#527815 179527
#528814 178786

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
use Data::Dumper; say STDERR Dumper $polygon;

my $csv = Text::CSV->new({ binary => 1 })
    or die "Cannot use CSV: ".Text::CSV->error_diag ();

my $file = '/home/abeverley/ltn-responses6-original-from-council-final-converted.csv';
open my $fh, "<:encoding(utf8)", $file or die "$file: $!";


my %layers = (
    'Outside Hyde Park Estate' => [],
    'Within Hyde Park Estate' => [],
);

my $green = 0; my $red = 0;
$csv->getline($fh); # header
my $blank_postcode_red;
my $blank_postcode_green;
while (my $row = $csv->getline($fh))
{
    if ($row->[6] =~ /^\s*$/)
    {
        say STDERR "Ignoring response $row->[6]";
        next;
    }
    my $icon = $row->[6] =~ /negative/i ? 'red' : $row->[6] =~ /positive/i ? 'green' : $row->[6] =~ /neutral/i ? 'grey' : panic("Fail $row->[6]");
    if (!$row->[1])
    {
        $blank_postcode_red++ if $icon eq 'red';
        $blank_postcode_green++ if $icon eq 'green';
        next;
    }
    my $postcode = $row->[1];
    my $hpe = $postcode =~ /w2\s*2/i;
    #next if $hpe;
    if (!$row->[3])
    {
        say STDERR "invalid postcode $postcode for $icon";
        next;
    }
    $green++ if $icon eq 'green';
    $red++ if $icon eq 'red';
    my $key = $hpe ? 'Within Hyde Park Estate' : 'Outside Hyde Park Estate';
    say STDERR "key is $key";
    push @{$layers{$key}}, {
          type => "Feature",
          geometry => {
            type => "Point",
            coordinates => [$row->[4] + 0, $row->[3] + 0],
          },
          properties => {
              #date => $crash->date->strftime("%e %b %Y"),
            #casualties => $casualties,
            #vehicles => $vehicles,
            #location => autoformat($crash->location, { case => 'title' }),
            status => $row->[6],
            comments1 => $row->[7],
            comments2 => $row->[14],
            icon => $icon,
            hpe => $hpe ? \1 : \0,
          }
    };
}

say STDERR "blank postcode $blank_postcode_red green $blank_postcode_green";
say STDERR "red is $red green is $green";

say STDOUT encode_json {
    layers => [
        map {
            {
                name => $_,
                geojson => {
                    type => "FeatureCollection",
                    features => $layers{$_},
                }
            }
        } keys %layers
    ],
};
