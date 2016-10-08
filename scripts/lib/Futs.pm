# Eduardo Capanema
unit module Futs;

my &infix:<++> = &infix:<~>;
subset IdentStr of Str where /^<.ident>$/;
subset Gênero of Str where * eq "Homem"|"Mulher";

class Pessoa {
  has $.nome;
  has Gênero $.gênero;
}

class Técnico is Pessoa {  
  has $.experiência;
}

class Jogador is Pessoa {
  has $.posição;
}

class Time {
  has $.nome;
  has $.jogadores;
  has Técnico $.técnico is rw;
  has $.escudo;
  has $.cidade;
  has $.país;

  method sobre {
    say "Meu nome é: $.nome";
    say "Meu técnico é: " ~ $.técnico.nome;
  }
}

class Campeonato {  
  has $.nome;
  has Time @.times;
  
  method times-inscritos {
    say "Times do Campeonato: " ~ $.nome;
    for @.times -> $time {
      say $time.nome;
    }
  }
}

