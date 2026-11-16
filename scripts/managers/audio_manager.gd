extends Node

const SAMPLE_RATE := 22050
const SOUND_SETTINGS := {
	"shoot": [180.0, 0.10, 0.32, 0.0],
	"hit": [760.0, 0.08, 0.22, -260.0],
	"hurt": [115.0, 0.20, 0.28, -40.0],
	"enemy_down": [520.0, 0.18, 0.24, -280.0],
	"reload": [340.0, 0.12, 0.18, 180.0],
}


func play_sfx(sound_name: String) -> void:
	if not SOUND_SETTINGS.has(sound_name):
		return
	var settings: Array = SOUND_SETTINGS[sound_name]
	var stream := _make_tone(float(settings[0]), float(settings[1]), float(settings[2]), float(settings[3]))
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.bus = "Master"
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()


func _make_tone(start_frequency: float, duration: float, volume: float, frequency_delta: float) -> AudioStreamWAV:
	var sample_count := int(SAMPLE_RATE * duration)
	var pcm := PackedByteArray()
	pcm.resize(sample_count * 2)
	for index in range(sample_count):
		var time := float(index) / SAMPLE_RATE
		var progress := time / duration
		var frequency := maxf(30.0, start_frequency + frequency_delta * progress)
		var envelope := exp(-5.0 * progress)
		var sample := int(sin(TAU * frequency * time) * envelope * volume * 32767.0)
		pcm[index * 2] = sample & 0xff
		pcm[index * 2 + 1] = (sample >> 8) & 0xff
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = SAMPLE_RATE
	stream.stereo = false
	stream.data = pcm
	return stream
