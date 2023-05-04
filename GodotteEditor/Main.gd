extends Control

# 各パーツ.
## 頭.
@onready var _head = $Godotte/Vp/Head
## 眉毛.
@onready var _eyebrows = $Godotte/Vp/Head/Eyebrows/Normal
## 口.
@onready var _mouse = $Godotte/Vp/Head/Mouses/Normal
## 左手.
@onready var _left_hand = $Godotte/Vp/HandLeft
## 目.
@onready var _eye_white = $Godotte/Vp/Head/Eyes/Normal/White
@onready var _eye_mask = $Godotte/Vp/Head/Eyes/Normal/Mask
@onready var _eye_eyes = $Godotte/Vp/Head/Eyes/Normal/Mask/Eyes

# 視線.
@onready var _chk_eye_sight = $UI/CheckBtnEyeSight
@onready var _chk_eye_label = $UI/CheckBtnEyeSight/Label
# 左手.
@onready var _chk_left_hand = $UI/CheckBtnLeftHand
# 首の回転.
@onready var _chk_neck_rotation = $UI/CheckBtnNeckRotation
@onready var _chk_neck_label = $UI/CheckBtnNeckRotation/Label

func _ready() -> void:
	pass

## 更新.
func _process(delta: float) -> void:
	_update_common()
	if _chk_eye_sight.button_pressed:
		_update_eye_sight() # 視線の更新.
	if _chk_neck_rotation.button_pressed:
		_update_neck_rotation() # 首の回転の更新.

## 更新 > 視線.
func _update_eye_sight():	
	if Input.is_action_pressed("right-click"): # 右ドラッグ中のみ有効.
		var mouse = get_viewport().get_mouse_position()
		var d:Vector2 = mouse - _eye_eyes.global_position
		var length = d.length()
		var rot = d.angle()
		var distance = 32 * length / 640
		if distance > 32:
			distance = 32
		_eye_eyes.offset.x = distance * cos(rot)
		_eye_eyes.offset.y = distance * sin(rot)
	else:
		_chk_eye_label.visible = true

## 更新 > 首.
func _update_neck_rotation():
	if Input.is_action_pressed("right-click"): # 右ドラッグ中のみ有効.
		_chk_neck_label.visible = false
		var mouse = get_viewport().get_mouse_position()
		var d:Vector2 = mouse - _eye_eyes.global_position # 回転し続けるバグが面白いのでひとまずこっち.
		#var d:Vector2 = mouse - _head.global_position
		var rot = d.angle()
		_head.rotation = rot

	else:
		_chk_neck_label.visible = true
	

## 更新 > 共通.
func _update_common() -> void:
	_chk_eye_label.visible = false
	_chk_neck_label.visible = false
	
	# 左手を表示するかどうか.
	_left_hand.visible = _chk_left_hand.button_pressed

## PNGに保存
## Win環境は %APPDATA%\Godot\ [プロジェクト名]
## macOSは ~/Library/Application Support/Godot/[プロジェクト名]
func _save_png() -> void:
#	var vp = get_viewport()
	var vp = $Godotte/Vp # Viewportの TransparentBG を有効にすると透過できる.
	var tex = vp.get_texture()
	var image = tex.get_image()
	image.save_png("user://godotte.png")
	
	# 保存したフォルダをシェルで開く.
	var path = str("file://", ProjectSettings.globalize_path("user://"))
	OS.shell_open(path)

## PNGに保存する.
func _on_button_save_pressed() -> void:
	_save_png()

## 眉毛パーツ変更.
func _on_option_eyebrows_item_selected(index: int) -> void:
	_eyebrows.texture = $UI/OptionEyebrows.get_item_icon(index)

## 口パーツ変更.
func _on_option_mouse_item_selected(index: int) -> void:
	_mouse.texture = $UI/OptionMouse.get_item_icon(index)

## 眉毛の位置移動.
func _on_slider_eyebrows_value_changed(value: float) -> void:
	_eyebrows.offset.y = value * -1 # 逆方向.


func _on_option_eyes_outside_item_selected(index: int) -> void:
	var option = $UI/OptionEyesOutside
	_eye_white.texture = option.get_item_icon(index)
	var name = option.get_item_text(index)
	_eye_mask.texture = load("res://assets/images/godotte/eyes/%s/mask.png"%name.to_lower())
	_eye_eyes.visible = true
	if name == "Closed":
		# 閉じている目だけは例外処理.
		_eye_eyes.visible = false


func _on_option_eyes_inside_item_selected(index: int) -> void:
	var option = $UI/OptionEyesInside
	_eye_eyes.texture = option.get_item_icon(index)
