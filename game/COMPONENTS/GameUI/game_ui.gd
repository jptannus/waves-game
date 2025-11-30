class_name GameUI
extends Control

@onready var turn_current_value: Label = %TurnCurrentValue
@onready var turn_total_value: Label = %TurnTotalValue

@onready var score_value: Label = %ScoreValue

@onready var combo_container: HBoxContainer = %ComboContainer
@onready var combo_points_value: Label = %ComboPointsValue
@onready var combo_multiplier_value: Label = %ComboMultiplierValue



@onready var menu_button: TextureButton = %MenuButton


func show_bird() -> void:
	%Bird.visible = true
	
	
func hide_bird() -> void:
	%Bird.visible = false
