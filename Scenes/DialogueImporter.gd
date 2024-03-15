@tool
extends EditorScript

var textFile = "test"

func _run():
	var checkFile = FileAccess.open("res://Text Files/" + textFile + ".txt", FileAccess.READ)
	var allStrings = checkFile.get_as_text().split("\n")
	var newDialogue = Dialogue.new()
	newDialogue.dialogueName.resize(allStrings.size() - 1)
	newDialogue.dialogueText.resize(allStrings.size() - 1)
	newDialogue.dialogueSprite.resize(allStrings.size() - 1)
	for n in allStrings.size() - 1:
		newDialogue.dialogueName[n] = allStrings[n].split("/")[0]
		newDialogue.dialogueText[n] = allStrings[n].split("/")[3]
		newDialogue.dialogueSprite[n] = load("res://Sprites/" + allStrings[n].split("/")[1] + ".png")
	ResourceSaver.save(newDialogue, "res://Dialogues/" + textFile + ".tres")
