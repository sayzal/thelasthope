extends CanvasLayer

@export var curDialogue : Dialogue
@onready var charSprite : TextureRect = $Sprite
@onready var charName : RichTextLabel = $Name
@onready var charText : RichTextLabel = $RichTextLabel

var inDialogue : bool = false
var curProgress : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	begin_dialogue()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func begin_dialogue():
	proceed_dialogue()
	
func proceed_dialogue():
	if (curProgress == curDialogue.dialogueText.size()):
		end_dialogue()
	else:
		charSprite.texture = curDialogue.dialogueSprite[0]
		charName.text = curDialogue.dialogueName[0]
		charText.text = curDialogue.dialogueText[0]
		text_appear()

func end_dialogue():
	pass
	
func text_appear():
	charText.visible_ratio = 0
	var tween = create_tween()
	tween.tween_property(charText, "visible_ratio", 1, 1.0)
