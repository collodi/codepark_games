# codepark_games
all games available on codepark

# Directory Structure of A Game
A game should have a directory structure of

    games/
    |
    | <game_name>_refree.rb
    | <game_name>.rb
    | <game_name>/
        | <class files, etc>
    |
    | parkutil.rb
    | parkutil/

# Dependencies Between User Codes And Game Files

Your `<game_name>_refree.rb` is a single program that will be executed to run the game.
The `uid` of the player(s) will be given as command line arguments like this:

    ruby <game_name>_refree.rb uid1 uid2 ...

and the files submitted by each user will take the form of `<uid>/<game_name>.rb` within a designated system directory.

The main file `<game_name>_refree.rb` should keep scores, produce game results, and optionally log intermediate metadata of the game.

# Inside <game_name>_refree.rb

## Parkutil Module
`Parkutil` module contains useful functions and exceptions relevant to managing a game.
If writing a codepark game, you should use this pakcage to interact with the player instances.
The module can be used like this:

    require_relative 'parkutil'
  
and every game should be implemented in Ruby (current version 2.4.0).

## Initializing A Game
Your `<game_name>.rb` file may contain all dependencies from the `<game_name>/` directory by doing `require_relative <game_name>/<class>`. Then, you will be able to use all your classes inside your refree file by doing `require_relative <game_name>`.

In every `<game_name>_refree.rb`, you should check for all the necessary functions for a game by using `register_function(name, argnum)` function in `Parkutil` module. Registering necessary functions should be done before calling `load_players()`, which loads player instances. `Parkutil` will check for the existence of a function `name` taking `argnum` number of arguments when loading player instances.

## Loading Player Instances
`load_players(min number of players, max number of players)` function in `Parkutil` module returns a list of player instances. When max is missing, the function will look for exactly the minimum number of players.  
This function throws following exceptions:
 - Parkutil::NotEnoughPlayers
 - Parkutil::TooManyPlayers
 - Parkutil::PlayersHomeNotSet (raised if environment variable 'CODEPARK_PLAYERS_HOME' does not exists)
 - Parkutil::PlayerNotFound
 - Parkutil::IncompleteImplementation (raised if a player does not have all required functions)
 - Parkutil::MismatchingFunctionSignature (raised if a player's required function takes in a wrong number of arguments)

## Addional Helper Methods
 - Parkutil.count_players - returns the number of players loaded
 - Parkutil.player(i) - returns the instance of a player at position i (starting at 0)
 - Parkutil.current_player - returns the instance of a player at current turn 
 - Parkutil.turn(i = 0) - returns the index of a player at turn + i (e.g. i = -1 returns previous player's index)  
 - Parkutil.advance_turn - advances one turn, and returns the index of a player at the advanced turn

## Setting Player Function Timeouts
To prevent player functions from delaying the game, they run with a timeout.
Each player instance has its own timeout constant `timeout_sec` with a default value of 1 (seconds), and this variable may be rewritten by a refree. `Parkutil::ClockTimeout` will be raised if a player function does not terminate within the time limit.

## Implementation Example
For a game implementation example, look at the game `Battleship`. 
