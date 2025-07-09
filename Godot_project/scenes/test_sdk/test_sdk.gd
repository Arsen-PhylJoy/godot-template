extends CanvasLayer

var _settings_ps: PackedScene = preload("uid://ldg2jq7gg87x")

@onready var launch_ad: Button = %LaunchAD
@onready var gameplay_ready: Label = %"Gameplay-ready"
@onready var user_id: RichTextLabel = %UserID

func _ready() -> void:
	_connect_signals()
	gameplay_ready.text = "Server_time " + str(await WebBus.get_server_time())

func _connect_signals() -> void:
	launch_ad.pressed.connect(_on_ad_launched)
	WebBus._getted_player.connect(_on_player_got)

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("cancel")):
		add_child(_settings_ps.instantiate())
	if(Input.is_action_just_pressed("ui_accept")):
		user_id.text = str(WebBus.user_info)
		gameplay_ready.text = "Server_time " + str(await WebBus.get_server_time())

func _on_ad_launched() -> void:
	WebBus.show_ad()

func _on_player_got() -> void:
	user_id.text = str(WebBus.user_info)
