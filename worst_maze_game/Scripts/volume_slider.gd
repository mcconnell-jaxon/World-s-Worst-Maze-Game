extends HSlider

@export
var bus_name: String
# The name of the audio bus this slider will control

var bus_index: int
# Will hold the numeric index of the chosen audio bus

func _ready() -> void:
	# Get the numeric index of the audio bus based on its name
	bus_index = AudioServer.get_bus_index(bus_name)
	
	# Connect the slider's value_changed signal to our custom handler function
	value_changed.connect(_on_value_changed)
	
	# Set the slider's starting value to match the current bus volume
	# (convert decibels from the audio bus into a 0–1 linear slider value)
	value = db_to_linear(
		AudioServer.get_bus_volume_db(bus_index)
	)

func _on_value_changed(new_value: float) -> void:
	# When the slider moves, update the bus volume accordingly
	# Convert the slider's linear 0–1 value into decibels for the AudioServer
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)  # 'value' is the slider's current value
	)
