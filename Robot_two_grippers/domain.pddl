(define 
(domain robot-two-grippers)
; Domain file for a robot with two grippers, which can pick up two balls at the same time per gripper 
; and move from one room to another. 
(:requirements :strips)
    (:predicates 
        (room ?r)              ; a room
	    (ball ?b)              ; a ball
	    (gripper ?g)           ; a gripper
	    (at-robby ?r)   ; the robot is at a room
	    (at ?b ?r)                ; a ball is at a room
	    (carry ?o ?g)   ; an object is carried by a gripper
	    (free ?g)       ; a gripper is free
	    (used ?g)              ; a gripper is being used
	    (picked-one ?g) ; a gripper has picked up one ball
	    (picked-two ?g) ; a gripper has picked up two balls
	    (corridor ?from ?to)   ; there is a corridor between two rooms
    )

    (:action move
        ; The robot moves from one room to another using a corridor 
        ; the effect is that the robot is in the new room and not in the old room anymore
        :parameters  (?from ?to)
        :precondition (and  (room ?from) (room ?to) (corridor ?from ?to) (at-robby ?from))
        :effect 
            (and
                (at-robby ?to)
		        (not (at-robby ?from))
            )
    )

    (:action pick-up-one
        ; If there is a ball in the room, the robot picks up one ball with a gripper
        ; the effect is that the ball is carried by the gripper, the gripper has picked up one ball, 
        ; the ball is not at the room anymore and the gripper is not free anymore
        :parameters (?obj ?room ?gripper)
        :precondition  (and  (ball ?obj) (room ?room) (gripper ?gripper)
		    (at ?obj ?room) (at-robby ?room) (free ?gripper))
        :effect (and 
            (carry ?obj ?gripper)
            (picked-one ?gripper)
		    (not (at ?obj ?room)) 
		    (not (free ?gripper))
		)
    )

    (:action pick-up-two
        ; If there is another ball in the room, the robot picks up a second ball with a gripper
        ; the effect is that the ball is carried by the gripper, the gripper has picked up two balls,
        ; the gripper is being used, the ball is not at the room anymore and the gripper has not picked up only one ball anymore
        :parameters (?obj ?room ?gripper)
        :precondition  (and  (ball ?obj) (room ?room) (gripper ?gripper)
            (at ?obj ?room) (at-robby ?room) (picked-one ?gripper))
        :effect (and 
                (carry ?obj ?gripper)
                (picked-two ?gripper)
                (used ?gripper)
                (not (at ?obj ?room))
                (not (picked-one ?gripper))
        )
    )

   (:action drop-one
       ; If the robot is carrying a ball with a gripper, it can drop the ball in the room
       ; the effect is that the ball is at the room, the gripper is free, the ball is not 
       ; carried by the gripper anymore and the gripper has not picked up one ball anymore
        :parameters  (?obj  ?room ?gripper)
        :precondition  (and  (ball ?obj) (room ?room) (gripper ?gripper)
		    (carry ?obj ?gripper) (at-robby ?room) (picked-one ?gripper))
        :effect (and (at ?obj ?room)
		    (free ?gripper)
		    (not (carry ?obj ?gripper))
		    (not (picked-one ?gripper))
        )
   )
    (:action drop-two
        ; If the robot is carrying a ball with a gripper, it can drop the ball in the room
        ; the effect is that the ball is at the room, the gripper has picked up one ball, the ball is not
        ; carried by the gripper anymore and the gripper has not picked up two balls anymore
        :parameters  (?obj  ?room ?gripper)
        :precondition  (and  (ball ?obj) (room ?room) (gripper ?gripper)
            (carry ?obj ?gripper) (at-robby ?room) (picked-two ?gripper))
        :effect (and (at ?obj ?room)
              (picked-one ?gripper)
              (not (carry ?obj ?gripper))
              (not (picked-two ?gripper))
        )    
    )
)