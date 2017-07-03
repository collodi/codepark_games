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
    | painters/
        | <game_name>_painter.js (optional)

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

The following exceptions will be handled within `Parkutil`:
 - Parkutil::IncompleteImplementation (raised if a player does not have all required functions)
 - Parkutil::MismatchingFunctionSignature (raised if a player's required function takes in a wrong number of arguments)

## Addional Helper Methods
 - Parkutil.count_players - returns the number of players loaded
 - Parkutil.player(i) - returns the instance of a player at position i (starting at 0)
 - Parkutil.current_player - returns the instance of a player at current turn
 - Parkutil.turn(i = 0) - returns the index of a player at turn + i (e.g. i = -1 returns previous player's index)
 - Parkutil.advance_turn - advances one turn, and returns the index of a player at the advanced turn
 - Parkutil.print_exception(e) - prints an exception, e, in a unifying format across games

## Setting Player Function Timeouts
To prevent player functions from delaying the game, they run with a timeout.
Each player instance has its own timeout constant `timeout_sec` with a default value of 1 (seconds), and this variable may be rewritten by a refree. `Parkutil::ClockTimeout` will be raised if a player function does not terminate within the time limit.

## Logging Plays
To help the users analyize their code, `codepark` implements a method to show the gameplays. The refrees may log players' moves through `Parkutil::GameLogger` class. The `GameLogger` has the `log` method that takes any number of arguments. The `GameLogger` class may be initiated with any number of arguments. See [here](#drawing-gameplays) for more explanation.

## Output of A Game
There are three possible outcomes of a game. They are `winner determined`, `draw`, and `exception`.

When there is a winner, the refree should
 1. print uid of the winner to `stdout`
 2. print nothing to `stderr`
 2. exit with a code 0

If the game ended in a draw, the refree should
 1. print nothing to `stdout` or `stderr`
 2. exit with a code 2

If there was an exception (besides `Parkutil::ClockTimeout`) while executing a player's method, the refree should
 1. print uid of the player who caused the exception to `stdout`
 2. print exception message using `Parkutil.print_exception(e)`
 3. exit with a code 1 immediately

Note that refrees should only print what is instructed throughout the game and nothing else. When printing to `stdout` or `stderr`, either `puts` or `print` should be used. Please do not use `p` to print.

## Implementation Example
For a game implementation example, look at `Battleship`.

# Drawing Gameplays
If you utilize `Parkutil::GameLogger` in your refree, you can use your `<game_name>_painter.js` file to draw the gameplays for the players. The `painter` file should contain [`paper.js`](http://paperjs.org/) code. Your code in `paper.js` will be automatically linked to one canvas. Your file should contain 3 top-level functions: `draw_game_set`, `draw_next_move`, and `draw_reverse_move`.

`draw_game_set` should draw the game environment (such as a board). It will only be called one time at the beginning, and the arguments you passed to `GameLogger::new` will be passed in an array (e.g. if you called `GameLogger.new(width, height)` in the refree file, `draw_game_set([width, height])` will be called).

`draw_next_move` should draw each move of the players on the canvas, and arguments you passed to `GameLogger::log` in each call will be passed in an array.

`draw_reverse_move` should reverse the last draw on the canvas, and it has no arguments.

For an example, look at `connect_four`.
