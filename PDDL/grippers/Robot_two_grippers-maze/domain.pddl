(define 
(domain robot-two-grippers-maze)
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
	    (corridor ?from ?to)   ; there is a corridor between two rooms
	    (goal-location ?b ?r)   ; goal location for a ball
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
       :parameters (?obj ?room ?gripper)
       :precondition  (and  (ball ?obj) (room ?room) (gripper ?gripper)
			    (at ?obj ?room) (at-robby ?room) (free ?gripper))
       :effect (and (carry ?obj ?gripper)
            (used ?gripper)
		    (not (at ?obj ?room)) 
		    (not (free ?gripper)))
       
       )


   (:action drop
       :parameters  (?obj  ?room ?gripper)
       :precondition  (and  (ball ?obj) (room ?room) (gripper ?gripper)
			    (carry ?obj ?gripper) (at-robby ?room) (goal-location ?obj ?room))
       :effect (and (at ?obj ?room)
		    (free ?gripper)
		    (not (carry ?obj ?gripper)))
       
       )
   
   )
    
