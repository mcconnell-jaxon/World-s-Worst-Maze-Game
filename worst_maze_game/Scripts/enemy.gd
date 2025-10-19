extends Node2D

const SPEED = 300.0

var current_level: int = 1
var astar_grid: AStarGrid2D
var walkable_list: Array
var is_moving
var target_position: Vector2
var path = []

@onready var base_layer: TileMapLayer = $"../Level_1_Map/BaseLayer"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	#set up astar_grid
	astar_grid = AStarGrid2D.new()
	astar_grid.region = Rect2i(0,0, 150,150)
	astar_grid.cell_size = Vector2(32, 32)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	var region_size = astar_grid.region.size
	var region_position = astar_grid.region.position
	
	for x in region_size.x:
		for y in region_size.y:
			var tile_position = Vector2(x + region_position.x, y + region_position.y)
			var tile_data = base_layer.get_cell_tile_data(tile_position)
			#add all walkable tiles to list
			if tile_data == null or not tile_data.get_custom_data("walkable"):
				astar_grid.set_point_solid(tile_position)
			else:
				walkable_list.append(tile_position)
				
	path = generate_new_path()
			
func _process(_delta):
	if is_moving:
		return
		
	move()
	
func generate_random_point():
	walkable_list.shuffle()
	if len(walkable_list) > 0:
		return walkable_list[0]
	print("no walkable tiles in list!")
	
func generate_new_path():
	target_position = generate_random_point()
	print(target_position)
	path = astar_grid.get_id_path(base_layer.local_to_map(global_position), target_position)
	return path
	
func move():
	if len(path) == 1:
		path = generate_new_path()

	path.pop_front()
	
	if path.is_empty():
		#print("path doesn't exist")
		return

	var original_position = Vector2(global_position)
	
	global_position = base_layer.map_to_local(path[0])
	animated_sprite_2d.global_position = original_position
	
	is_moving = true
	
func _physics_process(_delta):
	if is_moving:
		animated_sprite_2d.global_position = animated_sprite_2d.global_position.move_toward(global_position, 0.5)
		
		if animated_sprite_2d.global_position != global_position:
			return
		
		is_moving = false
