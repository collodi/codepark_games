import os
import sys
import signal
import inspect
import importlib

from parkutil.exceptions import *

timeout_sec = 1
registered_functions = None

def init():
    global registered_functions
    registered_functions = {}
    signal.signal(signal.SIGALRM, timed_out)

def timed_out(n, frame):
    raise ClockTimeout()

def register_function(funcname, argnum):
    registered_functions[funcname] = argnum

def get_players(minn, maxn=None):
    gamename = 'battleship' # TODO

    # check min number
    if len(sys.argv) - 1 < minn:
        raise NotEnoughPlayers('Need at least %s players to play %s' % (minn, gamename))
    # check max numer
    if maxn == None:
        maxn = minn
    if len(sys.argv) - 1 > maxn:
        raise TooManyPlayers('Only %s players can play %s at once' % (maxn, gamename))

    # add players directory to sys path
    players_home = os.getenv('CODEPARK_PLAYERS_HOME', None)
    if players_home == None:
        raise PlayersHomeNotSet('The environment variable \'CODEPARK_PLAYERS_HOME\' is not set')
    sys.path.append(players_home)

    players = []
    for uid in sys.argv[1:]:
        # try:
        p = importlib.import_module('%s.%s' % (uid, gamename))
        players.append(PlayerWrapper(p, uid))

        for f, argn in registered_functions.items():
            if not hasattr(p, f):
                raise IncompleteImplementation('Player %s does not have a required function \'%s\'' % (uid, f))
            elif len(inspect.getargspec(getattr(p, f))[0]) != argn:
                raise MismatchingFunctionSignature('Player function \'%s\' should have %s arguments' % (f, argn))
        # except ModuleNotFoundError:
        #     raise PlayerNotFound('User with uid %s doesn\'t have a player for this game.' % uid)

    return players

class PlayerWrapper:
    def __init__(self, p, uid):
        self.p = p
        self.uid = uid
        self.timeout_sec = 1

    def __getattr__(self, name):
        def timeout_call(*args, **kwargs):
            f = getattr(self.p, name)
            if callable(f):
                signal.alarm(self.timeout_sec)
                try:
                    return f(*args, **kwargs)
                finally:
                    signal.alarm(0)
            else:
                return f
        return timeout_call

init()
