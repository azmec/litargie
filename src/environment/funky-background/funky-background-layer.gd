# ParallaxLayer that already has the background texture we want. 
# It automatically "scrolls" the background layer according to the DIRECTION vector at the SCROLLING_SPEED. 

extends ParallaxLayer

var DIRECTION: = Vector2(1, -1)
var SCROLLING_SPEED: = 5

onready var backgroundSprite: Sprite = $BackgroundSprite

func _process(delta: float) -> void:
	backgroundSprite.region_rect.position.x += (DIRECTION.x * SCROLLING_SPEED) * delta
	backgroundSprite.region_rect.position.y += (DIRECTION.y * SCROLLING_SPEED) * delta


