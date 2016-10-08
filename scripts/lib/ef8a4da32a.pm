# Eduardo Capanema
unit module ef8a4da32a;
use JSON::Class;

my &infix:<++> = &infix:<~>;
subset IdentStr of Str where /^<.ident>$/;
subset Gênero of Str where * eq "Homem"|"Mulher";

class Técnico does JSON::Class {
  my $.identidade = "Técnico";
  has $.nome;
  has Gênero $.gênero;
  has Int $.idade;
  has Rat $.rate;
}


sub ef8a4da32a-get-json is export {
  my @técnicos = Técnico.new( nome => "Marcelo Oliveira", gênero => "Homem", idade => 54, rate => 3.88 ), 
                 Técnico.new( nome => "Levir Culpi", gênero => "Homem", idade => 52, rate => 4.12 );
  return @técnicos[0].to-json();
}
