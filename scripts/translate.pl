#!/usr/bin/env perl6
use v6;
use DBIish;

###
sub MAIN( Str :$entry = "tecnicos" ) {
    
  my $dbh = DBIish.connect( "SQLite", :database<.p6db.sqlite3> );

  my $sth = $dbh.prepare( q:to/STATEMENT/ );
      SELECT *
      FROM tables
      WHERE nome = ?
    STATEMENT

  $sth.execute( $entry );

  my @rows = $sth.allrows();
  #say @rows.perl;
  for @rows -> $row { 
    print $row[2];
  }

  $sth.finish;
  $dbh.dispose;
  
}

