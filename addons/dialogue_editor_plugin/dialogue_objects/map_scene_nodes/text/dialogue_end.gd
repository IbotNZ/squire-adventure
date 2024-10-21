extends DialogueType
class_name DialogueEnd

# Array of dialogues that will become available to select in the game scene when this node is run
var next_selectable_dialogues: Array[DialogueStart]

func make_dialogues_selectable():
	for i in next_selectable_dialogues:
		i.is_selectable = true
