randomize();

// ----- Variáveis de inicialização da geração procedural ----- //

// Tamanho
global.dungeon_size = 20;
// Definição das células
global.dungeon_cells = ds_grid_create(global.dungeon_size,global.dungeon_size);
// 0 -> célula vazia
// 1 -> célula ocupada
// 2 -> o algorítmo detectou um caminho sem saída e evitou ele
ds_grid_clear(global.dungeon_cells, 0);

// Coordenadas importantes para definir células especiais
global.dungeon_furthest_x = 0;
global.dungeon_furthest_y = 0;

global.dungeon_start_x = 0;
global.dungeon_start_y = 0;

global.dungeon_actual_x = 0;
global.dungeon_actual_y = 0;

enum CELL_TYPES {
	
	TYPE,
	WEIGHT,
	GRADE, // Normal, special
}

// Tipos de sala
cell_types = {
	
	// Normal 
	//red: ["red", 10, "normal"],
	blue: ["blue", 10, "normal"],
	orange: ["orange", 10, "normal"],
	green: ["green", 10, "normal"],
	purple: ["purple", 10, "normal"],
	maroon: ["maroon", 10, "normal"],
	// Special
	olive: ["olive", 10, "special"],
	// "Checkpoint" (apenas perto da sala final (sala mais longe) e na sala inicial), como é um tipo muito específico de célula, nem entra pro sorteio. 
	red_torii: ["red_torii", 10, "checkpoint"],
	purple_torii: ["purple_torii", 10, "checkpoint"],
}

// Array que guarda as salas especiais que já foram geradas
special_cells_choosen = [];
// Checa se um checkpoint já foi gerado
checkpoint_cell_generated = false;

// Array dos tipos de sala
cell_special_list = [];
cell_types_list = [];

// Adiciona todas as salas em um array (exceto as de checkpoint, que seriam salas que fogem dessa regra) 
// Também criei um array apenas pras salas especiais, pra que eu não precise percorrer pelo array pra procurar qual sala é especial e qual não é
for (var i = 0; i < struct_names_count(cell_types); ++i) {
    var _name = struct_get_names(cell_types);
	var _type = variable_struct_get(cell_types, _name[i]);
	// Array com todas as salas
	if (_type[CELL_TYPES.GRADE] == "normal"){
		array_insert(cell_types_list, 0, _type[CELL_TYPES.TYPE]);
	}
	// Array só com as salas normais
	if (_type[CELL_TYPES.GRADE] == "special"){
		array_insert(cell_special_list, 0, _type[CELL_TYPES.TYPE]);
	}
}

global.dungeon_cell_types = ds_grid_create(global.dungeon_size,global.dungeon_size);
ds_grid_clear(global.dungeon_cell_types, cell_types_list);

// Posição inicial da geração procedural
var _x = irandom_range(0, global.dungeon_size-1);
var _y = irandom_range(0, global.dungeon_size-1);

// Possível posição para o algorítmo escolher, mas deve checar se não é um caminho sem saída
var _possible_x = _x;
var _possible_y = _y;
// Se ele tem vizinhos, não pode ser um caminho sem saída :)
var _has_neighbors = false;
var _all_positions = [];
// Eu NÃO me lembro o pq de eu ter nomeado essa variável assim (provavelmente tava com sono e nomeei por causa daquela música). Essa variável checa se o número de celas gerado já é o desejado
var _number_1 = 0;

/*  
	Geração procedural dos espaços da dungeon que serão ocupados por rooms. 
	A geração funciona da seguinte maneira:
	- Checa a existência de células vizinhas (desocupadas);
	- Caso não tenha nenhuma célula vizinha descocupada e a geração ainda não acabou (ou seja, possivelmente a geração caiu num caminho sem saída),
	ela "rebobina" os movimentos até achar outra rota (ficam aqui meus agradecimentos ao Corvo, que me deu não só essa ideia, mas como ideias de como construir esse algorítmo em geral);
	- Quando o número desejado de células geradas (global.dungeon_size) for atingido, o loop acaba;
*/
do {

	while(_has_neighbors) == false {
		var _array_choices = [];
	
		var _left_neightborhood = false;
		var _right_neightborhood = false;
		var _up_neightborhood = false;
		var _down_neightborhood = false;

		global.dungeon_cells[# _x, _y] = 1;
	
		if global.dungeon_cells[# _x + 1, _y] == 0	_right_neightborhood = true;
		if global.dungeon_cells[# _x - 1, _y] == 0	_left_neightborhood = true;
		if global.dungeon_cells[# _x, _y-1] == 0	_up_neightborhood = true;
		if global.dungeon_cells[# _x, _y+1] == 0	_down_neightborhood = true;
	
		if (_right_neightborhood) array_insert(_array_choices, 0, "right");
		if (_left_neightborhood) array_insert(_array_choices, 0, "left");
		if (_up_neightborhood ) array_insert(_array_choices, 0, "up");
		if (_down_neightborhood) array_insert(_array_choices, 0, "down");
		
		if (array_length(_array_choices) == 0){
			global.dungeon_cells[# _x, _y] = 2;
			var _novo_caminho = false;
			var i = 0;
			while(_novo_caminho) == false {
				var _pos = _all_positions[i];
				var _pos_x = _pos[0];
				var _pos_y = _pos[1];
				
				if global.dungeon_cells[# _pos_x + 1,_pos_y] == 0	_right_neightborhood = true;
				if global.dungeon_cells[# _pos_x - 1,_pos_y] == 0	_left_neightborhood = true;
				if global.dungeon_cells[# _pos_x,	 _pos_y-1] == 0	_up_neightborhood = true;
				if global.dungeon_cells[# _pos_x,	 _pos_y+1] == 0	_down_neightborhood = true;
				
				if (!_right_neightborhood && !_left_neightborhood && !_up_neightborhood && !_down_neightborhood){
					i ++;	
				} else {
					_x = _pos_x;
					_y = _pos_y;
					
					_novo_caminho = true;
					
					if (_right_neightborhood) array_insert(_array_choices, 0, "right");
					if (_left_neightborhood) array_insert(_array_choices, 0, "left");
					if (_up_neightborhood ) array_insert(_array_choices, 0, "up");
					if (_down_neightborhood) array_insert(_array_choices, 0, "down");

				}
			}
		}
		
		var _choice = _array_choices[irandom_range(0, array_length(_array_choices)-1)];
		
		if (_choice == "left")	_possible_x -=1;
		if (_choice == "right")	_possible_x +=1;
		if (_choice == "up")	_possible_y -= 1;
		if (_choice == "down")	_possible_y += 1;
	
		if ((global.dungeon_cells[# _possible_x+1, _possible_y] == 0) || (global.dungeon_cells[# _possible_x-1, _possible_y] == 0) || (global.dungeon_cells[# _possible_x, _possible_y+1] == 0) || (global.dungeon_cells[# _possible_x, _possible_y-1] == 0)){
			_has_neighbors = true; 
		} else {
			global.dungeon_cells[# _possible_x, _possible_y] = 2; // caminho sem saída
		}
	}
	if (_has_neighbors == true){
		if (_choice == "left")	_x -=1;
		if (_choice == "right")	_x +=1;
		if (_choice == "up")	_y -= 1;
		if (_choice == "down")	_y += 1;
		
		global.dungeon_cells[# _x, _y] = 1
		array_insert(_all_positions, 0, [_x, _y]);
		
		var _count = 0;
		for (var i = 0; i < global.dungeon_size; ++i) {
		    for (var j = 0; j < global.dungeon_size; ++j) {
				if (global.dungeon_cells[# i, j] == 1){
					_count ++;
				}
			}
		}
		if _count == global.dungeon_size{
			_number_1 = true
		}
		
		_has_neighbors = false;
	}
} until(_number_1 == true)

// Define a célula inicial a partir de uma média das distâncias de ponta-a-ponta do mapa
var _left_cell_x	=		0;
var _left_cell_y	=		0;
var _right_cell_x	=		0;
var _right_cell_y	=		0;
var _up_cell_x		=		0;
var _up_cell_y		=		0;
var _down_cell_x	=		0;
var _down_cell_y	=		0;

var _closest = 999;


for (var i = 0; i < global.dungeon_size; ++i) {
    for (var j = 0; j < global.dungeon_size; ++j) {
		if (global.dungeon_cells[# i, j] == 1){
			if i < _closest{
				_closest = 	(i);
				_left_cell_x	=	i;
				_left_cell_y	=	j;
			}
		}
	}
}

_closest = 0;

for (var i = 0; i < global.dungeon_size; ++i) {
    for (var j = 0; j < global.dungeon_size; ++j) {
		if (global.dungeon_cells[# i, j] == 1){
			if i > _closest{
				_closest = 	(i);
				_right_cell_x	=	i;
				_right_cell_y	=	j;
			}
		}
	}
}

_closest = 999;

for (var i = 0; i < global.dungeon_size; ++i) {
    for (var j = 0; j < global.dungeon_size; ++j) {
		if (global.dungeon_cells[# i, j] == 1){
			if j < _closest{
				_closest = 	(j);
				_up_cell_x	=	i;
				_up_cell_y	=	j;
			}
		}
	}
}

_closest = 0;

for (var i = 0; i < global.dungeon_size; ++i) {
    for (var j = 0; j < global.dungeon_size; ++j) {
		if (global.dungeon_cells[# i, j] == 1){
			if j > _closest{
				_closest = 	(j);
				_down_cell_x	=	i;
				_down_cell_y	=	j;
			}
		}
	}
}

var _center_cell_x =		0;
var _center_cell_y =		0;
var _center_distance =	999;

var _med_x = ceil((_right_cell_x	+ _left_cell_x)/2)
var _med_y = ceil((_down_cell_y	+ _up_cell_y)/2)

for (var i = 0; i < global.dungeon_size; ++i) {
    for (var j = 0; j < global.dungeon_size; ++j) {
		if (global.dungeon_cells[# i, j] == 1){
		    if ((abs(i - _med_x)+abs(j-_med_y)) < _center_distance){
				_center_distance = ((abs(i - _med_x)+abs(j-_med_y)));
				_center_cell_x =		i;
				_center_cell_y =		j;
			}
		}
	}
}

global.dungeon_start_x = _center_cell_x;
global.dungeon_start_y = _center_cell_y;

global.dungeon_actual_x = global.dungeon_start_x;
global.dungeon_actual_y = global.dungeon_start_y;

var _count = 0;

for (var i = 0; i < global.dungeon_size; ++i) {
    for (var j = 0; j < global.dungeon_size; ++j) {
		if (global.dungeon_cells[# i, j] == 1){
			_count ++;
		}
	}
}

/*  
	Pra definir a célula mais distante, o mais "prudente" a se fazer seria utilizar o conceito de distância de manhattan, que é a boa e velha "geometria do táxi". 
	Contudo, isso não funcionaria muito bem nesse caso, já que a grid de células contém caminhos "bloqueados" (células que tem o valor 0). Mesmo assim, com alguns ajustes,
	ela ainda daria uma boa aproximada. Mas aproximações são chatas. Então meu amigo Dumb fez a estrutura dessa lógica de pontos, onde quanto mais distante uma célula é da inicial (a distância é
	calculada a partir de cada movimento, ou seja, uma célula que me leva 2 movimentos pra se chegar tem 2 pontos), mais pontos ela tem. Aí se houver um empate, é só fazer um sorteio.
	
	Ficam aqui os meus agradecimentos ao Dumb
*/
map_grid = ds_grid_create(global.dungeon_size, global.dungeon_size);
ds_grid_clear(map_grid, -4);
array_points = [];

add_point = function(_x, _y, _value){
  map_grid[# _x, _y] = _value
  array_push(array_points, {x : _x, y : _y, value : _value});
}

add_point(global.dungeon_start_x, global.dungeon_start_y, 1)

while(array_length(array_points) > 0){
  var _actual_point = array_points[0];
  if (global.dungeon_cells[# _actual_point.x, _actual_point.y] == 1){
	    if (global.dungeon_cells[# _actual_point.x-1, _actual_point.y] == 1  && map_grid[# _actual_point.x-1, _actual_point.y] < 0){
	      add_point(_actual_point.x - 1, _actual_point.y, _actual_point.value + 1)
	    }
		if (global.dungeon_cells[# _actual_point.x+1, _actual_point.y] == 1 && map_grid[# _actual_point.x+1, _actual_point.y] < 0){
	      add_point(_actual_point.x + 1, _actual_point.y, _actual_point.value + 1)
	    }
	    if (global.dungeon_cells[# _actual_point.x, _actual_point.y-1] == 1 && map_grid[# _actual_point.x, _actual_point.y-1] < 0){
	      add_point(_actual_point.x, _actual_point.y-1, _actual_point.value + 1)
	    }
	    if (global.dungeon_cells[# _actual_point.x, _actual_point.y+1] == 1 && map_grid[# _actual_point.x, _actual_point.y+1] < 0){
	      add_point(_actual_point.x, _actual_point.y+1, _actual_point.value + 1)
	    }
  }

  array_delete(array_points, 0, 1)
}

var _dist = 0;
var _xx = 0;
var _yy = 0;
var _pool = [];

for (var i = 0; i < global.dungeon_size; ++i) {
    for (var j = 0; j < global.dungeon_size; ++j) {
		if global.dungeon_cells[# _actual_point.x, _actual_point.y] == 1{
			
			if map_grid[# i, j] == _dist{
				_dist = map_grid[# i, j];
				_xx = i;
				_yy = j;
				array_insert(_pool, 0, [map_grid[# i, j], i, j])
			}
			
			if map_grid[# i, j] > _dist{
				_dist = map_grid[# i, j];
				_xx = i;
				_yy = j;
				_pool = [];
				array_insert(_pool, 0, [map_grid[# i, j], i, j])
			}
		}
	}
}

var _index = irandom(array_length(_pool)-1);

global.dungeon_furthest_x = _pool[_index][1];
global.dungeon_furthest_y = _pool[_index][2];

actual_type = global.dungeon_cell_types[# global.dungeon_actual_x, global.dungeon_actual_y];
actual_cell = global.dungeon_cells[# global.dungeon_actual_x, global.dungeon_actual_y];

global.dungeon_cell_types[# global.dungeon_start_x, global.dungeon_start_y] = cell_types.red_torii[CELL_TYPES.TYPE]; // Definindo o tipo da sala inicial

/*  
	Corvo, dev do Reaper of Gods, e Cecil, que é do servidor do GameMaker, me ajudaram muito! Os comentários dessa função estão em inglês, já que o servidor do GameMaker é gringo.
	Provavelmente existem maneiras mas fáceis e bonitas de se fazer isso. Eu poderia ter utilizado somente arrays, e checado se o tamanho deles era igual a 1, mas acabei fazendo com arrays e strings.
	Explicando de maneira simples, cada célula está numa superposição de tipos de sala (vamos pensar em cores, pra facilitar), algo como ["red", "green", "blue", etc]. Então, quando uma sala é definida
	(nesse caso, a sala inicial, já que pra minha aplicação pessoal eu preciso que a sala inicial seja de um tipo em específico), todas as outras automaticamente removem esse tipo de sua superposição (nesse meu caso em
	específico, o tipo da sala inicial é basicamente exclusivo a ela e a outra sala que fica perto da sala final da geração, então esse passo meio que nem acontece na primeira iteração). Então, por exemplo,
	se a sala inicial é definida como "blue", todas as salas ao lado tiram o "blue" de seus arrays, diminuindo as cores de suas superposições (então, em um primeiro momento, as salas vizinhas ficariam assim:
	["red", "green", etc]). Depois de remover o "blue" das salas vizinhas, eu sorteio uma  cor aleatória pra sala vizinha, quebrando assim sua superposição. E aí esse efeito dominó vai acontecendo pra cada vizinho.
	
	Na teoria, é um sistema meio fácil de se fazer, só que me deu bastante trabalho. Se você quiser estudar mais sobre ele, recomendo pesquisar sobre "Algorítmos de Colapso de Função de Onda", ou "WFC Algorithm".
*/

define_type = function(){
	
	#region generation logic
	
	// Adressing the neighbors of the current cell
	var _neighbor_count = [];

	if (global.dungeon_cells[# global.dungeon_actual_x+1, global.dungeon_actual_y]) == 1	array_insert(_neighbor_count, 0, [global.dungeon_cell_types[# global.dungeon_actual_x+1, global.dungeon_actual_y],		global.dungeon_actual_x+1,	global.dungeon_actual_y]);
	if (global.dungeon_cells[# global.dungeon_actual_x-1, global.dungeon_actual_y]) == 1	array_insert(_neighbor_count, 0, [global.dungeon_cell_types[# global.dungeon_actual_x-1, global.dungeon_actual_y],		global.dungeon_actual_x-1,	global.dungeon_actual_y]);
	if (global.dungeon_cells[# global.dungeon_actual_x,	  global.dungeon_actual_y+1]) == 1	array_insert(_neighbor_count, 0, [global.dungeon_cell_types[# global.dungeon_actual_x,	 global.dungeon_actual_y+1],	global.dungeon_actual_x,	global.dungeon_actual_y+1]);
	if (global.dungeon_cells[# global.dungeon_actual_x,   global.dungeon_actual_y-1]) == 1	array_insert(_neighbor_count, 0, [global.dungeon_cell_types[# global.dungeon_actual_x,	 global.dungeon_actual_y-1],	global.dungeon_actual_x,	global.dungeon_actual_y-1]);
	
	for (var i = 0; i < array_length(_neighbor_count); ++i) {
		
		// Checking if the neighbor have the color of the actual cell
	    if is_array(_neighbor_count[i][0]){
			if array_contains(_neighbor_count[i][0], global.dungeon_cell_types[# global.dungeon_actual_x, global.dungeon_actual_y]){
				var _new_array = [];
				for (var j = 0; j < array_length(_neighbor_count[i][0]); ++j) {
				    if (_neighbor_count[i][0][j] != global.dungeon_cell_types[# global.dungeon_actual_x, global.dungeon_actual_y]){
						array_insert(_new_array, array_length(_new_array),_neighbor_count[i][0][j]);
					}
				}	

				_neighbor_count[i][0] = [];
				global.dungeon_cell_types[# _neighbor_count[i][1], _neighbor_count[i][2]] = [];
				for (var j = 0; j < array_length(_new_array); ++j) {
				    global.dungeon_cell_types[# _neighbor_count[i][1], _neighbor_count[i][2]][j] = _new_array[j];
				    _neighbor_count[i][0][j] = _new_array[j];
				}
			}
		}
		
		// Checking if the actual neighbor have the color of any other neighbor
		if is_array(_neighbor_count[i][0]){
			for (var l = 0; l < array_length(_neighbor_count); ++l) {
				if is_string(_neighbor_count[l][0]){
					if array_contains(_neighbor_count[i][0], _neighbor_count[l][0]){
						var _new_array = [];
						for (var j = 0; j < array_length(_neighbor_count[i][0]); ++j) {
						    if (_neighbor_count[i][0][j] != _neighbor_count[l][0]){
								array_insert(_new_array, array_length(_new_array),_neighbor_count[i][0][j]);
							}
						}	

						_neighbor_count[i][0] = [];
						global.dungeon_cell_types[# _neighbor_count[i][1], _neighbor_count[i][2]] = [];
						for (var j = 0; j < array_length(_new_array); ++j) {
						    global.dungeon_cell_types[# _neighbor_count[i][1], _neighbor_count[i][2]][j] = _new_array[j];
						    _neighbor_count[i][0][j] = _new_array[j];
						}
					}
				}
			}
		}
		
		// Adressing the neighbors of the current neighbor
		var _neighbor_neighbor_count = [];

		if (global.dungeon_cells[# _neighbor_count[i][1]+1, _neighbor_count[i][2]]) == 1	array_insert(_neighbor_neighbor_count, 0, [global.dungeon_cell_types[# _neighbor_count[i][1]+1, _neighbor_count[i][2]],		_neighbor_count[i][1]+1,	_neighbor_count[i][2]]);
		if (global.dungeon_cells[# _neighbor_count[i][1]-1, _neighbor_count[i][2]]) == 1	array_insert(_neighbor_neighbor_count, 0, [global.dungeon_cell_types[# _neighbor_count[i][1]-1, _neighbor_count[i][2]],		_neighbor_count[i][1]-1,	_neighbor_count[i][2]]);
		if (global.dungeon_cells[# _neighbor_count[i][1],	_neighbor_count[i][2]+1]) == 1	array_insert(_neighbor_neighbor_count, 0, [global.dungeon_cell_types[# _neighbor_count[i][1],	_neighbor_count[i][2]+1],	_neighbor_count[i][1],		_neighbor_count[i][2]+1]);
		if (global.dungeon_cells[# _neighbor_count[i][1],   _neighbor_count[i][2]-1]) == 1	array_insert(_neighbor_neighbor_count, 0, [global.dungeon_cell_types[# _neighbor_count[i][1],	_neighbor_count[i][2]-1],	_neighbor_count[i][1],		_neighbor_count[i][2]-1]);
		
		// Checking if the actual neighbor have the color of any other neighbor's neighbor
		if is_array(_neighbor_count[i][0]){
			for (var l = 0; l < array_length(_neighbor_neighbor_count); ++l) {
				if is_string(_neighbor_neighbor_count[l][0]){
					if array_contains(_neighbor_count[i][0], _neighbor_neighbor_count[l][0]){
						var _new_array = [];
						for (var j = 0; j < array_length(_neighbor_count[i][0]); ++j) {
						    if (_neighbor_count[i][0][j] != _neighbor_neighbor_count[l][0]){
								array_insert(_new_array, array_length(_new_array),_neighbor_count[i][0][j]);
							}
						}	

						_neighbor_count[i][0] = [];
						global.dungeon_cell_types[# _neighbor_count[i][1], _neighbor_count[i][2]] = [];
						for (var j = 0; j < array_length(_new_array); ++j) {
						    global.dungeon_cell_types[# _neighbor_count[i][1], _neighbor_count[i][2]][j] = _new_array[j];
						    _neighbor_count[i][0][j] = _new_array[j];
						}
					}
				}
			}
		}
		
		for (var j = 0; j < array_length(_neighbor_neighbor_count); ++j) {
			
			// Checking if neighbor's neighbor has the actual cell color
			if is_array(_neighbor_neighbor_count[j][0]){
				if array_contains(_neighbor_neighbor_count[j][0], global.dungeon_cell_types[# global.dungeon_actual_x, global.dungeon_actual_y]){
					
					var _new_array = [];
					for (var k = 0; k < array_length(_neighbor_neighbor_count[j][0]); ++k) {
					    if (_neighbor_neighbor_count[j][0][k] != global.dungeon_cell_types[# global.dungeon_actual_x, global.dungeon_actual_y]){
							array_insert(_new_array, array_length(_new_array),_neighbor_neighbor_count[j][0][k]);
						}
					}	

					_neighbor_neighbor_count[j][0] = [];
					global.dungeon_cell_types[# _neighbor_neighbor_count[j][1], _neighbor_neighbor_count[j][2]] = [];
					for (var k = 0; k < array_length(_new_array); ++k) {
					    global.dungeon_cell_types[# _neighbor_neighbor_count[j][1], _neighbor_neighbor_count[j][2]][k] = _new_array[k];
					    _neighbor_neighbor_count[j][0][k] = _new_array[k];
					}
					
				}
			}
			
			// Checking if neighbor's neighbor has the cell color of any other neighbor's neighbor
			if is_array(_neighbor_neighbor_count[j][0]){
				for (var m = 0; m < array_length(_neighbor_neighbor_count); ++m) {
					if is_string(_neighbor_neighbor_count[m][0]){
						if array_contains(_neighbor_neighbor_count[j][0], _neighbor_neighbor_count[m][0]){
							
							var _new_array = [];
							for (var k = 0; k < array_length(_neighbor_neighbor_count[j][0]); ++k) {
							    if (_neighbor_neighbor_count[j][0][k] != _neighbor_neighbor_count[m][0]){
									array_insert(_new_array, array_length(_new_array),_neighbor_neighbor_count[j][0][k]);
								}
							}	

							_neighbor_neighbor_count[j][0] = [];
							global.dungeon_cell_types[# _neighbor_neighbor_count[j][1], _neighbor_neighbor_count[j][2]] = [];
							for (var k = 0; k < array_length(_new_array); ++k) {
							    global.dungeon_cell_types[# _neighbor_neighbor_count[j][1], _neighbor_neighbor_count[j][2]][k] = _new_array[k];
							    _neighbor_neighbor_count[j][0][k] = _new_array[k];
							}
						}
					}
				}
			}	
	#endregion
	
			if is_array(global.dungeon_cell_types[# _neighbor_count[i][1], _neighbor_count[i][2]]) && array_length(global.dungeon_cell_types[# _neighbor_count[i][1], _neighbor_count[i][2]]) > 0{
				
				var _pool = [];
				var _sum = 0;
				
				#region Pool
				
				for (var l = 0; l < array_length(global.dungeon_cell_types[# _neighbor_count[i][1], _neighbor_count[i][2]]); ++l) {
					var _type = variable_struct_get(cell_types, global.dungeon_cell_types[# _neighbor_count[i][1], _neighbor_count[i][2]][l]);
					
					if !array_contains(special_cells_choosen, _type[CELL_TYPES.TYPE]){
						repeat(_type[CELL_TYPES.WEIGHT]){
							array_insert(_pool, array_length(_pool), _type[CELL_TYPES.TYPE]);	
						}	
					}	
				}
				
				#endregion
				
				#region Forcing a specific type of room

				// Write here!
				
				#endregion
				
				#region Forcing a checkpoint near the boss room

				var _neighbor_boss_count = [];

				if (global.dungeon_cells[# global.dungeon_furthest_x+1,		global.dungeon_furthest_y]) == 1	array_insert(_neighbor_boss_count, 0, [global.dungeon_cell_types[# global.dungeon_furthest_x+1,		global.dungeon_furthest_y],		global.dungeon_furthest_x+1,	global.dungeon_furthest_y]);
				if (global.dungeon_cells[# global.dungeon_furthest_x-1,		global.dungeon_furthest_y]) == 1	array_insert(_neighbor_boss_count, 0, [global.dungeon_cell_types[# global.dungeon_furthest_x-1,		global.dungeon_furthest_y],		global.dungeon_furthest_x-1,	global.dungeon_furthest_y]);
				if (global.dungeon_cells[# global.dungeon_furthest_x,		global.dungeon_furthest_y+1]) == 1	array_insert(_neighbor_boss_count, 0, [global.dungeon_cell_types[# global.dungeon_furthest_x,		global.dungeon_furthest_y+1],	global.dungeon_furthest_x,		global.dungeon_furthest_y+1]);
				if (global.dungeon_cells[# global.dungeon_furthest_x,		global.dungeon_furthest_y-1]) == 1	array_insert(_neighbor_boss_count, 0, [global.dungeon_cell_types[# global.dungeon_furthest_x,		global.dungeon_furthest_y-1],	global.dungeon_furthest_x,		global.dungeon_furthest_y-1]);

				for (var a = 0; a < array_length(_neighbor_boss_count); ++a) {
					if (checkpoint_cell_generated) == false {
						checkpoint_cell_generated = true;
						var _index = irandom(array_length(_neighbor_boss_count)-1);
						global.dungeon_cell_types[# _neighbor_boss_count[_index][1],	_neighbor_boss_count[_index][2]] = cell_types.purple_torii[CELL_TYPES.TYPE];
					}
				}
				
				#endregion
				
				var _choosen = _pool[irandom(array_length(_pool)-1)];

				if array_contains(cell_special_list, _choosen) array_insert( special_cells_choosen, 0, _choosen);
			
				global.dungeon_cell_types[# _neighbor_count[i][1], _neighbor_count[i][2]] = _choosen;
				_neighbor_count[i][0] = global.dungeon_cell_types[# _neighbor_count[i][1], _neighbor_count[i][2]];

			}
		}
	}
}
define_type();
