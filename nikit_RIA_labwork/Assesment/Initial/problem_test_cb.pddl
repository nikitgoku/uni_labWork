(define (problem test_CB) (:domain craft-bots)
(:objects 
    ; 1 actor, 3 nodes, 1 resource
    a1 a2 - actor
    n1 n2 n3 n4 n5 - nodes
    r1 - resource
)

(:init
    ;todo: put the initial state's facts and numeric values here
    ; n1 n2 and n3 are adjacent to each other in the same numeric order
    (idle a1)
    ;(idle a2)
    (rfree r1)
    ; a1 is at node 1
    (alocation a1 n1)
    ;(alocation a2 n2)
    ; resource is at node n2
    (rlocation r1 n2)
    ; resource has a size of 4
    (= (resource_size r1) 4)
    ; actor has a inventory size of 7
    (= (inventory_space a1) 7)
    ; n1 <==> n2 <==> n3
    (adjacent n1 n2)
    (adjacent n2 n3)
    (adjacent n3 n4)
    (adjacent n4 n5)
)

(:goal (and
    ;todo: put the goal condition here
    ; resource is moved from n2 to n3
    (rlocation r1 n5)
    ;(alocation a1 n5)
    ;(alocation a2 n4)
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
