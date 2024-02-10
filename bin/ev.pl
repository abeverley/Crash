#!/usr/bin/perl

use strict; use warnings;

use JSON;

my @points = (
    { lat => 51.51616, lng=>-0.16535, type => 'new' },
    { lat => 51.51636, lng=>-0.16566, type => 'new' },
    { lat => 51.51576, lng=>-0.16681, type => 'new' },
    { lat => 51.51557, lng=>-0.16624, type => 'new' },
    { lat => 51.51526, lng=>-0.16684, type => 'new' },
    { lat => 51.51514, lng=>-0.16707, type => 'new' },
    { lat => 51.51500, lng=>-0.16731, type => 'new' },
    { lat => 51.51503, lng=>-0.16749, type => 'new' },
    { lat => 51.51523, lng=>-0.16775, type => 'new' },
    { lat => 51.51689, lng=>-0.16827, type => 'new' },
    { lat => 51.51632, lng=>-0.16762, type => 'new' },
    { lat => 51.51577, lng=>-0.16855, type => 'new' },
    { lat => 51.51544, lng=>-0.16922, type => 'new' },
    { lat => 51.51553, lng=>-0.16941, type => 'new' },
    { lat => 51.51556, lng=>-0.16924, type => 'new' },
    { lat => 51.51574, lng=>-0.16899, type => 'new' },
    { lat => 51.51548, lng=>-0.16908, type => 'new' },
    { lat => 51.51530, lng=>-0.16901, type => 'new' },
    { lat => 51.51501, lng=>-0.16886, type => 'new' },
    { lat => 51.51489, lng=>-0.16843, type => 'new' },
    { lat => 51.51491, lng=>-0.16812, type => 'new' },
    { lat => 51.51476, lng=>-0.16447, type => 'new' },
    { lat => 51.51479, lng=>-0.16371, type => 'new' },
    { lat => 51.51458, lng=>-0.16360, type => 'new' },
    { lat => 51.51394, lng=>-0.16278, type => 'new' },
    { lat => 51.51359, lng=>-0.16310, type => 'new' },
    { lat => 51.51378, lng=>-0.16376, type => 'new' },
    { lat => 51.51384, lng=>-0.16403, type => 'new' },
    { lat => 51.51342, lng=>-0.16680, type => 'new' },
    { lat => 51.51360, lng=>-0.16684, type => 'new' },
    { lat => 51.51294, lng=>-0.16659, type => 'new' },
    { lat => 51.51363, lng=>-0.16790, type => 'new' },
    { lat => 51.51325, lng=>-0.16790, type => 'new' },
    { lat => 51.51371, lng=>-0.16967, type => 'new' },
    { lat => 51.51361, lng=>-0.16908, type => 'new' },
    { lat => 51.51342, lng=>-0.16913, type => 'new' },
    { lat => 51.51324, lng=>-0.16908, type => 'new' },
    { lat => 51.51430, lng=>-0.16831, type => 'new' },
    { lat => 51.51426, lng=>-0.16864, type => 'new' },
    { lat => 51.51421, lng=>-0.16912, type => 'new' },
    { lat => 51.51417, lng=>-0.16953, type => 'new' },
    { lat => 51.51415, lng=>-0.16985, type => 'new' },
    { lat => 51.51403, lng=>-0.17008, type => 'new' },
    { lat => 51.51378, lng=>-0.17004, type => 'new' },
    { lat => 51.51467, lng=>-0.16958, type => 'new' },
    { lat => 51.51455, lng=>-0.16980, type => 'new' },
    { lat => 51.51441, lng=>-0.17008, type => 'new' },
    { lat => 51.51519, lng=>-0.17018, type => 'new' },
    { lat => 51.51537, lng=>-0.17057, type => 'new' },
    { lat => 51.51558, lng=>-0.17073, type => 'new' },
    { lat => 51.51395, lng=>-0.17090, type => 'new' },
    { lat => 51.51380, lng=>-0.17117, type => 'new' },
    { lat => 51.51463, lng=>-0.17146, type => 'new' },
    { lat => 51.51450, lng=>-0.17169, type => 'new' },
    { lat => 51.51440, lng=>-0.17186, type => 'new' },
    { lat => 51.51389, lng=>-0.17188, type => 'new' },
    { lat => 51.51385, lng=>-0.17203, type => 'new' },
    { lat => 51.51402, lng=>-0.17224, type => 'new' },
    { lat => 51.51295, lng=>-0.17091, type => 'new' },
    { lat => 51.51286, lng=>-0.17180, type => 'new' },
    { lat => 51.51334, lng=>-0.17378, type => 'new' },
    { lat => 51.51273, lng=>-0.17334, type => 'new' },
    { lat => 51.51276, lng=>-0.17484, type => 'new' },
    { lat => 51.51231, lng=>-0.17389, type => 'existing' },
    { lat => 51.51253, lng=>-0.17352, type => 'existing' },
    { lat => 51.51328, lng=>-0.17214, type => 'existing' },
    { lat => 51.51214, lng=>-0.17236, type => 'existing' },
    { lat => 51.51259, lng=>-0.16891, type => 'existing' },
    { lat => 51.51281, lng=>-0.16887, type => 'existing' },
    { lat => 51.51300, lng=>-0.16903, type => 'existing' },
    { lat => 51.51326, lng=>-0.16664, type => 'existing' },
    { lat => 51.51421, lng=>-0.16780, type => 'existing' },
    { lat => 51.51400, lng=>-0.16302, type => 'existing' },
    { lat => 51.51410, lng=>-0.16244, type => 'existing' },
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
    my $icon = $_->{type} eq 'existing' || $_->{type} eq 'new'
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
        : $_->{type} eq 'new'
        ? 'Recently added charger'
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
        layer => $_->{type} eq 'existing'
            ? 'Existing chargers'
            : $_->{type} eq 'new'
            ? 'Recently added chargers'
            : 'Proposed chargers',
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
