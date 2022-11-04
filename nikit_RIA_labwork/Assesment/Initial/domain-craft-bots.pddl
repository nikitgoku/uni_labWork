(define (domain craft-bots)

    ;remove requirements that are not needed
    (:requirements :strips :fluents :durative-actions :timed-initial-literals 
    :typing :conditional-effects :negative-preconditions :duration-inequalities 
    :equality :numeric-fluents)
    (:types
        actor resource nodes - object
    )

    (:predicates
        (idle ?a - actor)                       ; The actor is idle
        (adjacent ?nodeI ?nodeJ - nodes)        ; Nodes where the actor can travel are adjacent to each other
        (alocation ?a - actor ?node - nodes)    ; Actor should be at any one of the nodes
        (rlocation ?r - resource ?node - nodes) ; Resource must be at the same node as actor
        (rfree ?r - resource)                   ; resource is free
        (pickedup ?a - actor ?r - resource)     ; resource is with the actor
        (dropall ?a - actor ?r - resource)      ; drop resource
    )

    (:functions
        (inventory_space ?a - actor) - number
        (resource_size ?r - resource) - number
    )

    ;; Action to move the actor from one node to another
    (:action move_actor
        :parameters (?act - actor ?ni ?nj - nodes)
        :precondition (and 
            (idle ?act)                 ; actor is idle
            (alocation ?act ?ni)        ; actor is at node1
            (adjacent ?ni ?nj)          ; node1 and node2 are adjacent
        )
        :effect (and 
            (not (alocation ?act ?ni))  ; actor is not at node1
            (alocation ?act ?nj)        ; actor is at node2
        )
    )

    ;; Action to make the actor pick up resource
    (:action pick_up_resource
        :parameters (?act - actor ?ni ?nj - nodes ?re - resource)
        :precondition (and             
            (idle ?act)                 ; actor must be idle
            (rfree ?re)                 ; resource must be free (not held by another actor)
            (rlocation ?re ?ni)         ; resource must be at the location
            (alocation ?act ?ni)        ; actor must be at the location
            (> (inventory_space ?act) (resource_size ?re))  ; when inventory space is greater than the resource size
        )
        :effect (and 
            (not (rfree ?re))           ; resource is occupied
            (pickedup ?act ?re)         ; resource is picked-up by the actor
            (decrease (inventory_space ?act) (resource_size ?re)) ; reduce the inventory space by the resource size
        )
    )

    ;; Action to make the actor drop the resource
    (:action drop_resource
        :parameters (?act - actor ?re - resource ?ni - nodes)
        :precondition (and
            (idle ?act)                 ; actor must be idle
            (alocation ?act ?ni)        ; actor must be at the location
            (pickedup ?act ?re)         ; actor has the resource
        )
        :effect (and 
            (dropall ?act ?re)          ; actor must drop the resource
            (rlocation ?re ?ni)         ; resource is now at the new location
            (increase (inventory_space ?act) (resource_size ?re)) ;; the inventory is freed with space of the resource dropped
        )
    )
)