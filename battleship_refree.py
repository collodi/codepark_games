import parkutil
import battleship

class battleship_refree:
    def __init__(self, w, h):
        parkutil.register_function('deploy', 2)
        parkutil.register_function('play', 4)
        self.players = parkutil.get_players(2)

        self.skipped = 0
        self.turn = True # player 0 goes first
        self.board_dim = (w, h)
        self.boards = [battleship.board(*self.board_dim) for i in range(len(self.players))]

    def start(self):
        deployed = [self.deploy(i) for i in range(len(self.players))]
        while True:
            result = self.over()
            if result == 2:
                print ('Game ended with a draw')
                break
            elif result != -1:
                print ('%s won!' % parkutil.player_uid(result))
                break

            self.turn = not self.turn
            self.playturn()

    def over(self):
        # draw cases
        if self.boards[0].lost and self.boards[1].lost:
            return 2
        if self.boards[0].skipped() and self.boards[1].skipped():
            return 2

        # only need to check the opponent
        if self.boards[not self.turn].lost:
            return int(self.turn)
        return -1 # nobody won yet

    def playturn(self):
        m = self.boards[self.turn]
        o = self.boards[not self.turn]
        h = None
        try:
            h = self.players[self.turn].play(m.get(), o.hidden(), m.last_attacked)
        except ClockTimeout:
            pass
        finally:
            o.attack(h)

    def deploy(self, i):
        try:
            ships = self.players[i].deploy(*self.board_dim)
            self.boards[i].deploy(ships)
        except ClockTimeout:
            self.boards[i].lost = True

if __name__ == '__main__':
    game = battleship_refree(10, 10)
    game.start()
