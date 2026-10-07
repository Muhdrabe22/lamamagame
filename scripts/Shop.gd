extends Node3D

var shop_type: String = "phone"
var price: int = 1200
var stock: int = 5
var sign: Label3D

func _ready() -> void:
    _build_shop()

func set_type(type_name: String) -> void:
    shop_type = type_name
    if shop_type == "phone":
        price = 1200
        if sign != null:
            sign.text = "PHONE SHOP"
    elif shop_type == "clothes":
        price = 1800
        if sign != null:
            sign.text = "CLOTHES STORE"

func _build_shop() -> void:
    var shop_body = MeshInstance3D.new()
    var box = BoxMesh.new()
    box.size = Vector3(4.0, 3.0, 4.0)
    shop_body.mesh = box
    shop_body.position = Vector3(0.0, 1.5, 0.0)
    add_child(shop_body)

    sign = Label3D.new()
    sign.text = "SHOP"
    sign.position = Vector3(0.0, 3.5, 0.0)
    sign.modulate = Color(1.0, 1.0, 1.0, 1.0)
    add_child(sign)

func get_shop_name() -> String:
    return shop_type.capitalize() + " Shop"

func buy_item(item_name: String) -> bool:
    if stock <= 0:
        return false
    stock -= 1
    return true
