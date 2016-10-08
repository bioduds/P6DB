#!/usr/bin/env perl6
use v6;
use DBIish;
use JSON::Class;

subset ID of Int where * > 0;

class Result does JSON::Class {
  has ID $.ID is required;
  has Str $.nome is required;
  has Str $.value is required;
}

###
sub MAIN() {

  my $dbh = DBIish.connect( "SQLite", :database</home/ubuntu/dev/futs/scripts/.p6db.sqlite3> );
  
  my $sth = $dbh.prepare( q:to/STATEMENT/ );
      SELECT *
      FROM tables
    STATEMENT

  $sth.execute();

  my @rows = $sth.allrows();
  my @json;
  for @rows -> $row {
    my $result = Result.new( ID=>$row[0], nome=>$row[1], value=>$row[2] );
    @json.push( $result.to-json() );
  }
  print '[' ~ @json.join(',') ~ ']';
  
  $sth.finish;
  $dbh.dispose;
  
}

