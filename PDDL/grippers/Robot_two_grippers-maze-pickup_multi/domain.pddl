(define (domain robot-two-grippers-maze-pickup_multi)
; Domain file for a robot with two grippers, which can pick up two balls at the same time per gripper 
; and move from one room to another. 
(:requirements :strips :conditional-effects :negative-preconditions)
    (:predicates 
        (room ?r)              ; a room
	    (ball ?b)              ; a ball
	    (grippers ?g)           ; a gripper
	    (at-robby ?r)   ; the robot is at a room
	    (at ?b ?r)                ; a ball is at a room
	    (carry ?o ?g)   ; an object is carried by a gripper
	    (free ?g)       ; a gripper is free
	    (used ?g)              ; a gripper is being used
	    (corridor ?from ?to)   ; there is a corridor between two rooms
	    (goal-location ?b ?r)   ; goal location for a ball
	    (holding ?b)
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
            ))


    (:action pick
        :parameters (?room ?grippers)
        :precondition  (and (room ?room) (grippers ?grippers)
                    (at-robby ?room) (free ?grippers))
        :effect (and(used ?grippers)(not (free ?grippers))
        (forall (?obj) 
        (when (at ?obj ?room)
        (and (carry ?obj ?grippers)
                (not (at ?obj ?room)) 
                )))))
        
    
   (:action drop
       :parameters  (?room ?grippers)
       :precondition  (and (room ?room) (grippers ?grippers)
			    (at-robby ?room) (used ?grippers))
       :effect (and (free ?grippers)
		    (not (used ?grippers))
		    (forall (?obj)
		    (when (and (carry ?obj ?grippers) (goal-location ?obj ?room))
		    (and (at ?obj ?room)
		         (not (carry ?obj ?grippers)))))))
   
   )
    
