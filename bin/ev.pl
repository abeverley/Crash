#!/usr/bin/perl

use strict; use warnings;

use JSON;

my @points = (
    { lat => 51.51231, lng=>-0.17389, type => 'existing' },
    { lat => 51.51253, lng=>-0.17352, type => 'existing' },
    { lat => 51.51328, lng=>-0.17214, type => 'existing' },
    { lat => 51.51214, lng=>-0.17236, type => 'existing' },
    { lat => 51.51259, lng=>-0.16891, type => 'existing' },
    { lat => 51.51281, lng=>-0.16887, type => 'existing' },
    { lat => 51.51300, lng=>-0.16903, type => 'existing' },
    { lat => 51.51326, lng=>-0.16664, type => 'existing' },
    { lat => 51.51421, lng=>-0.16780, type => 'existing' },
    { lat => 51.51344, lng=>-0.16407, type => 'existing' },
    { lat => 51.51400, lng=>-0.16302, type => 'existing' },
    { lat => 51.51403, lng=>-0.16218, type => 'existing' },
    { lat => 51.51459, lng=>-0.17288, type => 'existing' },
    { lat => 51.51630, lng=>-0.16842, type => 'existing' },
    { lat => 51.51641, lng=>-0.16829, type => 'existing' },
    { lat => 51.51664, lng=>-0.16617, type => 'existing' },
    { lat => 51.51484, lng=>-0.16586, type => 'proposed-lamppost' },
    { lat => 51.51532, lng=>-0.16448, type => 'proposed-lamppost' },
    { lat => 51.51480, lng=>-0.16614, type => 'proposed-lamppost' },
    { lat => 51.51502, lng=>-0.16407, type => 'proposed-lamppost' },
    { lat => 51.51535, lng=>-0.16589, type => 'proposed-lamppost' },
    { lat => 51.51541, lng=>-0.16654, type => 'proposed-lamppost' },
    { lat => 51.51529, lng=>-0.16678, type => 'proposed-lamppost' },
    { lat => 51.51511, lng=>-0.16712, type => 'proposed-lamppost' },
    { lat => 51.51487, lng=>-0.16839, type => 'proposed-lamppost' },
    { lat => 51.51497, lng=>-0.16880, type => 'proposed-lamppost' },
    { lat => 51.51516, lng=>-0.16905, type => 'proposed-lamppost' },
    { lat => 51.51539, lng=>-0.16922, type => 'proposed-lamppost' },
    { lat => 51.51440, lng=>-0.16716, type => 'proposed-rapid' },
    { lat => 51.51518, lng=>-0.16545, type => 'proposed-rapid' },
    { lat => 51.51577, lng=>-0.16683, type => 'proposed-rapid' },
    { lat => 51.51583, lng=>-0.17108, type => 'proposed-rapid' },
    { lat => 51.51576, lng=>-0.17121, type => 'proposed-rapid' },
    { lat => 51.51552, lng=>-0.17064, type => 'proposed-bollard' },
    { lat => 51.51444, lng=>-0.17161, type => 'proposed-bollard' },
    { lat => 51.51466, lng=>-0.17124, type => 'proposed-bollard' },
    { lat => 51.51489, lng=>-0.17086, type => 'proposed-bollard' },
    { lat => 51.51410, lng=>-0.16961, type => 'proposed-bollard' },
    { lat => 51.51413, lng=>-0.16905, type => 'proposed-bollard' },
    { lat => 51.51420, lng=>-0.16843, type => 'proposed-bollard' },
    { lat => 51.51470, lng=>-0.16743, type => 'proposed-bollard' },
    { lat => 51.51632, lng=>-0.16727, type => 'proposed-bollard' },
    { lat => 51.51609, lng=>-0.16694, type => 'proposed-bollard' },
    { lat => 51.51581, lng=>-0.16655, type => 'proposed-bollard' },
    { lat => 51.51443, lng=>-0.16592, type => 'proposed-bollard' },
    { lat => 51.51453, lng=>-0.16521, type => 'proposed-bollard' },
);

@points = map {
    my $icon = $_->{type} eq 'existing'
        ? 'green'
        : $_->{type} eq 'proposed-lamppost'
        ? 'orange'
        : $_->{type} eq 'proposed-rapid'
        ? 'violet'
        : $_->{type} eq 'proposed-bollard'
        ? 'blue'
        : die("Invalid type $_->{type}");
    my $comments1 = $_->{type} eq 'existing'
        ? 'Existing charger'
        : $_->{type} eq 'proposed-lamppost'
        ? 'Proposed lamppost charger'
        : $_->{type} eq 'proposed-rapid'
        ? 'Proposed rapid charger'
        : $_->{type} eq 'proposed-bollard'
        ? 'Proposed bollard charger'
        : die("Invalid type $_->{type}");
    +{
        type => "Feature",
        geometry => {
            type => "Point",
            coordinates => [$_->{lng} + 0, $_->{lat} + 0],
        },
        properties => {
            icon => $icon,
            hpe => \1,
            comments1 => $comments1,
        },
        layer => $_->{type} eq 'existing' ? 'Existing chargers' : 'Proposed chargers',
    };
} @points;

my %layers;

foreach my $point (@points)
{
    my $name = delete $point->{layer};
    $layers{$name} ||= [];
    push @{$layers{$name}}, $point;
}

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
