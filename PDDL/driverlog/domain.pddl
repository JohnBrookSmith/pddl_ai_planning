(define (domain driverlog)
  (:requirements :strips) 
  (:predicates 	(OBJ ?obj)
	       	(TRUCK ?truck)
               	(LOCATION ?loc)
		(driver ?d)
		(at ?obj ?loc)
		(in ?obj1 ?obj)
		(driving ?d ?v)
		(link ?x ?y) (path ?x ?y)
		(empty ?v)
)

(:action LOAD-TRUCK
  :parameters
   (?obj
    ?truck
    ?loc)
  :precondition
   (and (OBJ ?obj) (TRUCK ?truck) (LOCATION ?loc)
   (at ?truck ?loc) (at ?obj ?loc))
  :effect
   (and (not (at ?obj ?loc)) (in ?obj ?truck)))
  
(:action BOARD-DRIVE-DISEMBARK-TRUCK
 :parameters
   (?driver ?truck ?loc-from ?loc-to)
  :precondition
   (and (DRIVER ?driver) (TRUCK ?truck) (LOCATION ?loc-from) (LOCATION ?loc-to) (link ?loc-from ?loc-to) (at ?driver ?loc-from) (at ?truck ?loc-from) (empty ?truck))
  :effect
   (and
       (not (at ?driver ?loc-from)) (not (at ?truck ?loc-from)) (at ?driver ?loc-to) (at ?truck ?loc-to) (empty ?truck)))

(:action BOARD-TRUCK
  :parameters
   (?driver
    ?truck
    ?loc)
  :precondition
   (and (DRIVER ?driver) (TRUCK ?truck) (LOCATION ?loc)
   (at ?truck ?loc) (at ?driver ?loc) (empty ?truck))
  :effect
   (and (not (at ?driver ?loc)) (not (empty ?truck)) (driving ?driver ?truck)))
   
(:action DRIVE-TRUCK
  :parameters
   (?truck
    ?loc-from
    ?loc-to
    ?driver)
  :precondition
   (and (TRUCK ?truck) (LOCATION ?loc-from) (LOCATION ?loc-to) (DRIVER ?driver) 
   (link ?loc-from ?loc-to) (at ?truck ?loc-from)
   (driving ?driver ?truck))
  :effect
   (and (not (at ?truck ?loc-from)) (at ?truck ?loc-to)))

(:action DISEMBARK-TRUCK
  :parameters
   (?driver
    ?truck
    ?loc)
  :precondition
   (and (DRIVER ?driver) (TRUCK ?truck) (LOCATION ?loc)
        (at ?truck ?loc) (driving ?driver ?truck))
  :effect
   (and (not (driving ?driver ?truck)) (at ?driver ?loc) (empty ?truck)))


(:action UNLOAD-TRUCK
  :parameters
   (?obj
    ?truck
    ?loc)
  :precondition
   (and (OBJ ?obj) (TRUCK ?truck) (LOCATION ?loc)
        (at ?truck ?loc) (in ?obj ?truck))
  :effect
   (and (not (in ?obj ?truck)) (at ?obj ?loc)))
   
   (:action WALK
  :parameters
   (?driver
    ?loc-from
    ?loc-to)
  :precondition
   (and (DRIVER ?driver) (LOCATION ?loc-from) (LOCATION ?loc-to)
	(path ?loc-from ?loc-to) (at ?driver ?loc-from))
  :effect
   (and (not (at ?driver ?loc-from)) (at ?driver ?loc-to)))
   
)
