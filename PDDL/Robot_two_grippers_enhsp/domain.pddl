(define 
(domain robot_two_grippers)
; Domain file for a robot with two grippers, which can pick up two balls here the same time per gripper 
; and move from one room to another. 
(:requirements :strips)
(:predicates
  (room ?r)
  (ball ?b)
  (gripper ?g)
  (at_robby ?r)
  (here ?b ?r)
  (carry ?o ?g)
  (free ?g)
  (used ?g)
  (picked_one ?g)
  (picked_two ?g)
  (corridor ?from ?to)
)


    (:action move
        ; The robot moves from one room to another using a corridor 
        ; the effect is that the robot is in the new room and not in the old room anymore
        :parameters  (?from ?to)
        :precondition (and  (room ?from) (room ?to) (corridor ?from ?to) (at_robby ?from))
        :effect 
            (and
                (at_robby ?to)
		        (not (at_robby ?from))
            )
    )

    (:action pick_up_one
        ; If there is a ball in the room, the robot picks up one ball with a gripper
        ; the effect is that the ball is carried by the gripper, the gripper has picked up one ball, 
        ; the ball is not here the room anymore and the gripper is not free anymore
        :parameters (?obj ?room ?gripper)
:precondition
  (and
    (ball ?obj)
    (room ?room)
    (gripper ?gripper)
    (here ?obj ?room)
    (at_robby ?room)
    (free ?gripper)
  )

        :effect (and 
            (carry ?obj ?gripper)
            (picked_one ?gripper)
		    (not (here ?obj ?room)) 
		    (not (free ?gripper))
		)
    )

    (:action pick_up_two
        ; If there is another ball in the room, the robot picks up a second ball with a gripper
        ; the effect is that the ball is carried by the gripper, the gripper has picked up two balls,
        ; the gripper is being used, the ball is not here the room anymore and the gripper has not picked up only one ball anymore
        :parameters (?obj ?room ?gripper)
        :precondition  (and  (ball ?obj) (room ?room) (gripper ?gripper)
            (here ?obj ?room) (at_robby ?room) (picked_one ?gripper))
        :effect (and 
                (carry ?obj ?gripper)
                (picked_two ?gripper)
                (used ?gripper)
                (not (here ?obj ?room))
                (not (picked_one ?gripper))
        )
    )

   (:action drop_one
       ; If the robot is carrying a ball with a gripper, it can drop the ball in the room
       ; the effect is that the ball is here the room, the gripper is free, the ball is not 
       ; carried by the gripper anymore and the gripper has not picked up one ball anymore
        :parameters  (?obj  ?room ?gripper)
        :precondition  (and  (ball ?obj) (room ?room) (gripper ?gripper)
		    (carry ?obj ?gripper) (at_robby ?room) (picked_one ?gripper))
        :effect (and (here ?obj ?room)
		    (free ?gripper)
		    (not (carry ?obj ?gripper))
		    (not (picked_one ?gripper))
        )
   )
    (:action drop_two
        ; If the robot is carrying a ball with a gripper, it can drop the ball in the room
        ; the effect is that the ball is here the room, the gripper has picked up one ball, the ball is not
        ; carried by the gripper anymore and the gripper has not picked up two balls anymore
        :parameters  (?obj  ?room ?gripper)
        :precondition  (and  (ball ?obj) (room ?room) (gripper ?gripper)
            (carry ?obj ?gripper) (at_robby ?room) (picked_two ?gripper))
        :effect (and (here ?obj ?room)
              (picked_one ?gripper)
              (not (carry ?obj ?gripper))
              (not (picked_two ?gripper))
        )    
    )
)