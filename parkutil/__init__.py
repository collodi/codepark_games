import os
import sys
import signal
import inspect
import importlib
from parkutil.exceptions import *

timeout_sec = 1
registered_functions = None

def version_check():
    if sys.version_info < (3, 0):
        raise IncompatiblePythonVersion('Codepark needs python >= 3.x')

def init():
    global registered_functions
    registered_functions = {}
    signal.signal(signal.SIGALRM, timed_out)

def timed_out(n, frame):
    raise ClockTimeout()

def register_function(funcname, argnum):
    registered_functions[funcname] = argnum

def get_players(minn, maxn=None):
    gamename = os.path.basename(sys.argv[0])[:-3]
    if len(sys.argv) - 1 < minn:
        raise NotEnoughPlayers('Need at least %s players to play %s' % (minn, gamename))

    if maxn == None:
        maxn = minn
    if len(sys.argv) - 1 > maxn:
        raise TooManyPlayers('Only %s players can play %s at once' % (maxn, gamename))
    else:
        maxn = len(sys.argv) - 1

    players = []
    for i in range(maxn):
        pname = sys.argv[i + 1]
        p = None
        try:
            p = importlib.import_module('%s.players.%s' % (gamename, pname))
        except ModuleNotFoundError:
            raise PlayerNotFound('Player %s is not found' % pname)

        for f, argn in registered_functions.items():
            if not hasattr(p, f):
                raise IncompleteImplementation('Player %s does not have a required function \'%s\'' % (pname, f))
            elif len(inspect.signature(getattr(p, f)).parameters) != argn:
                raise MismatchingFunctionSignature('Player function \'%s\' should have %s arguments' % (f, argn))
        players.append(PlayerWrapper(p))
    return players

def player_name(pnum):
    try:
        return sys.argv[pnum]
    except IndexError:
        raise PlayerNotFound('Player #%s is not found' % pnum)

def set_timeout(sec):
    timeout_sec = 1 if sec > 3 or sec < 0 else sec

def reset_clock(sec):
    signal.alarm(0)
    signal.alarm(sec)

def stop_clock():
    signal.alarm(0)

class PlayerWrapper:
    def __init__(self, p):
        self.p = p

    def __getattr__(self, name):
        def timeout_call(*args, **kwargs):
            f = getattr(self.p, name)
            if callable(f):
                reset_clock(timeout_sec)
                try:
                    return f(*args, **kwargs)
                finally:
                    stop_clock()
            else:
                return f
        return timeout_call

version_check()
init()
