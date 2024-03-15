extends CanvasLayer

@export var curDialogue : Dialogue
@onready var BG : TextureRect = $BG
@onready var charSprite : TextureRect = $Sprite
@onready var charName : RichTextLabel = $Name
@onready var charText : RichTextLabel = $Text
@onready var charAnim : AnimationPlayer = $Sprite/SpriteAnimation
@onready var bgAnim : AnimationPlayer = $BG/BGAnimation
@onready var sfxClick : AudioStreamPlayer = $Click
@onready var autoHolder : RichTextLabel = $"Auto"

var inDialogue : bool = false
var curProgress : int = 0
var canProceed = false
var textAppearTween : Tween
var textProceedTween : Tween 
var textAutoTween : Tween
var textBGTween : Tween
var isAuto : bool = false
var curDelay : int = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	begin_dialogue()
	autoHolder.visible_ratio = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (Input.is_action_just_pressed("LMB") and canProceed):
		if (charText.visible_ratio == 1):
			if (inDialogue):
				proceed_dialogue()
			else:
				begin_dialogue()
		else:
			textAppearTween.stop()
			charText.visible_ratio = 1
	if (Input.is_action_just_pressed("auto")):
		if (!isAuto):
			start_auto()
		else:
			stop_auto()

func begin_dialogue():
	proceed_dialogue()
	inDialogue = true
	
func proceed_dialogue():
	if (curProgress == curDialogue.dialogueText.size()):
		end_dialogue()
	else:
		textProceedTween = create_tween()
		textProceedTween.tween_property(self, "canProceed", true, 0.15)
		charName.text = curDialogue.dialogueName[curProgress]
		charText.text = curDialogue.dialogueText[curProgress]
		text_appear()
		if (curProgress != 0):
			sfxClick.play()
		if (curProgress != 0 and curDialogue.dialogueSprite[curProgress] != curDialogue.dialogueSprite[curProgress - 1]):
			charAnim.stop()
			charAnim.play("change_sprite")
		if (curDialogue.dialogueBackground[curProgress] != null):
			switch_background()
		curProgress += 1

func end_dialogue():
	inDialogue = false
	curProgress = 0
	print("end")
	
func anim_sprite_change():
		charSprite.texture = curDialogue.dialogueSprite[curProgress - 1]
	
func text_appear():
	charText.visible_ratio = 0
	textAppearTween = create_tween()
	if (curProgress != 0 and curDialogue.dialogueSprite[curProgress] != curDialogue.dialogueSprite[curProgress - 1]):
		textAppearTween.tween_property(charSprite, "texture", curDialogue.dialogueSprite[curProgress], 0.1)
	textAppearTween.tween_property(charText, "visible_ratio", 1, 0.5)
	
func start_auto():
	isAuto = true
	autoHolder.visible_ratio = 1
	if (curDialogue.dialogueText[curProgress].length() > 30):
		curDelay = 5
	else:
		curDelay = 2
	textAutoTween = create_tween()
	textAutoTween.tween_callback(proceed_dialogue).set_delay(curDelay)
	textAutoTween.tween_callback(start_auto).set_delay(curDelay)
	
func stop_auto():
	isAuto = false
	autoHolder.visible_ratio = 0
	textAutoTween.stop()

func switch_background():
	bgAnim.stop()
	bgAnim.play("change_bg")
	textBGTween = create_tween()
	textBGTween.tween_property(BG, "texture", curDialogue.dialogueBackground[curProgress], 0.1)
