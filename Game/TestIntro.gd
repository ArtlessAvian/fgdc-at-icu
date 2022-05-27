extends Label

export(Array, String) var first_line
export(Array, String) var second_line
export(Array, String) var fight_call

var rand = RandomNumberGenerator.new()

# Intro is generated using Markov chains and ML including functionality from OpenAI 
# and TensorFlow. Trained using a dictionary of size N = 10000. Passes Turing Test.
func match_start():
	rand.randomize() 

	self.text = first_line[rand.randi_range(0, first_line.size() - 1)]
	$AnimationPlayer.play("ZoomIn")
	yield(get_tree().create_timer(1.5), "timeout")
	
	self.text = second_line[rand.randi_range(0, first_line.size() - 1)]
	$AnimationPlayer.play("ZoomIn")
	yield(get_tree().create_timer(1.5), "timeout")

	round_call(1)


func round_call(round_num: int):
	self.text = "Round " + String(round_num)
	$AnimationPlayer.play("ZoomIn")
	yield(get_tree().create_timer(1.0), "timeout")

	self.text = fight_call[rand.randi_range(0, first_line.size() - 1)]
	$AnimationPlayer.play("ZoomIn")
	yield(get_tree().create_timer(0.5), "timeout")

	self.text = ""
