extends Control

# 各パーツ.
## 瞳孔.
@onready var _eye = $Godotte/Vp/Head/Eyes/Normal/Mask/Eyes
## 頭.
@onready var _head = $Godotte/Vp/Head
## 左手.
@onready var _left_hand = $Godotte/Vp/HandLeft

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
		var d:Vector2 = mouse - _eye.global_position
		var length = d.length()
		var rot = d.angle()
		var distance = 32 * length / 640
		if distance > 32:
			distance = 32
		_eye.offset.x = distance * cos(rot)
		_eye.offset.y = distance * sin(rot)
	else:
		_chk_eye_label.visible = true

## 更新 > 首.
func _update_neck_rotation():
	if Input.is_action_pressed("right-click"): # 右ドラッグ中のみ有効.
		_chk_neck_label.visible = false
		var mouse = get_viewport().get_mouse_position()
		var d:Vector2 = mouse - _eye.global_position
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

