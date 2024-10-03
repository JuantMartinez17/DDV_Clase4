extends CharacterBody2D

# Constantes para la velocidad y gravedad
const SPEED = 400
const JUMP_FORCE = -300
const GRAVITY = 900

var inventory = []
# Variables de animación
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

# Variables de estado de salto y correr
var is_jumping = false
var is_falling = false
var is_running = false  # Para verificar si ya está en movimiento

enum characterOrientation {
		RIGHT = 1,
		LEFT = -1
	}

var facing = characterOrientation.RIGHT
var direction = characterOrientation.RIGHT
var oldDirection = null
var characterDirection = null

func _ready():
	# Configurar el AnimationTree en modo activo
	animation_tree.active = true

func _physics_process(delta):
	# Obtener la entrada del usuario
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction = input_vector.x
	SetDirection()

	# Movimiento horizontal
	velocity.x = input_vector.x * SPEED

	# Aplicar la gravedad si no está en el suelo
	if not is_on_floor():
		velocity.y += GRAVITY * delta

		# Verificar si el jugador está subiendo o cayendo
		if velocity.y < 0 or velocity.y >0:
			animation_state.travel("jump_up")  # Activar la animación de inicio de salto

	else:
		# Saltar si se presiona el botón
		if is_jumping:
			is_jumping = false
			animation_state.travel("jump_end")  # Cambiar a la animación de subida mientras esté en el aire

		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_FORCE
			animation_state.travel("jump_start")  # Activar la animación de inicio de salto
			is_jumping = true

	# Mover el jugador
	move_and_slide()

	# Actualizar la animación para el movimiento lateral
	update_animation(input_vector)

func update_animation(input_vector: Vector2):
	if is_on_floor():
		#print ("ANIMACIONES DE DESPLAZAMIENTO")
		# Si no está en el aire, manejamos la animación de correr o estar parado
		if input_vector.x != 0:
			if not is_running:
				animation_state.travel("run_start")  # Cambia a la animación de inicio de correr
				is_running = true  # Marcamos que estamos corriendo
			else:
				animation_state.travel("running")  # Cambia a la animación de correr constante
		else:
			if is_running:
				animation_state.travel("run_end")  # Ejecuta la animación de detenerse
				is_running = false  # Marcamos que ha dejado de correr
			else:
				animation_state.travel("idle")  # Cambia a la animación de estar parado

# Mantiene la direccion (sentido: derecha o izquierda) actual del personaje o lo invierte segun
# la entrada.
func SetDirection():
	if direction != 0:
		characterDirection = direction

	if  direction != oldDirection:
		Flip()
		oldDirection = direction

func Flip():
	if facing == direction:
		return

	if direction != 0:
		facing = direction
		scale.x *= -1


func add_to_inventory(item_name):
	inventory.append(item_name)
	print("Recogido: ", item_name, " - Inventario: ", inventory)
	
