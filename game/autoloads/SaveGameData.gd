class_name SaveGameData
extends Resource

export var saved_points: int
export var saved_scrap: int

export var saved_level_to_load: String

export var saved_ships_stats := {
	"interceptor": {"dmg_level": 0, "rate_level": 0},
	"bomber": {"dmg_level": 0, "rate_level": 0},
	"stealth": {"dmg_level": 0, "rate_level": 0}
	}

export var saved_ship_order: Array
