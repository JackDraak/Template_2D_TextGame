extends Control

var bookmark = 0
var current_story
var num_stories = 0
var player_words = []
var stories

onready var ButtonLabel = $VBoxContainer/HBoxContainer/ButtonLabel
onready var PlayerInput = $VBoxContainer/HBoxContainer/PlayerInput
onready var Textbox = $VBoxContainer/Textbox

func _ready():
	initialize()
	setup()
	main_loop()

func _on_PlayerInput_enter_key(unused_arg):
	add_to_player_words()

func _on_TextureButton_pressed():
	if not is_story_finished():
		add_to_player_words()
	else:
		bookmark = bookmark + 1
		if bookmark == num_stories:
			bookmark = 0
		setup()
		main_loop()

func add_to_player_words():
	if PlayerInput.text != "":
		# do more sanity-checking here?
		player_words.append(PlayerInput.text)
	Textbox.text = ""
	PlayerInput.clear()
	main_loop()

func end_story():
	PlayerInput.text = ""
	PlayerInput.visible = false
	ButtonLabel.text = "Restart"

func initialize():
	load_stories()
	PlayerInput.placeholder_text = "Enter response here..."

func is_story_finished():
	var state = player_words.size() == current_story.prompts.size()
	return state

func load_stories():
	stories = read_story_file("StoryBook.json")
	num_stories = stories.size()
	current_story = stories[bookmark]

func main_loop():
	if is_story_finished():
		print_story()
	else:
		prompt_player()

func print_story():
	Textbox.text = current_story.story % player_words
	end_story()

func prompt_player():
	Textbox.text += "Please enter " + current_story.prompts[player_words.size()] + " below:"

func read_story_file(filename):
	var fqpn = "res://" + filename 
	var file = File.new()
	file.open(fqpn, File.READ) 
	var content = parse_json(file.get_as_text())
	file.close()
	return content

func setup():
	PlayerInput.visible = true
	ButtonLabel.text = "Okay"
	Textbox.text = "Thank you for playing my story-game. First, I'll ask you for some ideas, then I'll tell you a story! "
	player_words = []
	current_story = stories[bookmark]
	PlayerInput.grab_focus()
