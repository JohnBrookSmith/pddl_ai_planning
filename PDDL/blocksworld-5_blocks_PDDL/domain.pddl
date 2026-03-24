
(define 
(domain BLOCKS)
; Domain file for a block stacker with two hands, each can pick up and put down a single block and either stack
; it on top of another block or unstack it from another block. 

	(:requirements :strips :typing)
  	(:types
  		; There are two types of objects in this domain: blocks and hands, and hands can be left-hand or right-hand. 
  		blocks hands - object
  		left-hand right-hand - hands
  	)
  	
  	(:predicates 
  	
  		(on ?x ?y) ; a block is on top of another block
		(ontable ?x) ; a block is touching the table, not on top of another block
		(clear ?x) ; there is nothing on top of a block
		(handempty ?h) ; a hand is empty, not holding a block
		(holding ?h ?x); a hand is holding a block (not empty)
	)

  	(:action pick-up
  		; The robot picks up a block from the table with a hand
		:parameters (?x - blocks ?h - hands)
		; The precondition is that the block is clear, on the table and the hand is empty
	    :precondition (and (clear ?x) (ontable ?x) (handempty ?h))
	    :effect
	    	(and
	    		;(not (ontable ?x)) 		; The block is not on the table anymore
		   		;(not (clear ?x))		; The block is not clear anymore
		   		;(not (handempty ?h)) 	; The hand is not empty anymore
		   		(holding ?h ?x)			; The hand is holding the block
			)
	)

  	(:action put-down
  		; The robot puts down a block on the table with a hand
	    :parameters (?x - blocks ?h - hands)
	    ; The precondition is that the hand is holding the block
	    :precondition (holding ?h ?x)
	    :effect
	    	(and 
	    		;(not (holding ?h ?x)) 	; The hand is not holding the block anymore
		   		(clear ?x)				; The block is clear
		   		(handempty ?h)			; The hand is empty
		   		(ontable ?x)			; The block is on the table
			)
	)
  
  	(:action stack
  		; The robot stacks a block on top of another block with a hand
	    :parameters (?x - blocks ?y - blocks ?h - hands)
	    ; The precondition is that the hand is holding the block, 
	    ; the block to be stacked on is clear and the two blocks are not the same
	    :precondition (and (holding ?h ?x) (clear ?y))
	    :effect
		    (and 
		    	;(not (holding ?h ?x)) 	; The hand is not holding the block anymore
		   		;(not (clear ?y)) 		; The block that is being stacked on is not clear anymore
		   		(clear ?x)				; The block being stacked is clear
		   		(handempty ?h)			; The hand is empty
		   		(on ?x ?y)				; The block is on top of another block
			)
	)
  	 
  	(:action unstack
  		; The robot unstack a block from on top of another block with a hand
	    :parameters (?x - blocks ?y - blocks ?h - hands)
	    ; The precondition is that the block to be unstacked is on top of another block,
	    ; the block to be unstacked is clear and the hand is empty
	    :precondition (and (on ?x ?y) (clear ?x) (handempty ?h))
	    :effect
	    	(and 
	    		(holding ?h ?x)			; The hand is holding the block		
	    		(clear ?y)				; The block that the block was unstacked from is clear
	    		;(not (clear ?x))		; The block that is being unstacked is not clear anymore
	    		;(not (handempty ?h))	; The hand is not empty anymore
	    		;(not (on ?x ?y))		; The block is not on top of another block anymore
			)
	)
)
