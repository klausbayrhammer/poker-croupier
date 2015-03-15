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

We would like to avoid a situation where one team has a huge advantage over the others due to a library that solves some part of the problem. For that reason the rule of thumb is that only the language's standard library, and general purpose open source libraries are allowed.

#### Exceptions

For a library to qualify for the below exceptions, it should be publicly available and opensource. Proprietary libraries are banned under all conditions.

- The folding player provided for each language.
- In the case of C++ the Boost library is allowed, since otherwise C++ would be handicapped against languages like Java and python that have more potent standard libraries. Similarly in other languages where the standard library is small - like JavaScript - public packages are allowed as long as they are reasonably general purpose.
- If in doubt, then the team should ask the other teams if they allow them to use a particular library. In the name of fair play, other teams should allow the usage of the library if it does not give the other team an unfair advantage. In situations of a debate among teams, the facilitator should try to settle it, or as a last resort make a decision.

# How to write a player

We try to provide the folding player (a player that folds or checks under all conditions) for as many languages as we can. Each of them is in a separate git repository, so that participants can simply fork them, and start working on their algorithms right away. Please check out the [Player API documentation](https://github.com/lean-poker/poker-croupier/wiki/Player-API) for the details.

There is also a ranking service running during the game, that the players are welcome to use. See the [Ranking API documentation](https://github.com/lean-poker/poker-croupier/wiki/Ranking-API) for details.

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

Furthermore you should have the following files that the deployment script will use:
- start.sh - It should start your service.
- stop.sh - It should stop the service.
- config.yml - It should contain the URL on which your service can be accessed when it's running.

# How to get started as a contributor

Check the [issues section](https://github.com/devill/poker-croupier/issues) for current tasks. We also have a [mailing list at Google groups](https://groups.google.com/forum/?hl=en#!forum/poker-croupier-developers). To understand the project structure, read the [architectural guide](https://github.com/devill/poker-croupier/wiki/Architectural-guide).

When implementing rules, consult the Texas Hold'em rules in [English](http://www.pokerstars.com/poker/games/texas-holdem/) or  [Hungarian](http://www.pokerstars.hu/poker/games/texas-holdem/) and poker hand ranks in [English](http://www.pokerstars.com/poker/games/rules/hand-rankings/) or [Hungarian](http://www.pokerstars.hu/poker/games/rules/hand-rankings/)  pages on PokerStars. We wish to play sit-n-go tournaments of No Limit Texas Hold'em.

Helpful links
- [Glossary of poker terms](http://en.wikipedia.org/wiki/Glossary_of_poker_terms)
- [Poker gameplay and terminology](http://en.wikipedia.org/wiki/Category:Poker_gameplay_and_terminology)
- [Poker tournament](http://en.wikipedia.org/wiki/Poker_tournament)

## Setting up your development environment

- Clone the git repo
- Install [rvm](http://rvm.io/) and ruby 2.1.0: `\curl -L https://get.rvm.io | bash -s stable --ruby=2.1.0`
- Install bundler: `gem install bundler`
- Install necessary gems with bundler: `bundle`
- Test your environment by running the unit tests: `rake test`

And that's it! You are all set to go.

## Running the application

At this point we do not yet have rake targets or integration tests that can help in taking the services for a spin. That means that, although there are tests for each service, after changes it's worth running a manual sanity check. The way I do it now: `bundle exec ruby croupier/scripts/integration_test.rb`

If you wish to hold a poker tournament then there is another script - `croupier/script/start_tournament.rb` - that you can modify and run. It lets you specify the log file, hosts and ports for each player.

In order to start the ranking service use `ruby ranking_service/ranking_service.rb`. (Note that the ranking service is automatically started by the croupier when a tournament is started.)

## Watching the results

During gameplay the croupier collects all game related data and serializes it into the `log/` directory. You can replay any of them with the visual spectator. Just start it:

    bundle exec ruby visual_spectator/app.rb -p 2000

[Bon appetite](http://localhost:2000).

### Previous events

If you wish to watch games from previous events, you can download the logs from [the previous events page on leanpoker.org](http://leanpoker.org/previous_events/). Just unpack the archive, and copy it's contents into your log directory.

The visual spectator is not entirely backwards compatible, so you may have issues watching some of the first few games. You can either revert to an earlier version of poker-croupier, or try to migrate the files. If you do migrate them, then please send the migrated files to [DeVill](https://github.com/devill) so that the archive can be updated.
