class_name Item
extends Resource

@export_group("General")
@export var name: String
@export var scene: PackedScene
@export_group("Scoring")
@export var award_points: bool = 0
@export var points: int = 10
@export var award_multiplier: bool = 0
@export var multiplier: float = 1
