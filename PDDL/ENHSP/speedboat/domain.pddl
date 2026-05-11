(define
    (domain speedboat)

    (:predicates
        (engine_running)
        (engine_stopped)
        (steer_straight)
        (steer_left)
        (steer_right)
    )

    (:functions
        (x)          ; Position on x-axis
        (y)          ; Position on y-axis
        (max_x)             ; Maximum x position (boundary of the pool)
        (min_x)             ; Minimum x position (boundary of the pool)
        (max_y)             ; Maximum y position (boundary of the pool)
        (min_y)             ; Minimum y position (boundary of the pool)
        (obstacle_x)        ; x position of the obstacle
        (obstacle_y)        ; y position of the obstacle
           )

    (:constraint out_of_bounds
        ; The boat should not travel outside the boundaries of the pool
        :parameters ()
        :condition (and 
            (>= (x) (min_x)) 
            (<= (x) (max_x)) 
            (>= (y) (min_y)) 
            (<= (y) (max_y))
        )
    )
    
    (:constraint obstacles
        ; The boat should not collide with the obstacle located at (obstacle_x, obstacle_y)
        :parameters ()
        :condition (or
        (< (x) (- (obstacle_x) 1))
        (> (x) (+ (obstacle_x) 1))
        (< (y) (- (obstacle_y) 1))
        (> (y) (+ (obstacle_y) 1))
    )
    )

    (:process go_straight
        ; When the engine is running and the boat is steered straight, it moves forward in the x direction
        ; at a rate of 2 units per time step (2 m/s)
        :parameters ()
        :precondition (and 
            (engine_running) 
            (steer_straight)
        )
        :effect (increase (x) (* #t 2))
    )

    (:process go_left
        ; When the engine is running and the boat is steered left, it moves diagonally up-left at a rate of 
        ; 1 unit per time step in both x and y directions (1 m/s each = 2 m/s)
        :parameters ()
        :precondition (and 
            (engine_running)
            (steer_left)
        )
        :effect (and 
            (increase (x) (* #t 1))
            (increase (y) (* #t 1))
        )
    )

    (:process go_right
        ; When the engine is running and the boat is steered right, it moves diagonally down-right at a rate of 
        ; 1 unit per time step in both x and y directions (1 m/s each = 2 m/s)
        :parameters ()
        :precondition (and 
            (engine_running) 
            (steer_right))
        :effect (and 
            (decrease (x) (* #t 1))
            (decrease (y) (* #t 1))
        )
    )

    (:action steer_straight
        ; When the engine is running, the boat can be steered straight, which allows it to move forward in the x direction  
        ; and is not steered left or right
        :parameters ()
        :precondition (engine_running)
        :effect (and 
            (steer_straight)
            (not (steer_left))
            (not (steer_right))
        )
    )

    (:action steer_left
        ; When the engine is running, the boat can be steered left, which allows it to move diagonally up-left 
        ; and is not steered straight or right
        :parameters ()
        :precondition (engine_running)
        :effect (and 
            (steer_left)
            (not (steer_straight))
            (not (steer_right))
        )
    )

    (:action steer_right
        ; When the engine is running, the boat can be steered right, which allows it to move diagonally down-right
        ; and is not steered straight or left
        :parameters ()
        :precondition (engine_running)
        :effect (and 
            (steer_right)
            (not (steer_straight))
            (not (steer_left))
        )
    )


    (:action stop_boat
        ; When the boat is running, it can be stopped, which sets the engine to stopped and prevents any movement
        :parameters ()
        :precondition  (engine_running)
        :effect (and
            (engine_stopped)
            (not (engine_running))
        )

    )

    (:action start_boat
        ; When the boat is stopped, it can be started, which sets the engine to running and allows movement
        :parameters ()
        :precondition (engine_stopped)
        :effect (and
            (engine_running)
            (not (engine_stopped))
        )
    )

)
