for (var i = 0; i < global.dungeon_size; ++i) {
	for (var j = 0; j < global.dungeon_size; ++j) {
		if (global.dungeon_cells[# i, j] == 1){
			// Checa a existência de vizinhos
			var _left = false;
			var _right = false;
			var _up = false;
			var _down = false;

			if global.dungeon_cells[# i + 1, j] == 1	_right = true;
			if global.dungeon_cells[# i - 1, j] == 1	_left = true;
			if global.dungeon_cells[# i, j-1] == 1		_up = true;
			if global.dungeon_cells[# i, j+1] == 1		_down = true;
			

			if (!(_left) && !(_right) && !(_up) && !(_down)){
				bug = true
				show_message("Sala vazia detectada")	
			}
		}
	}
}
var _c = 0;
for (var i = 0; i < global.dungeon_size; ++i) {
	for (var j = 0; j < global.dungeon_size; ++j) {
		if (global.dungeon_cells[# i, j] == 1){
			_c ++;
		}
	}
}

if _c != global.dungeon_size bug = true;

show_debug_message("restart")
if bug ==  false{
	game_restart();
}