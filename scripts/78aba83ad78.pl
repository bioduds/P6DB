#!/usr/bin/env perl6
use v6;
use JSON::Class;

subset IdentStr of Str where /^<.ident>$/;
subset Gênero of Str where * eq "Homem"|"Mulher";
subset RateTécnico where (0.0..5.0)|"-";
subset Operator of Str where "all"|"eq"|"gt"|"lt";

sub MAIN( Operator :$op, *%kv ) {
  for %kv.kv -> $key, $value {
    if $value eq "all" {
      get-json( WHERE => $key, EQUALS => $value, op => "all" );
    } else {
      get-json( WHERE => $key, EQUALS => $value, op => $op );
    }
  }
}

class Técnico does JSON::Class {
  my $.identidade = "f5dad591ca";
  has $.nome is required;
  has Gênero $.gênero is required;
  has Int $.idade is required;
  has RateTécnico $.rate is required;
}
class Time does JSON::Class {
  my $.identidade = "8acde4d6a5";
  has $.nome is required;
  has Str $.país is required;
}

my %hash-set  =  "f5dad591ca" => { "Marcelo Oliveira" => Técnico.new( nome=>"Marcelo Oliveira", gênero=>"Homem", idade=>49, rate=>3.88 ), 
                                   "Levir Culpi" => Técnico.new( nome=>"Levir Culpi", gênero=>"Homem", idade=>52, rate=>4.12 ),
                                   "Cuca" => Técnico.new( nome=>"Cuca", gênero=>"Homem", idade=>49, rate=>"-" ) }, 
                 "8acde4d6a5" => { "Clube Atlético Mineiro" => Time.new( nome=>"Clube Atlético Mineiro", país=>"Brasil" ),
                                   "Esporte Clube Corinthians" => Time.new( nome=>"Esporte Clube Corinthians", país=>"Brasil" ) };

multi sub get-json( :$WHERE, :$EQUALS, Operator :$op ) {
  my @json;
  given $op {
    when "all" {
      for %hash-set{$EQUALS}.kv -> $key, $value {
        @json.push( $value.to-json() );
      }
    }
    when "eq" {
      @json.push( %hash-set{$WHERE}{$EQUALS}.to-json() );
    }
  }
  if @json.elems { print '[' ~ @json.join(',') ~ ']'; }
}
