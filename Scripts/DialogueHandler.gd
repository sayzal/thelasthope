extends CanvasLayer

@export var curDialogue : Dialogue
@onready var charSprite : TextureRect = $Sprite
@onready var charName : RichTextLabel = $Name
@onready var charText : RichTextLabel = $RichTextLabel
@onready var charAnim : AnimationPlayer = $Sprite/AnimationPlayer
@onready var sfxClick : AudioStreamPlayer = $Click

var inDialogue : bool = false
var curProgress : int = 0
var canProceed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	begin_dialogue()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("LMB")):
		if (charText.visible_ratio == 1):
			if (inDialogue):
				proceed_dialogue()
			else:
				begin_dialogue()

func begin_dialogue():
	proceed_dialogue()
	inDialogue = true
	
func proceed_dialogue():
	if (curProgress == curDialogue.dialogueText.size()):
		end_dialogue()
	else:
		charName.text = curDialogue.dialogueName[curProgress]
		charText.text = curDialogue.dialogueText[curProgress]
		if (curProgress != 0 and curDialogue.dialogueSprite[curProgress] != curDialogue.dialogueSprite[curProgress - 1]):
			charAnim.play("change_sprite")
		text_appear()
		if (curProgress != 0):
			sfxClick.play()
		curProgress += 1

func end_dialogue():
	inDialogue = false
	curProgress = 0
	
func anim_sprite_change():
		charSprite.texture = curDialogue.dialogueSprite[curProgress - 1]
	
func text_appear():
	charText.visible_ratio = 0
	var tween = create_tween()
	tween.tween_property(charText, "visible_ratio", 1, 0.5)
