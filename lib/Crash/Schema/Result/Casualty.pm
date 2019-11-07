use utf8;
package Crash::Schema::Result::Casualty;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

__PACKAGE__->table("casualty");

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "crash_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "casualty_class",
  { data_type => "integer", is_nullable => 1 },
  "casualty_mode",
  { data_type => "integer", is_nullable => 1 },
  "severity",
  { data_type => "integer", is_nullable => 1 },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to(
  "crash",
  "Crash::Schema::Result::Crash",
  { id => "crash_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

# Classes
# 1 => driver/rider
# 2 => passenger
# 3 => pedestrian
#
# Modes
# 1 => pedestrian
# 2 => cycle
# 3 => motorbike
# 4 => car
# 5 => taxi
# 6 => bus/coach
# 7 => goods vehicle
# 8 => other

my %cmap = (
    # mode then class
    13 => 'pedestrian',
    21 => 'cyclist',
    31 => 'motorcyclist',
    32 => 'motorcyclist passenger',
    41 => 'car driver',
    42 => 'car passenger',
    51 => 'taxi driver',
    52 => 'taxi passenger',
    61 => 'bus driver',
    62 => 'bus passenger',
    71 => 'lorry driver',
    72 => 'lorry passenger',
);

my %smap = (
    1 => 'fatal',
    2 => 'serious',
    3 => 'slight',
);

sub casualty_pedestrian_cyclist
{   my $self = shift;
    my $cm = $self->casualty_mode.$self->casualty_class;
    my $string = $cmap{$cm};
    return $string.'_'.$self->casualty_severity_string if $string eq 'pedestrian' || $string eq 'cyclist';
    return 'other';
}

sub casualty_severity_string
{   my $self = shift;
    $smap{$self->severity};
}

sub casualty
{   my $self = shift;
    my $sev = $smap{$self->severity};
    my $cm = $self->casualty_mode.$self->casualty_class;
    $cmap{$cm}." ($sev)";
}

1;
