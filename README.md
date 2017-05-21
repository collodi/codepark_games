# codepark_games
all games available on codepark

# Directory Structure of A Game

  A game should have a directory structure of

    games/
    |
    | <game name>.py
    | <game name>/
      | __init__.py
      | players/
        | <... player names...>
      | <subpackages, files, etc.>

  All files for a game that are not <game name>.py should be inside its corresponding <game name>/ folder.
  The goal is to keep the games/ folder to have one file and one folder for each game.

# Dependencies Between User Codes And Game Files

  Your `<game name>.py` is a single program that will be executed to run the game.
  The usernames of the player(s) that are playing the game will be given as command line arguments like this:

    python3 <game name>.py username1 username2 ...

  and the files submitted by each user will take the form of `<username>.py` in `<game name>/players/` for each game.

  The main file should keep scores, produce game results, and optionally log intermediate metadata of the game.

# Inside <game name>.py

## parkutil package
  `parkutil` package contains useful functions and exceptions relevant to managing a game.
  Your game should use this pakcage to interact with the player instances in order to be admitted as a codepark game.
  The package can be used like this:

    import parkutil
    from parkutil.exceptions import *
  
  Every game should be implemented in Python 3.x. Any Python version less than 3.x will be rejected.

## initializing a game
  In every `<game name>.py`, it is strongly recommended to check for the necessary functions for a game by using `register_function(name, argnum)` function in `parkutil` package.
  `name` is a required argument, and tells to check for the existence of a function with `name`.
  `argnum` is a required argument, and signifies the exact number of arguments needed for the function `name`.
  Registering necessary functions should be done before getting the player instances.

## getting player instances
  The instances of players can be obtained using `get_players(minn, maxn)` function in `parkutil` package.
  `minn` is a required argument, and tells the function the minimum number of players.
  `maxn` is an optional argument, and tell the function the maximum number of players.
  If `max` is not specified, the function will assume that exactly `minn` number of players are needed.

## getting the username of a player
  When the username of a player is needed, use `player_name(pnum)` function in `parkutil` package.
  `pnum` is the player number, which starts from 1.

## setting player function timeouts
  All player functions will be run with a time. `(0 < timeout <= 3)`
  Timeouts can be set with `set_timeout()` function in `parkutil` package.
  Every call to a user function will raise a `parkutil.exceptions.ClockTimeout` exception after `timeout`.
  If no timeout was set by the game, it will default to 1.

## using the timeout clock manually
  `parkutil`'s timeout can be set with `reset_clock(sec)` function.
  `sec` is a reqired argument, and tells the function to generate a `parkutil.exceptions.ClockTimeout` exception after `sec` seconds.
  
  If the timeout exception is no longer needed before it's raised, you should terminate the running clock with `stop_clock()` function.

  You cannot register more than one timeout at the same time. In other words, the manual use of the `parkutil` timeout cannot overlap with the player function calls. The player function calls will override the previously registered timeouts.
