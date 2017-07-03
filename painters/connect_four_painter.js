var v = view.size;
v *= 0.9;

var x_offset = (view.size.width - view.size.height) / 2;
var y_offset = view.size.height * 0.05;

var board = new Size(gameplays[0][0], gameplays[0][1]);
var cell_size = new Size(v.height / board.height, v.height / board.height);

var colors = ["red", "blue"];
var cell = new Symbol(new Path.Rectangle({
    point: [0, 0],
    size: cell_size,
    strokeColor: 'black'
}));

/* initialize the board */
for (var i = 0; i < board.height; i++) {
    for (var j = 0; j < board.width; j++) {
	cell.place([
	    (j + 0.5) * cell_size.width + x_offset,
	    (i + 0.5) * cell_size.height + y_offset
	]);
    }
}
$('#message').text("You are blue.");

var turn = 1;
var layer = new Layer();
var next_move = function () {
    if (turn == gameplays.length)
	return; /* no more plays to draw */

    var p = gameplays[turn][0] == current_uid ? 1 : 0;
    var w = (gameplays[turn][2] + 0.5) * cell_size.width + x_offset;
    var h = (gameplays[turn][1] + 0.5) * cell_size.height + y_offset;

    new Path.Circle({
	center: [w, h],
	radius: cell_size.width / 3,
	fillColor: colors[p]
    }).smooth('continuous');
    turn++;
};

var prev_move = function () {
    if (turn == 1)
	return;

    layer.lastChild.remove();
    turn--;
};

$('#next-move').click(next_move);
$('#prev-move').click(prev_move);
