use utf8;
package Crash::Schema::Result::Crash;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

__PACKAGE__->table("crash");

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "reference",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "easting",
  { data_type => "integer", is_nullable => 0 },
  "northing",
  { data_type => "integer", is_nullable => 0 },
  "location",
  { data_type => "text", is_nullable => 1 },
  "severity",
  { data_type => "smallint", is_nullable => 1 },
  "date",
  { data_type => "datetime", datetime_undef_if_invalid => 1, is_nullable => 1 },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many(
  "vehicles",
  "Crash::Schema::Result::Vehicle",
  { "foreign.crash_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

__PACKAGE__->has_many(
  "casualties",
  "Crash::Schema::Result::Casualty",
  { "foreign.crash_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

sub sqlt_deploy_hook {
    my ($self, $sqlt_table) = @_;
    $sqlt_table->add_index(name => 'crash_idx_reference', fields => [ 'reference' ]);
}

1;
