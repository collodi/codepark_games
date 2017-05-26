import parkutil
import battleship

class battleship_refree:
    def __init__(self, w, h):
        parkutil.register_function('deploy', 2)
        parkutil.register_function('play', 4)
        self.players = parkutil.get_players(2)

        self.skipped = 0
        self.turn = False # player 0 goes first
        self.board_dim = (w, h)
        self.boards = [battleship.board(*self.board_dim) for i in range(len(self.players))]

    def start(self):
        for i in range(len(self.players)):
            self.deploy(i)

        while True:
            r = self.over()
            if r == 2:
                print ('Game ended with a draw')
                break
            elif r != -1:
                print ('%s won!' % self.players[r].uid)
                break

            self.playturn()

    def over(self):
        # draws
        if self.boards[0].lost and self.boards[1].lost:
            return 2
        if self.boards[0].opp_skipped and self.boards[1].opp_skipped:
            return 2

        # only need to check myself
        if self.boards[self.turn].lost:
            return int(not self.turn)
        return -1 # nobody won yet

    def playturn(self):
        m = self.boards[self.turn]
        o = self.boards[not self.turn]
        h = None
        try:
            h = self.players[self.turn].play(m.get(), o.hidden(), m.last_attacked, o.last_sunk)
        except parkutil.ClockTimeout:
            pass
        finally:
            o.attack(h)
            self.turn = not self.turn

    def deploy(self, i):
        try:
            ships = self.players[i].deploy(*self.board_dim)
            self.boards[i].deploy(ships)
        except parkutil.ClockTimeout:
            self.boards[i].lost = True

if __name__ == '__main__':
    game = battleship_refree(10, 10)
    game.start()
