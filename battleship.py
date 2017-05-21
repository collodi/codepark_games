import sys
import parkutil
from parkutil.exceptions import *

class battleship_board:
    def __init__(self, w, h):
        self.board = [[0 for i in range(w)] for j in range(h)]
        self.attacked = [[0 for i in range(w)] for j in range(h)]
        self.lastspot = (None, None)
        self.sank = 0
        self.shiplens = (4, 3, 3, 2, 2, 2, 1, 1, 1, 1)
        self.directions = { 'N': (-1, 0), 'E': (0, 1), 'S': (1, 0), 'W': (0, -1) }
        self.shipcnt = sum(self.shiplens)

    def valid_attack(self, t):
        try:
            if not (isinstance(t, tuple) and isinstance(t[0], int) and isinstance(t[1], int)):
                return False
            if t[0] < 0 or t[1] < 0:
                return False
            if self.attacked[t[0]][t[1]] != 0: # already attacked
                return False
        except IndexError:
            return False
        return True

    def place(self, ship, size, mark):
        if not isinstance(ship, tuple) or len(ship) < 3:
            return False
        if not (isinstance(ship[0], int) and isinstance(ship[1], int) and isinstance(ship[2], str) and len(ship[2]) and ship[2].upper() in self.directions):
            return False

        r, c, d = ship
        dr, dc = self.directions[d]
        for i in range(size):
            if r < 0 or r >= len(self.board) or c < 0 or c >= len(self.board[0]):
                return False
            if self.board[r][c] != 0:
                return False
            
            self.board[r][c] = mark
            r += dr
            c += dc
        return True

    def near_uniq(self, r, c, v):
        if self.board[r][c] == 0:
            return True
        
        right = c + 1 < len(self.board[0])
        down = r + 1 < len(self.board)
        if right and self.board[r][c+1] not in [0, v]:
            return False
        if right and down and self.board[r+1][c+1] not in [0, v]:
            return False
        if down and self.board[r+1][c] not in [0, v]:
            return False
        if down and c - 1 >= 0 and self.board[r+1][c-1] not in [0, v]:
            return False
        return True

    def board_valid(self):
        for r in range(len(self.board)):
            for c in range(len(self.board[0])):
                if not self.near_uniq(r, c, self.board[r][c]):
                    return False
        return True

    def normalize_board(self):
        for r in range(len(self.board)):
            for c in range(len(self.board[0])):
                if self.board[r][c]:
                    self.board[r][c] = 1

    def deploy(self, ships):
        if len(ships) < len(self.shiplens):
            return False
        
        for i in range(len(self.shiplens)):
            if not self.place(ships[i], self.shiplens[i], i + 1):
                self.erase_board()
                return False

        if not self.board_valid():
            self.erase_board()
            return False
        else:
            self.normalize_board()
            return True

    def erase_board(self):
        w, h = len(self.board), len(self.board[0])
        self.board = [[0 for i in range(w)] for j in range(h)]
        self.attacked = [[0 for i in range(w)] for j in range(h)]

    def attack(self, tup):
        if not self.valid_attack(tup):
            return False
        
        r, c = tup
        self.sank += self.board[r][c]
        self.attacked[r][c] = self.board[r][c] + 1 # 1 if fail, 2 if success
        self.board[r][c] += 2 # 2 if water, 3 if ship
        self.lastspot = tup
        return True

    def gameover(self):
        return self.sank == self.shipcnt

class battleship:
    def __init__(self, w, h):
        parkutil.register_function('deploy', 2)
        parkutil.register_function('play', 5)
        self.players = parkutil.get_players(2)

        self.turn = False # player 1 goes first
        self.skipped = 0
        self.boards = [battleship_board(w, h) for i in range(len(self.players))]
        self.board_dim = (w, h)

    def start(self):
        deployed = [self.deploy(i) for i in range(len(self.players))]
        if not (deployed[0] or deployed[1]):
            print ('Invalid game. Both players failed to deploy.')
            return
        elif deployed[0] ^ deployed[1]:
            for i in range(len(deployed)):
                print ('%s won!' % parkutil.player_name(i))
                return

        while True:
            result = self.over()
            if result == 2:
                print ('Game ended with a draw')
                break
            elif result != -1:
                print ('%s won!' % parkutil.player_name(result))
                break

            self.playturn()

    def over(self):
        if self.skipped > 1:
            return 2 # draw

        if self.boards[self.turn].gameover():
            return not self.turn
        return -1

    def cp(self, l):
        return [r.copy() for r in l]

    def playturn(self):
        my = self.boards[self.turn]
        opps = self.boards[not self.turn]
        retry = False
        try:
            parkutil.reset_clock(3)
            while True:
                attack = self.players[self.turn].play(self.cp(my.board), self.cp(opps.attacked), opps.lastspot, my.lastspot, retry)
                if attack == (None, None):
                    raise ClockTimeout()
                elif opps.attack(attack):
                    opps.lastspot = attack
                    self.skipped = 0
                    break
                retry = True
        except ClockTimeout:
            self.skipped += 1
        finally:
            parkutil.stop_clock()
            self.turn = not self.turn

    def deploy(self, i):
        parkutil.reset_clock(3)
        try:
            deployed = False
            while not deployed:
                ships = self.players[i].deploy(*self.board_dim)
                deployed = self.boards[i].deploy(ships)
            return True
        except ClockTimeout:
            return False
        finally:
            parkutil.stop_clock()

if __name__ == '__main__':
    game = battleship(10, 10)
    game.start()
