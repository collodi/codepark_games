# codepark_games
all games available on codepark

# Directory Structure of A Game
A game should have a directory structure of

    games/
    |
    | <game name>_refree.py
    | <game name>/
      | __init__.py
      | <subpackages, modules, etc.>

All files, except the refree file, should be inside its corresponding <game name>/ directory.

# Dependencies Between User Codes And Game Files

Your `<game name>_refree.py` is a single program that will be executed to run the game.
The `uid` of the player(s) will be given as command line arguments like this:

    python2.7 <game name>_refree.py uid1 uid2 ...

and the files submitted by each user will take the form of `<uid>/<game name>.py` within a designated system directory.

The main file `<game name>_refree.py` should keep scores, produce game results, and optionally log intermediate metadata of the game.

# Inside <game name>_refree.py

## parkutil package
`parkutil` package contains useful functions and exceptions relevant to managing a game.
If writing a codepark game, you should use this pakcage to interact with the player instances.
The package can be used like this:

    import parkutil
    from parkutil.exceptions import *
  
and every game should be implemented in Python 2.7.

## initializing a game
In every `<game name>_refree.py`, you should check for the necessary functions for a game by using `register_function(name, argnum)` function in `parkutil` package. Registering necessary functions should be done before calling `get_players()`, which get you player instances. `parkutil` will check for the existence of a function `name` taking `argnum` number of arguments when loading player instances.

## getting player instances
`get_players(min number of players, max number of players)` function in `parkutil` package returns a list of player instances. When max is missing, the function will look for exactly the minimum number of players.  
This function throws following exceptions.
 - parkutil.exceptions.NotEnoughPlayers
 - parkutil.exceptions.TooManyPlayers
 - parkutil.exceptions.PlayersHomeNotSet (raised if environment variable 'CODEPARK_PLAYERS_HOME' does not exists)
 - parkutil.exceptions.PlayerNotFound
 - parkutil.exceptions.IncompleteImplementation (raised if a player does not have all required functions)
 - parkutil.exceptions.MismatchingFunctionSignature (raised if a player's required function takes in a wrong number of arguments)

## getting the uid of a player
Each player instance returned from `get_players()` has a `uid` attribute.

## setting player function timeouts
To prevent player functions from delaying the game, they run with a timeout.
Each player instance has its own timeout constant `timeout_sec` with a default value of 1 (in seconds), and `parkutil.exceptions.ClockTimeout` will be raised if a player function does not terminate within the time limit.
