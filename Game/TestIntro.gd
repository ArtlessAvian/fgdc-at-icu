extends Control

export(Array, String) var first_line
export(Array, String) var second_line
export(Array, String) var fight_call

var rand = RandomNumberGenerator.new()


# Intro is generated using Markov chains and ML including functionality from OpenAI
# and TensorFlow. Trained using a dictionary of size N = 10000. Passes Turing Test.
func match_start():
	rand.randomize()

	var label = $Center/Text

	label.text = first_line[rand.randi_range(0, first_line.size() - 1)]
	wow_cool_effect()

	# TODO: Determine if this is safe on network.
	yield(get_tree().create_timer(1.5), "timeout")

	label.text = second_line[rand.randi_range(0, second_line.size() - 1)]
	wow_cool_effect()
	yield(get_tree().create_timer(1.5), "timeout")

	round_call(1)


func round_call(round_num: int):
	var label = $Center/Text

	label.text = "Round " + String(round_num)
	yield(get_tree().create_timer(1.0), "timeout")

	label.text = fight_call[rand.randi_range(0, fight_call.size() - 1)]
	$AnimationPlayer.playback_speed = 3
	wow_cool_effect()
	yield(get_tree().create_timer(0.5), "timeout")

	$AnimationPlayer.playback_speed = 1
	label.text = ""


func wow_cool_effect():
	var anim_player: AnimationPlayer = $AnimationPlayer
	var effects = anim_player.get_animation_list()
	var index = rand.randi_range(0, effects.size() - 2)
	if effects[index] == "RESET":
		index = effects.size() - 1

	anim_player.play(effects[index])
