#!/usr/bin/env perl6
use v6;
use DBIish;

###
sub MAIN() {
    
  my $dbh = DBIish.connect( "SQLite", :database<.p6db.sqlite3> );
  
  my $sth = $dbh.do( q:to/STATEMENT/ );
      DROP TABLE IF EXISTS tables
    STATEMENT

  $sth = $dbh.do( q:to/STATEMENT/ );
      CREATE TABLE IF NOT EXISTS tables (
          ID          INTEGER PRIMARY KEY AUTOINCREMENT,
          nome        varchar(4) NOT NULL UNIQUE,
          valor       varchar(255) NOT NULL UNIQUE
      )
      STATEMENT

  $sth = $dbh.prepare( q:to/STATEMENT/ );
      INSERT INTO tables( nome, valor ) 
      VALUES ( ?, ? )
    STATEMENT

  $sth.execute( 'futs', get-hash );
  $sth.execute( 'tecnicos', get-hash );
  $sth.execute( 'times', get-hash );
  
  $sth = $dbh.prepare( q:to/STATEMENT/ );
      SELECT *
      FROM tables
    STATEMENT

  $sth.execute();
  
  my @rows = $sth.allrows();
  for @rows -> $row { 
    say $row;
  }
  
  $sth.finish;
  $dbh.dispose;
  
  say "P6DB criada com sucesso!";
  
}

sub get-hash {
  return (10..10**32).pick.fmt( '%x' );
}

