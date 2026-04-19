if keyboard_check_pressed(ord("W")){
	if global.dungeon_cells[# global.dungeon_actual_x, global.dungeon_actual_y-1] == 1{
		global.dungeon_actual_y --;
		define_type();
	}
}
if keyboard_check_pressed(ord("A")){
	if global.dungeon_cells[# global.dungeon_actual_x - 1, global.dungeon_actual_y] == 1{
		global.dungeon_actual_x --;
		define_type();
	}
}
if keyboard_check_pressed(ord("S")){
	if global.dungeon_cells[# global.dungeon_actual_x, global.dungeon_actual_y+1] == 1{
		global.dungeon_actual_y ++;
		define_type();
	}
}
if keyboard_check_pressed(ord("D")){
	if global.dungeon_cells[# global.dungeon_actual_x + 1, global.dungeon_actual_y] == 1{
		global.dungeon_actual_x ++;
		define_type();
	}
}

actual_cell = global.dungeon_cells[# global.dungeon_actual_x, global.dungeon_actual_y];