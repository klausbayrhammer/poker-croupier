poker-croupier
==============

[![Build Status](https://travis-ci.org/lean-poker/poker-croupier.png?branch=master)](https://travis-ci.org/lean-poker/poker-croupier) [![Code Climate](https://codeclimate.com/github/lean-poker/poker-croupier.png)](https://codeclimate.com/github/lean-poker/poker-croupier) [![Code Coverage](https://codeclimate.com/github/lean-poker/poker-croupier/coverage.png)](https://codeclimate.com/github/lean-poker/poker-croupier) [![Dependency Status](https://gemnasium.com/lean-poker/poker-croupier.png)](https://gemnasium.com/lean-poker/poker-croupier)

Robot poker croupier for lean poker tournaments, an event much like a coderetreat, but with a slightly different format and purpose.

[See our website for more details](http://leanpoker.org)

# How to write a player

We try to provide the folding player (a player that folds or checks under all conditions) for as many languages as we can. Each of them is in a separate git repository, so that participants can simply fork them, and start working on their algorithms right away. Please check out the [Player API documentation](https://github.com/lean-poker/poker-croupier/wiki/Player-API) for the details.

There is also a ranking service. Players are welcome to use it. See the [Rain Man service](https://github.com/lean-poker/rainman) for details.

Currently supported languages:
- [Clojure](https://github.com/lean-poker/poker-player-clojure)
- [C++](https://github.com/lean-poker/poker-player-cpp)
- [Groovy](https://github.com/lean-poker/poker-player-groovy)
- [Java](http://github.com/lean-poker/poker-player-java)
- [JavaScript](http://github.com/lean-poker/poker-player-js)
- [PHP](http://github.com/lean-poker/poker-player-php)
- [Python](https://github.com/lean-poker/poker-player-python)
- [Ruby](http://github.com/lean-poker/poker-player-ruby)

Languages that need update to become supported:
- [C#](https://github.com/peitor/poker-player-csharp) (Needs update to work with mono)
- [Go](https://github.com/ziegfried/poker-player-go)
- [Haskell](https://github.com/lean-poker/poker-player-haskell)
- [Perl](http://github.com/ferki/poker-player-perl)
- [R](https://github.com/chochkov/poker-player-R)
- [Scala](https://github.com/klausbayrhammer/poker-player-scala)

The language frameworks above need to be updated to be Heroku ready. If you can push it to Heroku, and it works out of the box, then it can be added to supported languages. 

### How to create a folding player

The players are simple REST services. You should have the following files:
- A file, usually called player\_service, that will take care of routing the requests to an object called player. The current game state sent as a POST variable named game\_state in JSON format. The game\_state needs to be decoded into a dynamic structure. The action POST variable specifies which function of the player is to be called. (Currently the only action is bet_request.)
- The other file is usually called player, and contains a Player class (or equivalent structure in languages where there are no classes) with a single bet_request function, that returns 0.

The service should run out of the box when it is pushed to Heroku. If Heroku does not support your choice of language, and it is not possible to create a custom build pack, then it is possible to use a custom deployer service. It should implement the same interface as the [Hermes service](https://github.com/lean-poker/hermes)

# Links

When implementing rules, consult the Texas Hold'em rules in [English](http://www.pokerstars.com/poker/games/texas-holdem/) or  [Hungarian](http://www.pokerstars.hu/poker/games/texas-holdem/) and poker hand ranks in [English](http://www.pokerstars.com/poker/games/rules/hand-rankings/) or [Hungarian](http://www.pokerstars.hu/poker/games/rules/hand-rankings/)  pages on PokerStars. We wish to play sit-n-go tournaments of No Limit Texas Hold'em.

Helpful links
- [Glossary of poker terms](http://en.wikipedia.org/wiki/Glossary_of_poker_terms)
- [Poker gameplay and terminology](http://en.wikipedia.org/wiki/Category:Poker_gameplay_and_terminology)
- [Poker tournament](http://en.wikipedia.org/wiki/Poker_tournament)


