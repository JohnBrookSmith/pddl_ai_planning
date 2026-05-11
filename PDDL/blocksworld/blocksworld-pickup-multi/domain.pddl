(define 
	(domain blocksworld-pickup-multi)
	(:requirements :strips :typing :conditional-effects :negative-preconditions)
	(:types
		block
		hand
	)
	(:predicates
		(on ?x - block ?y - block)
		(ontable ?x - block)
		(clear ?x - block)	
		(holding ?x - block)
		(holdingstack ?x - block ?y - block)
		(goalstack ?x - block ?y - block)
		(inorderstack ?x - block ?y - block ?z - block)
		(handempty)
	)

  	(:action pick-up
  		:parameters (?x - block)
  		:precondition (and 
  			(clear ?x)
  			(ontable ?x)
  			(handempty)
  		)
  		:effect (and 
  			(not (ontable ?x))
  			(not (clear ?x))
  			(not (handempty))
  			(holding ?x)
  		)
  	)

  	(:action put-down
  		:parameters (?x - block)
  		:precondition (holding ?x)
  		:effect (and 
  			(not (holding ?x))
  			(clear ?x)
  			(handempty)
  			(ontable ?x)
  		)
  	)
  	
  	(:action stack
  		:parameters (?x - block ?y - block)
  		:precondition (and 
  			(holding ?x)
  			(clear ?y)
  		)
  		:effect (and
  			(not (holding ?x))
  			(not (clear ?y))
  			(clear ?x)
  			(handempty)
  			(on ?x ?y)
  			(forall (?z - block)
				(when (holdingstack ?x ?y)
					(and
						(inorderstack ?x ?y ?z)
						(not (clear ?z))
					)
				)
			)
		)
	)
  	 	
  	(:action unstack
  		:parameters (?x - block ?y - block)
  		:precondition (and 
  			(on ?x ?y)
  			(clear ?x)
  			(handempty)
  		)
  		:effect (and 
  			(holding ?x)
  			(clear ?y)
  			(not (clear ?x))
  			(not (handempty))
  			(not (on ?x ?y))
  			(forall (?z - block)
				(when (goalstack ?z ?y)
					(holdingstack ?z ?y)
				)
			)
  		)
	)
)



;; remove a road
;(:action destroy_road
;  :parameters (?xy_initial - junction ?xy_final - junction ?r1 - road)
;  :precondition (and 
;		(road_connect ?r1 ?xy_initial ?xy_final)
;		(in_place ?r1)
;		)
; :effect (and  
;		(not (in_place ?r1))
;		(not (road_connect ?r1 ?xy_initial ?xy_final))
;               (increase (total-cost) 10)
;		(forall (?c1 - car)
;                     (when (at_car_road ?c1 ?r1) 
;			(and
;			  (not (at_car_road ?c1 ?r1))
;			  (at_car_jun ?c1 ?xy_initial)
;			)
;		      )
;		   )
;		)
;)
