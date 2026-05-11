
(define (problem speedboat_pool)
  (:domain speedboat)
  (:objects)
  (:init
    (= (x) 1)          ; Position on x-axis
    (= (y) 5)          ; Position on y-axis
    (= (max_x) 20) ; Maximum x position (boundary of the pool)
    (= (min_x) 1) ; Minimum x position (boundary of the pool)
    (= (max_y) 10); Maximum y position (boundary of the pool)
    (= (min_y) 1) ; Minimum y position (boundary of the pool)
    (= (obstacle_x) 4) ; x position of the obstacle
	(= (obstacle_y) 5)  ; y position of the obstacle
	(steer_straight)
	(engine_stopped)
  )
  (:goal
    (and 
        (= (x) 19)
        (= (y) 9)
        (engine_stopped)
    )
	)
)
