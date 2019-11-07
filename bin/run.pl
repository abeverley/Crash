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

my @points;

my $east_min = 523891;
my $east_max = 525631;
my $north_min = 179855;
my $north_max = 180590;

my $polygon = [
    [grid_to_ll($east_min, $north_min)],
    [grid_to_ll($east_min, $north_max)],
    [grid_to_ll($east_max, $north_max)],
    [grid_to_ll($east_max, $north_min)],
];

foreach my $year (2016..2018)
{
    my $crashes = $schema->resultset('Crash')->search({
        # easting  => [ -and => { '>' => 531605 }, { '<' => 531702 } ], 
        # northing => [ -and => { '>' => 179479 }, { '<' => 180602 } ], 
        easting  => [ -and => { '>' => $east_min }, { '<' => $east_max } ],
        northing => [ -and => { '>' => $north_min }, { '<' => $north_max } ],
        date     => [ -and => { '>=' => "$year-01-01 00:00:00", '<=' => "$year-12-31 23:59:00" } ],
    });

    my $casualties = $schema->resultset('Casualty')->search({
        crash_id => { -in => $crashes->get_column('id')->as_query },
    });
    my $pedestrian = $casualties->search({ 'casualty_mode' => 1 })->count;
    my $cyclist = $casualties->search({ 'casualty_mode' => 2 })->count;
    my $other = $casualties->search({ 'casualty_mode' => { '>=' => 3 } })->count;
    #say STDERR "For the year $year there were a total $pedestrian pedestrian casualties, $cyclist cyclist casualties and $other other casualties";

    foreach my $crash ($crashes->all)
    {
        my ($easting, $northing) = grid_to_ll($crash->easting, $crash->northing);

        my @vehicles = map $_->vehicle, $crash->vehicles->all;
        push @vehicles, 'pedestrian' if $crash->casualties->search({ casualty_mode => 1 })->count;
        my $action = @vehicles > 1 ? 'collided' : 'had an accident';
        my %vehs;
        foreach my $veh (@vehicles)
        {
            $vehs{$veh}++
        }

        @vehicles = ();
        foreach my $veh (keys %vehs)
        {
            my $qty = $vehs{$veh};
            push @vehicles, ($qty == 1 ? '' : $qty.' ').$veh.($qty > 1 ? 's' : '');
        }
        my $vehicles = join ', ', @vehicles;
        my $desc = "On ".$crash->date->strftime("%e %b %Y")." the following $action: ";
        $desc .= "$vehicles. Casualties: ";
        my $casualties = join ', ', map $_->casualty, $crash->casualties->all;
        $desc .= "$casualties\n";

        my %all_casualties = map { $_->casualty_pedestrian_cyclist => 1 } $crash->casualties->all;
        my @unique_modes = keys %all_casualties;
        my $icon;

        foreach my $cas (@unique_modes)
        {
            $icon = 'icon_'.$cas;
            $icon = 'other' if $icon ne 'icon_pedestrian_slight'
                && $icon ne 'icon_pedestrian_serious'
                && $icon ne 'icon_pedestrian_fatal'
                && $icon ne 'icon_cyclist_slight'
                && $icon ne 'icon_cyclist_serious'
                && $icon ne 'icon_cyclist_fatal';

            push @points, {
                  type => "Feature",
                  geometry => {
                    type => "Point",
                    coordinates => [$northing, $easting],
                  },
                  properties => {
                    date => $crash->date->strftime("%e %b %Y"),
                    casualties => $casualties,
                    vehicles => $vehicles,
                    location => autoformat($crash->location, { case => 'title' }),
                    description => $desc,
                    icon => $icon,
                  }
            };
        }
    }
}

say STDOUT encode_json {
    type => "FeatureCollection",
    features => \@points,
};
