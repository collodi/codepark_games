#!/usr/bin/env ruby

def play(board, opp_last, piece)
	moves = valids(board)
	opp = piece == 1? 0 : 1

	#check if player can win
	for move in moves
		if can_win(board, move, piece)
			return move
		end
	end

	# check if player can block opponent from winning
	for move in moves
		if can_win(board, move, opp)
			return move
		end
	end

	# next we must find and remove all moves which
	# put the opponent in a position on their next turn
	for r, c in moves
		if r - 1 >= 0
			if can_win(board, [r-1, c], opp)
				moves -= [[r, c]]
			end
		end
	end

	#if you cant move without letting the opponent win, skip
	if moves.length == 0
		return nil
	end

	# middle pieces are more valuable so we will next sort
	# these moves by middle-ness
	moves = mid_sort(moves)

	# get three pieces in a row, works with a nil in between as well
	for move in moves
		if find_3(board, move, piece)
			return move
		end
	end
	#block opponents three's
	for move in moves
		if find_3(board, move, opp)
			return move
		end
	end

	#return the middle most move
	return moves[0]
end

module_function

def valids(board)
	valids = []
	(0..board[0].length()-1).step(1) do |c|
		(board.length()-1).downto(0) do |r|
			if board[r][c] == nil
				valids.push([r, c])
				break
			end
		end
	end
	return valids
end

def get_vert_line(board, move)
	line = []
	(0..board.length()-1).step(1) do |r|
		line.push(board[r][move[1]])
	end
	return line
end

#   \
def get_back_line(board, move)
	line = []
	if move[0] < move[1]
        start = [0, move[1] - move[0]]
    else
        start = [move[0] - move[1], 0]
    end
    while start[0] <= 5 and start[1] <= 6
    	line.push(board[start[0]][start[1]])
    	start = [start[0] + 1, start[1] + 1]
    end
    return line
end

#   /
def get_forward_line(board, move)
	line = []
    hor_mov = (board.length - 1) - move[0]
    if move[1] < hor_mov
        start = [move[0] + move[1], 0]
    else
        start = [move[0] + hor_mov, move[1] - hor_mov]
    end
    while start[0] >= 0 and start[1] <= 6
    	line.push(board[start[0]][start[1]])
    	start = [start[0] - 1, start[1] + 1]
    end
    return line
end

def can_win(board, move, piece)
	board[move[0]][move[1]] = piece
	line = []

	#horizontal check
	line = board[move[0]]
	if line_check(line, piece)
		board[move[0]][move[1]] = nil
		return true
	end


	#check vert
	line = get_vert_line(board, move)
	if line_check(line, piece)
		board[move[0]][move[1]] = nil
		return true
	end


	#back diagonal
	line = get_back_line(board, move)
    if line_check(line, piece)
    	board[move[0]][move[1]] = nil
		return true
    end

    #forward diagonal
    line = get_forward_line(board, move)
    if line_check(line, piece)
    	board[move[0]][move[1]] = nil
		return true
    end

	board[move[0]][move[1]] = nil
	return false
end

def line_check(line, piece)
	i = 0
	for item in line
		if item == piece
			i += 1
		else
			i = 0
		end
		if i == 4
			return true
		end
	end
	return false
end

def mid_sort(moves)
	temp, ret = [], []
	for r, c in moves
		temp.insert(-1, [[r, c], (c - 3).abs])
	end
	temp = temp.sort { |a,b| a[1] <=> b[1]}
	for move, pos in temp
		ret.insert(-1, move)
	end
	return ret
end

def find_3(board, move, piece)
	board[move[0]][move[1]] = piece
	line = []

	# horizontal check first
	line = board[move[0]]
	if line3_check(line, piece)
		board[move[0]][move[1]] = nil
		return true
	end

	# vertical check
	line = get_vert_line(board, move)
	if line3_check(line, piece)
		board[move[0]][move[1]] = nil
		return true
	end

	# forward diagonal check
	line = get_forward_line(board, move)
	if line3_check(line, piece)
		board[move[0]][move[1]] = nil
		return true
	end

	#back diagonal check
	line = get_back_line(board, move)
	if line3_check(line, piece)
		board[move[0]][move[1]] = nil
		return true
	end

	board[move[0]][move[1]] = nil
	return false
end

def line3_check(line, piece)
	n_cnt = p_cnt = 0
	for i in line
		if i == nil
			n_cnt += 1
		elsif i == piece
			p_cnt += 1
		else
			n_cnt = p_cnt = 0
		end
		if n_cnt == 2
			n_cnt = 1; p_cnt = 0
		end
		return true if n_cnt == 1 and p_cnt == 3
	end
	return false
end



=begin
if __FILE__ == $0
	row, col = 6, 7
	board = Array.new(row){ Array.new(col) {nil}}

	board = [
		[nil, nil, nil, nil, nil, nil, nil],
		[nil, nil, nil, nil, nil, nil, nil],
		[nil, nil, nil, false, nil, nil, nil],
		[false, nil, nil, true, nil, nil, nil],
		[true, true, false, false, nil, nil, nil],
		[true, false, true, false, true, nil, nil],
	]


	turn = 1

	while true do
		for r in board
			for i in r
				if i == nil
					print "-"
				elsif i == 1
					print "x"
				else
					print "o"
				end
				print " "
			end
			puts ""
		end
		puts "enter your move: "
		user = gets.chomp.split(" ").map(&:to_i)
		board[user[0]][user[1]] = turn
		last = nil
		move = play(board, last, 0)
		board[move[0]][move[1]] = 0
	end

	#play(board, nil, true)

end
=end
