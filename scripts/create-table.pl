#!/usr/bin/env perl6
use v6;

###
sub MAIN( *%entries ) {
  
  my $db-hashed;
  my $table-hashed;
  my $conditions;
  my $tables;
  my $hash-values;
  
  for %entries.kv -> $key, $value {
    given $key {
      when "db" { $db-hashed = $value; }
      when "condition" { $conditions = $value; }
      when "tables" { $tables = $value; }
      when "values" { $hash-values = $value; }
     }
  }
  
  my $fh = open "/home/ubuntu/dev/futs/scripts/base/" ~ $db-hashed ~ ".pl", :w;

  my $code = qq:to/END/;
#!/usr/bin/env perl6
use v6;
use JSON::Class;

$conditions

sub MAIN\( Operator :\$op, *%kv ) \{
  for %kv.kv -> \$key, \$value \{
    if \$value eq "all" \{
      get-json\( WHERE => \$key, EQUALS => \$value, op => "all" );
    } else \{
      get-json\( WHERE => \$key, EQUALS => \$value, op => \$op );
    }
  }
}

$tables

$hash-values;

multi sub get-json\( :\$WHERE, :\$EQUALS, Operator :\$op ) \{
  my @json;
  given \$op \{
    when "all" \{
      for %hash-set\{\$EQUALS}.kv -> \$key, \$value \{
        @json.push\( \$value.to-json() );
      }
    }
    when "eq" \{
      @json.push\( %hash-set\{\$WHERE}\{\$EQUALS}.to-json() );
    }
  }
  if @json.elems \{ print '[' ~ @json.join\(',') ~ ']'; }
}
END
  
  $fh.print( $code );
    
}

