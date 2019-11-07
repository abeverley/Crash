use utf8;
package Crash::Schema::Result::Vehicle;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

__PACKAGE__->table("vehicle");

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "crash_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "vehicle_type",
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

my %vmap = (
    1 => 'bicycle',
    2 => 'motorbike',
    3 => 'car',
    4 => 'taxi',
    5 => 'unknown',
    6 => 'bus/coach',
    7 => 'goods vehicle',
    8 => 'other',
);

sub vehicle
{   my $self = shift;
    $vmap{$self->vehicle_type};
}

1;
