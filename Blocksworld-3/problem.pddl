(define 
    (problem BLOCKS-10-0)
    (:domain BLOCKS)
    (:objects A B C D E - blocks
              left-hand - hands)
    (:init
        (on C A)
        (on B C)
        (ontable A)
        (ontable D)
        (ontable E)
        (clear B)
        (clear D)
        (clear E)
        (handempty left-hand)
    )
    (:goal 
        (AND
            (on D E) 
            (on C D)
            (on B C)
            (on A B)
        )
))