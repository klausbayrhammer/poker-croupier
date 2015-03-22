poker-croupier
==============

[![Build Status](https://travis-ci.org/lean-poker/poker-croupier.png?branch=master)](https://travis-ci.org/lean-poker/poker-croupier) [![Code Climate](https://codeclimate.com/github/lean-poker/poker-croupier.png)](https://codeclimate.com/github/lean-poker/poker-croupier) [![Code Coverage](https://codeclimate.com/github/lean-poker/poker-croupier/coverage.png)](https://codeclimate.com/github/lean-poker/poker-croupier) [![Dependency Status](https://gemnasium.com/lean-poker/poker-croupier.png)](https://gemnasium.com/lean-poker/poker-croupier)

Robot poker croupier for lean poker tournaments, an event much like a coderetreat, but with a slightly different format and purpose.

Twitter: https://twitter.com/LeanPoker

Facebook: https://www.facebook.com/leanpoker

## What is Lean Poker?

A lot of companies have jumped on the Lean Startup band wagon lately, but many struggle with implementing the tight feedback loops it builds on. The purpose of Lean Poker, is to generate an artificial environment where developers can quickly experiment with continous delivery and other practices that help with thightinging the feedback loop. Durring the day, you will learn how to achieve a build measure learn cycle on the order of mere minutes.

Our problem domain is building a poker robot that plays sit'n'gos of Texsas Holdem, but don't worry, you don't need to know the rules of poker, we will explain what you need to know. (Also: no real money is involved.) The catch is that the robots start playing against each other the minute teams start coding. From that moment on, every few seconds the robots will play a sit'n'go, and the two winners are awarded points. This means that every few seconds you either gain on the other teams or loose. This puts enourmous preasure on teams to deploy as often and as soon as possible. 

Professional poker robots are developed for years, so the purpose is definitely not to come up with something really smart, but to be the smartest among the current competitors. With this in mind teams can come up with simple-to-implement heuristics, examine their effect on game play, and then improve their algorithm in a similar, lean fashion.

Teams will be formed at the start of the day. The teams have 60 minute sessions when they are allowed to code. After each session there is a break, during which some highlights of the games played by the robots are shown on a screen. Before the break there is a quick retrospective stand up meeting that looks back on the previous session.

What you will need: 
- A laptop 
- Compiler / Interpreter for your favourite language
- A good editor or IDE
- Optionally: your favourite keyboard and mouse, so that you feel confortable while coding

### Videos

- Budapest, 2014. March: https://www.youtube.com/watch?v=ZMvhzj85ISM
- Vienna, 2014. April: https://www.youtube.com/watch?v=TDtk3Fh2A-A

### Blogs

- http://c0de-x.com/how-playing-poker-can-teach-you-lean-and-continuous-delivery/
- https://athos.blogs.balabit.com/2014/02/lean-poker-code-retreat/

## The rules

There are not many rules, but please keep them in mind. All rules of no limit Texas hold'em apply.

One of the most important rules is that there is no explicit prize for the winner (the other teams however are free to invite them for a beer after the event). Lean poker - although it has a competitive feel to it - is not a competition. The emphasis should be on practice.

Another important rule is fair play: no one should try to exploit weaknesses of the framework, or deliberately inject back doors into its source code. Also - with some notable exceptions listed below - no team should use any pre-written code.

As with any coderetreat like event: provide a free lunch but avoid pizza.

### Notes on the usage of 3rd party code and fair play

We would like to avoid a situation where one team has a huge advantage over the others due to a library that solves some part of the problem. For that reason the rule of thumb is that only the language's standard library, and open source libraries are allowed. Similarly, only opensource data files can be used. Proprietary libraries and files are banned under all conditions.

# How to write a player

We try to provide the folding player (a player that folds or checks under all conditions) for as many languages as we can. Each of them is in a separate git repository, so that participants can simply fork them, and start working on their algorithms right away. Please check out the [Player API documentation](https://github.com/lean-poker/poker-croupier/wiki/Player-API) for the details.

There is also a ranking service. Players are welcome to use it. See the [Rainman service](https://github.com/lean-poker/rainman) for details.

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


