extends Node
var TrainerName : String = "TrainerName"
var TrainerGender = 0 # 0 is boy, 1 is neutral, 2 is girl
var badges = 0
var time = "00:00"
var pokedex_count = 0
var location : String = "location"
var money : int = 0
var pokedex_seen = [] # list of id numbers
var pokedex_owned = [] # list of id numbers

var onGrass = false
#var grassPos = []
var grass_positions = []
var grassPos = ""
var exitGrassPos = ""

var printFPS = false
#var size
var sprint = false
var game : Node

var inventory

var can_run = false

var pokemon_group = [] # Cannot be more that 6 Pokemon objects

var past_events = [] # All events that had occured

var isMobile = false

var load_game_from_id # Used on loading a save

var theo_starter # 1 = Orchynx, 2 = Electux

signal setup_items

func _ready():
	add_to_group("save")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	# Fill inventory for testing
	inventory = load("res://Utilities/Items/Inventory.gd").new()
	inventory.add_item_by_name_multiple("Potion", 1)
	inventory.add_item_by_name_multiple("Pokéball", 10)
	inventory.add_item_by_name_multiple("Great Ball", 25)
	
	

func _process(_delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_just_pressed("toggle_fps"):
		printFPS = true
	if printFPS == true:
		print(Engine.get_frames_per_second())
	pass
func save_state():
	load_game_from_id = null
	var state = {
		"TrainerName": TrainerName,
		"TrainerGender": TrainerGender,
		"badges": badges,
		"time": time,
		"pokedex_count": pokedex_count,
		"can_run": can_run,
		"pokemon_group": pokemon_group,
		"past_events": past_events,
		"inventory": inventory,
		"pokedex_seen": pokedex_seen,
		"pokedex_owned" : pokedex_owned
	}
	SaveSystem.set_state(filename, state)
func load_state():
	if SaveSystem.has_state(filename):
		var state = SaveSystem.get_state(filename)
		TrainerName = state["TrainerName"]
		TrainerGender = state["TrainerGender"]
		badges = state["badges"]
		time = state["time"]
		pokedex_count = state["pokedex_count"]
		can_run = state["can_run"]
		pokemon_group = state["pokemon_group"]
		past_events = state["past_events"]
		pokedex_seen = state["pokedex_seen"]
		pokedex_owned = state["pokedex_owned"]

		if state.has("inventory"):
			inventory = state["inventory"]
func heal_party(): # Heals all of the player's pokemon party.
	for poke in pokemon_group:
		poke.heal()
func add_poke_to_party(poke : Pokemon):
	# Add to owned dex list
	if !pokedex_owned.has(poke.ID):
		pokedex_owned.append(poke.ID)
		
	if pokemon_group.size() == 6:
		print("party already full")
		# party already full
		# TODO: Send to pc
	else:
		pokemon_group.append(poke)
	pass
