# ParallaxLayer that already has the background texture we want. 
# It automatically "scrolls" the background layer according to the DIRECTION vector at the SCROLLING_SPEED. 

extends ParallaxLayer

export var direction: Vector2 = Vector2(1, -1)
export var scrolling_speed: int = 5

onready var backgroundSprite: Sprite = $BackgroundSprite

func _process(delta: float) -> void:
	backgroundSprite.region_rect.position.x += (direction.x * scrolling_speed) * delta
	backgroundSprite.region_rect.position.y += (direction.y * scrolling_speed) * delta


