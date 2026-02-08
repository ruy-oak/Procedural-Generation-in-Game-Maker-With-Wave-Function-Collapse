// Representação visual da dungeon

var _margin = 8;
var _cell_margin = 16;

for (var i = 0; i < global.dungeon_size; ++i) {
    for (var j = 0; j < global.dungeon_size; ++j) {
		
		var _c = c_dkgray;
		
		if (global.dungeon_cells[# i, j] == 1) _c = c_white;
		
		if (global.dungeon_cells[# i, j] == 1) && global.dungeon_cell_types[# i, j] == "red" _c = c_red;
		if (global.dungeon_cells[# i, j] == 1) && global.dungeon_cell_types[# i, j] == "blue" _c = c_blue;
		if (global.dungeon_cells[# i, j] == 1) && global.dungeon_cell_types[# i, j] == "green" _c = c_green;
		if (global.dungeon_cells[# i, j] == 1) && global.dungeon_cell_types[# i, j] == "orange" _c = c_orange;
		if (global.dungeon_cells[# i, j] == 1) && global.dungeon_cell_types[# i, j] == "purple" _c = c_fuchsia;
		if (global.dungeon_cells[# i, j] == 1) && global.dungeon_cell_types[# i, j] == "red_torii" _c = c_red;
		if (global.dungeon_cells[# i, j] == 1) && global.dungeon_cell_types[# i, j] == "purple_torii" _c = c_purple;
		if (global.dungeon_cells[# i, j] == 1) && global.dungeon_cell_types[# i, j] == "olive" _c = c_olive;
		if (global.dungeon_cells[# i, j] == 1) && global.dungeon_cell_types[# i, j] == "maroon" _c = c_maroon;

		//if ((i == global.dungeon_start_x) && (j == global.dungeon_start_y)) _c = c_red;	
		if ((i == global.dungeon_actual_x) && (j == global.dungeon_actual_y)) _c = c_yellow;	
		if ((i == global.dungeon_furthest_x) && (j == global.dungeon_furthest_y)) _c = c_gray;	
		
		
	    draw_text_color(_margin + (i*_cell_margin), _margin + (j*_cell_margin), global.dungeon_cells[# i, j],_c,_c,_c,_c,1);
	}
}

draw_text(64,256+32, global.dungeon_cell_types[# global.dungeon_actual_x, global.dungeon_actual_y])
