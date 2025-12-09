extends Control

#global variables lol (im too lazy to not use globals)
var player_health = 0
var player_attack = 0
var player_defense = 0 # remove in future
var player_speed = 0
var player_weapon = 5 # remove in futur

var enemy_health = 0
var enemy_attack = 0
const enemy_defense = 5 # remove later
const enemy_speed = 5

signal end_fight

@onready var damage_container: MarginContainer = $MarginContainer/VSplitContainer/MarginContainer/DamageContainer
@onready var player_hp: Label = $MarginContainer/VSplitContainer/MarginContainer/PlayerHP
@onready var enemy_hp: Label = $MarginContainer/VSplitContainer/MarginContainer/EnemyHP
@onready var action_bar_background: ColorRect = $MarginContainer/VSplitContainer/ActionBarBackground
@onready var message: Label = $MarginContainer/VSplitContainer/MarginContainer/Message
@onready var text_margin: MarginContainer = $MarginContainer/VSplitContainer/ActionBarBackground/MarginContainer2/BottomHBox/TextMargin
@onready var button_container: HBoxContainer = $MarginContainer/VSplitContainer/ActionBarBackground/MarginContainer2/BottomHBox/ButtonContainer

var enemyStats = load("res://resources/enemy_list.tres").get_enemy(enemy.enemy_name)
#var enemy = enemy_list.get_enemy(enemy.enemy)
#add font

func _ready():																			#on ready
	var stats = load("res://resources/player_stats.tres")								#load player stats
	#print(enemy.enemy_name)
	player_health = stats.get_player_health()											#assign variables to the variables in the player stats resource
	player_attack = stats.get_player_attack()
	player_defense = stats.get_player_defense()
	player_speed = stats.get_player_speed()
	player_hp.text = "Player : " + str(player_health) + " HP"
	enemy_hp.text = "\n" + str(enemy_health) + " HP"
	
	enemy_health = randi_range(int(enemyStats["min_health"]), int(enemyStats["max_health"]))
	print(enemy_attack)
	updateEnemyHealth(enemy_health)

#This updates the text for the health of the player.
func updatePlayerHealth(health):														#i split these up for something i forgor why
	player_hp.text = "Player " + str(health)

#This updates the text for the health of the enemy.
func updateEnemyHealth(health):
	enemy_hp.text = "\n " + str(health) + " HP"

#This displays damage numbers that float on screen then fade away.
func damageNumbers(dmg, isPlayerTakingDmg):														#function for showing damage counters
																						#param: damage(int), playerTakingDmg(bool)
	var tween = get_tree().create_tween()								#create a tween for animating
	var damage = Label.new()
	damage_container.add_child(damage)
	
	if isPlayerTakingDmg:																		#if player is taking damage
		damage.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN						#move damage text to bottom left
		damage.size_flags_vertical = Control.SIZE_SHRINK_END 
	else:																				#if enemy is taking damage
		damage.size_flags_horizontal = Control.SIZE_SHRINK_END							#move damage text to top right
		damage.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	damage.text = str(dmg)											#set the text of the "Message" label to the damage dealt
	tween.tween_property(damage, "modulate:a", 1, 0.25).from(0)		#have the label fade in
	#tween.tween_property(damage, "position:y", -10, 0.4).from(0)		#have the label move upwards 10 px
	tween.tween_property(damage, "modulate:a", 0, 0.5).from(1)		#have the label fade out.
	
	

#When the "Attack" button is pressed, it compares player speed to the enemy.
#then it chooses turn order based on that.
func _on_attack_button_pressed():
	button_container.hide()									#hide buttons so user cant click while in between turns
	if player_speed > enemy_speed:							#If player is faster than enemy
		player_turn()										#Player goes first
		await get_tree().create_timer(1.75).timeout			#Wait 1.75 second
		if enemy_health > 0:								#If enemy is still alive,
			enemy_turn()									#Enemy attacks.
	else:
		enemy_turn()										#same thing but enemy is faster
		await get_tree().create_timer(1.75).timeout
		if player_health > 0:
			player_turn()
	button_container.show()									#bring the buttons back after turns are over

#This does damage to the enemy based on the player's attack stat,
#added to the damage that the weapon the player has equipped has,
#minus the defense stat of the enemy.

#Feel free to change the forumla as needed
func player_turn():
	var damage_to_enemy = int(player_attack * ([0.6, 0.8, 1, 1.2, 1.4].pick_random()) + player_weapon - enemy_defense)
	var initial_health = enemy_health													#keep intial health to be used in tween
	enemy_health -= damage_to_enemy														#decrement enenmy's health
	if enemy_health < 0:																	#make sure the health doesnt go below 0.
		enemy_health = 0
	damageNumbers(damage_to_enemy, false)												#show damage counter
	
	createText("Player dealt " + str(damage_to_enemy) + " damage!")
	var tween = get_tree().create_tween()												#create tween for animation
	tween.tween_method(updateEnemyHealth, initial_health, enemy_health, 0.25)			#animate enemy health dropping from initial to current
	#updateHealth()																		#Update enemy health 
	if enemy_health <= 0:																#If the enenmy is out of health,
		print("Enemy has died!")														#replace with victory screen or smth later
		end()																			#and fade back to the maze.

#This does damage to the player based on the enemy's attack stat,
#minus the player's defense stat.

#Change this if the player's damage formula is tweaked.
func enemy_turn():																		#same thing as player turn but for enemy
	enemy_attack = int(enemyStats["damage"][randi_range(0, 1)]) #choosing random attack
	var damage_to_player = enemy_attack - player_defense
	var initial_health = player_health
	if damage_to_player < 1:
		damage_to_player = 1
	
	player_health -= damage_to_player
	if player_health < 0:
		player_health = 0
	damageNumbers(damage_to_player, true)
	
	var tween = get_tree().create_tween()
	tween.tween_method(updatePlayerHealth, initial_health, player_health, 0.25)
	#updateHealth()
	createText("Enemy dealt " + str(damage_to_player) + " damage!")
	if player_health <= 0:
		print("Player has died!")													#replace with game over screen later
		end()

#Have the inventory pop up when selected.
func _on_items_button_pressed() -> void:											#TODO: add inventory scene/menu
	var items = load("res://scenes/item_menu.tscn").instance()						#theoretically adds an item_menu scene on top?
	get_tree().current_scene.add_child(items)

#Have the screen transition back to the maze.
func end():																			#fades screen out
	await get_tree().create_timer(0.75).timeout
	end_fight.emit()


func _on_escape_button_pressed() -> void:
	var escape_chance = 0.50 + (float(player_speed - enemy_speed) / 100)			#50% chance of escaping + how much faster the player is / 100
	var tween = get_tree().create_tween()
	
	var randNum = randf()															#generate random number
	print(escape_chance)			#DEBUG
	print(randNum)					#DEBUG
	print(message.position)			#DEBUG
	if randNum < escape_chance:														#if random number is less than escape chance
		message.text = "Escaped!"													#escape
		message.set_position(Vector2(466, 228))
		tween.tween_property(message, "modulate:a", 1, 0.25).from(0)
		tween.tween_property(message, "position:y", 228, 0.5).from(238)
		tween.tween_property(message, "modulate:a", 0, 0.5).from(1)
		end()
	else:																			#if random number is greater than escape chance
		createText("Couldn't escape!")												#dont escape
		await get_tree().create_timer(1.75).timeout
		enemy_turn()																#enemy attacks

func createText(text):																#function for making text show up letter by letter
	var text_label = RichTextLabel.new()											#in the bottom box
	text_label.visible_ratio = 0
	text_label.text = text
	text_margin.add_child(text_label)
	
	for i in range(text_label.text.length()):										#increment the amount of letters being shown at a time
		text_label.visible_characters += 1
		await get_tree().create_timer(0.025).timeout								#with a 0.025 second delay between letters
	await get_tree().create_timer(1).timeout										#keep text on screen for 1 second (might need to change idk)
	text_label.hide()
