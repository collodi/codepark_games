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
The `uid` of the player(s) will be given as command line arguments like this,

    ruby <game_name>_refree.rb <uid1> <uid2>

and the player who initiated the game will be `<uid2>` (`<uid1>` goes first in the game by default).
Files submitted by each user will take the form of `<uid>/<game_name>.rb` within a designated system directory.

The main file `<game_name>_refree.rb` should keep scores, produce game results, and optionally log intermediate metadata of the game.

# Inside <game_name>_refree.rb

## Parkutil Module
`Parkutil` module contains useful functions and exceptions relevant to managing a game.
If writing a codepark game, you should use this pakcage to interact with the player instances.
The module can be used like this:

    require_relative 'parkutil'
  
and every game should be implemented in Ruby (current version 2.3.4).

## Initializing A Game
Your `<game_name>.rb` file may contain all dependencies from the `<game_name>/` directory by doing `require_relative <game_name>/<class>`. Then, you will be able to use all your classes inside your refree file by doing `require_relative <game_name>`.

In every `<game_name>_refree.rb`, you should check for all the necessary functions for a game by using `register_function(name, argnum)` function in `Parkutil` module. Registering necessary functions should be done before calling `load_players()`, which loads player instances. `Parkutil` will check for the existence of a function `name` taking `argnum` number of arguments when loading player instances.

## Sandboxing Users
Player functions are automatically sandboxed with [shikashi gem](https://github.com/tario/shikashi). Basic mathematical functionalities are allowed by default. However, if you require players to be able to access a custom class, you can use `register_class(name)` function in `Parkutil` module before calling `load_players()`. This will allow players to call any method in that class. `Parkutil::PermissionDenied` will be raised if a player function goes off the limit.

For example, for the game `Battleship`, players need access to `Battleship::Block` class, and so `register_class(Battleship::Block)` will be called in the `battleship_refree.rb` file before calling `load_players()`.

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

## Output of A Game
There are three possible outcomes of a game. They are `winner determined`, `draw`, and `exception`.

When there is a winner, the refree should 
 1. print uid of the winner to `stdout`
 2. print nothing to `stderr`
 2. exit with a code 0
 
If the game ended in a draw, the refree should
 1. print nothing to `stdout` or `stderr`
 2. exit with a code 1
 
If there was an exception (besides `Parkutil::ClockTimeout`) while executing a player's method, the refree should
 1. print uid of the player who caused the exception to `stdout`
 2. print exception message (backtrace is allowed) to `stderr`
 3. exit with a code 2 immediately
 
Note that refrees should only print what is instructed throughout the game and nothing else. When printing to `stdout` or `stderr`, either `puts` or `print` should be used. Please do not use `p` to print.

## Implementation Example
For a game implementation example, look at the game `Battleship`. 
