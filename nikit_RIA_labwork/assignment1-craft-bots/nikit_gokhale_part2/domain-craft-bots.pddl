(define (domain craft-bots)

    ;remove requirements that are not needed
    (:requirements :strips :fluents :durative-actions :timed-initial-literals 
    :typing :conditional-effects :negative-preconditions :duration-inequalities 
    :equality :numeric-fluents)
    (:types
        actor resource nodes mines building
    )

    (:predicates
        (idle ?a - actor)                              ; The actor is idle
        (adjacent ?nodeI ?nodeJ - nodes)               ; Nodes where the actor can travel are adjacent to each other
        (alocation ?a - actor ?node - nodes)           ; Actor should be at any one of the nodes
        (rlocation ?r - resource ?node - nodes)        ; Resource must be at the same node as actor
        (mlocation ?m - mines ?n - nodes)              ; Mines must be at some of the locations
        (mfree ?m - mines)                             ; No other actior must be mining for resource
        (mineResource ?m - mines ?r - resource)        ; Mine associated with the resource 
        (orangeResourceMine ?m - mines ?r - resource)  ; Mine associated with the orange resource
        (redResourceMine ?m - mines ?r - resource)     ; Mine associated with the red resource
        (rfree ?r - resource)                          ; resource is free
        (blueResource ?r - resource)                   ; resource is blue
        (redResource ?r - resource)                    ; resource is red
        (greenResource ?r - resource)                  ; resource is green
        (orangeResource ?r - resource)                 ; resource is orange
        (blackResource ?r - resource)                  ; resource is black
        (pickedup ?a - actor ?r - resource)            ; resource is with the actor
        (siteStartedAt ?n - nodes)                     ; site will be started at the node
        (startConstruction ?a - actor ?n - nodes)      ; actor starts constructing building at the node
        (underConstruction ?b - building ?n - nodes)   ; the building is under construction
        (constructed ?bi - building ?n - nodes)        ; building is completed
    )

    (:functions
        (inventory_space ?a - actor) - number			        ; inventory space the actor has
        (resource_size ?r - resource) - number			        ; resource size
        (build_resources_at_site ?n - nodes) - number		    ; buidl resource at the site
        (construction_status ?b - building ?n - nodes) - number	; construction status of the buidling
    )

    ;; Action to move the actor from one node to another
    (:durative-action move_actor
        :parameters (?act - actor ?ni ?nj - nodes)
        :duration (= ?duration 1)
        :condition (and 
            (at start (idle ?act))              ; actor must be idle
            (over all (alocation ?act ?ni))     ; actor is at node1
            (over all (adjacent ?ni ?nj))       ; node1 and node2 are adjacent
        )
        :effect (and
            (at start (not (idle ?act)))        ; while moving, the actor must not be idle 
            (at end (not (alocation ?act ?ni))) ; actor is not at node1
            (at end (alocation ?act ?nj))       ; actor is at node2
            (at end (idle ?act))                ; actor should be free at the end
        )
    )
    
    ;; Action to make the actor dig blue, black and green resources
    (:durative-action dig_mine
        :parameters (?act - actor ?ni - nodes ?re - resource ?mi - mines)
        :duration (= ?duration 3)
        :condition (and 
            (at start (idle ?act))              ; actor must be idle

            (over all (mlocation ?mi ?ni))      ; mine shoulb be there at the node
            (over all (mfree ?mi))              ; mine must not be occupied
            (over all (mineResource ?mi ?re))   ; take out only the type of resource the mine has
            (over all (alocation ?act ?ni))     ; actor must be at the location
        )
        :effect (and 
            (at start (not (idle ?act)))        ; while performing this task, the actor must not be idle

            (at end (rlocation ?re ?ni))        ; resource is now placed at the node after mining
            (at end (rfree ?re))                ; resource is now free to be picked by the actor
            (at end (idle ?act))                ; actor should be free at the end
        )
    )

    ;; Action to dig for 'orange' resource
    ;; It requires two actors to dig the orange resource
    (:durative-action dig_Orangemine
        :parameters (?act1 ?act2 - actor ?ni - nodes ?re - resource ?mi - mines)
        :duration (= ?duration 3)
        :condition (and 
            (at start (idle ?act1))                 ; actor1 must be idle
            (at start (idle ?act2))                 ; actor2 must be idle

            (over all (mlocation ?mi ?ni))          ; mine shoulb be there at the node
            (over all (mfree ?mi))                  ; mine must not be occupied
            (over all (orangeResourceMine ?mi ?re)) ; only mine for orange resource
            (over all (alocation ?act1 ?ni))        ; actor1 must be at the location
            (over all (alocation ?act2 ?ni))        ; actor2 must be at the location
        )
        :effect (and 
            (at start (not (idle ?act1)))           ; while performing this task, the actor1 must not be idle
            (at start (not (idle ?act2)))           ; while performing this task, the actor2 must not be idle

            (at end (rlocation ?re ?ni))            ; resource is now placed at the node after mining
            (at end (rfree ?re))                    ; resource is now free to be picked by the actor
            (at end (idle ?act1))                   ; actor should be free at the end
            (at end (idle ?act2))                   ; actor should be free at the end
        )
    )

    ;; Action to dig for 'red' resource
    (:durative-action dig_Redmine
        :parameters (?act - actor ?ni - nodes ?re - resource ?mi - mines)
        :duration (= ?duration 3)
        :condition (and 
            (at start (idle ?act))                  ; actor must be idle

            (over all (mlocation ?mi ?ni))          ; mine shoulb be there at the node
            (over all (mfree ?mi))                  ; mine must not be occupied
            (over all (redResourceMine ?mi ?re))    ; only mine for blue resource
            (over all (alocation ?act ?ni))         ; actor1 must be at the location
        )
        :effect (and 
            (at start (not (idle ?act)))            ; while performing this task, the actor must not be idle

            (at end (rlocation ?re ?ni))            ; resource is now placed at the node after mining
            (at end (rfree ?re))                    ; resource is now free to be picked by the actor
            (at end (idle ?act))                    ; actor should be free at the end
        )
    )

    ;; Action to make the actor pick up red resource
    (:durative-action pickUp_red_resource
        :parameters (?act - actor ?ni - nodes ?re - resource)
        :duration (= ?duration 1)
        :condition (and 
            (at start (idle ?act))                                          ; actor must be idle
            (at start (redResource ?re))                                    ; resource must be red
            (over all (rfree ?re))                                          ; resource must be free (not held by another actor)
            (over all (rlocation ?re ?ni))                                  ; resource must be at the location
            (over all (alocation ?act ?ni))                                 ; actor must be at the location
            (over all (> (inventory_space ?act) (resource_size ?re)))       ; inventory space of the actor must be greater than the resource size
        )
        :effect (and 
            (at start (not(idle ?act)))                                     ; actor must not be idle while performing this task
            (at end (not (rlocation ?re ?ni)))                              ; resource not at it's current location now
            (at end (not(rfree ?re)))                                       ; resource should now be free
            (at end (pickedup ?act ?re))                                    ; actor has picked the resource
            (at end (decrease (inventory_space ?act) (resource_size ?re)))  ; decrease the inventory space by resource size
            (at end (idle ?act))                                            ; actor is now free to move
        )
    )

    ;; Action to make actor pick up blue resource
    (:durative-action pickUp_blue_resource
        :parameters (?act - actor ?ni - nodes ?re - resource)
        :duration (= ?duration 2)
        :condition (and 
            (at start (idle ?act))                                          ; actor must be idle
            (at start (blueResource ?re))                                   ; resource must be blue
            (over all (rfree ?re))                                          ; resource must be free (not held by another actor)
            (over all (rlocation ?re ?ni))                                  ; resource must be at the location
            (over all (alocation ?act ?ni))                                 ; actor must be at the location
            (over all (> (inventory_space ?act) (resource_size ?re)))       ; inventory space of the actor must be greater than the resource size
        )
        :effect (and 
            (at start (not(idle ?act)))                                     ; actor must not be idle while performing this task
            (at end (not (rlocation ?re ?ni)))                              ; resource not at it's current location now
            (at end (not(rfree ?re)))                                       ; resource should now be free
            (at end (pickedup ?act ?re))                                    ; actor has picked the resource
            (at end (decrease (inventory_space ?act) (resource_size ?re)))  ; decrease the inventory space by resource size
            (at end (idle ?act))                                            ; actor is now free to move
        )
    )

    ;; Action to make the actor pick up green resource
    (:durative-action pickUp_green_resource
        :parameters (?act - actor ?ni - nodes ?re - resource)
        :duration (= ?duration 1)
        :condition (and 
            (at start (idle ?act))                                          ; actor must be idle
            (at start (greenResource ?re))                                  ; resource must be red
            (over all (rfree ?re))                                          ; resource must be free (not held by another actor)
            (over all (rlocation ?re ?ni))                                  ; resource must be at the location
            (over all (alocation ?act ?ni))                                 ; actor must be at the location
            (over all (> (inventory_space ?act) (resource_size ?re)))       ; inventory space of the actor must be greater than the resource size
        )
        :effect (and 
            (at start (not(idle ?act)))                                     ; actor must not be idle while performing this task
            (at end (not (rlocation ?re ?ni)))                              ; resource not at it's current location now
            (at end (not(rfree ?re)))                                       ; resource should now be free
            (at end (pickedup ?act ?re))                                    ; actor has picked the resource
            (at end (decrease (inventory_space ?act) (resource_size ?re)))  ; decrease the inventory space by resource size
            (at end (idle ?act))                                            ; actor is now free to move
        )
    )

    ;; Action to make actor pick up orange resource
    (:durative-action pickUp_orange_resource
        :parameters (?act - actor ?ni - nodes ?re - resource)
        :duration (= ?duration 2)
        :condition (and 
            (at start (idle ?act))                                          ; actor must be idle
            (at start (orangeResource ?re))                                 ; resource must be red
            (over all (rfree ?re))                                          ; resource must be free (not held by another actor)
            (over all (rlocation ?re ?ni))                                  ; resource must be at the location
            (over all (alocation ?act ?ni))                                 ; actor must be at the location
            (over all (> (inventory_space ?act) (resource_size ?re)))       ; inventory space of the actor must be greater than the resource size
        )
        :effect (and 
            (at start (not(idle ?act)))                                     ; actor must not be idle while performing this task
            (at end (not (rlocation ?re ?ni)))                              ; resource not at it's current location now
            (at end (not(rfree ?re)))                                       ; resource should now be free
            (at end (pickedup ?act ?re))                                    ; actor has picked the resource
            (at end (decrease (inventory_space ?act) (resource_size ?re)))  ; decrease the inventory space by resource size
            (at end (idle ?act))                                            ; actor is now free to move
        )
    )

    ;; Action to make actor pick up black resource
    (:durative-action pickUp_black_resource
        :parameters (?act - actor ?ni - nodes ?re - resource)
        :duration (= ?duration 2)
        :condition (and 
            (at start (idle ?act))                                          ; actor must be idle
            (at start (blackResource ?re))                                  ; resource must be red
            (over all (rfree ?re))                                          ; resource must be free (not held by another actor)
            (over all (rlocation ?re ?ni))                                  ; resource must be at the location
            (over all (alocation ?act ?ni))                                 ; actor must be at the location
            (over all (> (inventory_space ?act) (resource_size ?re)))       ; inventory space of the actor must be greater than the resource size
        )
        :effect (and 
            (at start (not(idle ?act)))                                     ; actor must not be idle while performing this task
            (at end (not (rlocation ?re ?ni)))                              ; resource not at it's current location now
            (at end (not(rfree ?re)))                                       ; resource should now be free
            (at end (pickedup ?act ?re))                                    ; actor has picked the resource
            (at end (decrease (inventory_space ?act) (resource_size ?re)))  ; decrease the inventory space by resource size
            (at end (idle ?act))                                            ; actor is now free to move
        )
    )

    
    ;; Action to make the actor deposit the resources
    (:durative-action deposite_resource
        :parameters (?act - actor ?re - resource ?ni - nodes)
        :duration (= ?duration 1)
        :condition (and 
            (at start (idle ?act))                                                  ; actor must be idle
            (at start (siteStartedAt ?ni))                                          ; only deposit resource at node where the site has started
            (at start (alocation ?act ?ni))                                         ; actor must be at the location
            (at start (pickedup ?act ?re))                                          ; actor has the resource
            (at start (> (inventory_space ?act) 0))                                 ; There should be some resource in actor's inventory
            (over all (>= (build_resources_at_site ?ni) 0))                         ; There can be a scenario that the site already has some resource
        )
        :effect (and 
            (at start (not (idle ?act)))                                            ; while performing the task the actor is not idle

            (at end (increase (inventory_space ?act) (resource_size ?re)))          ; increase the inventory size by the resource size            
            (at end (not (pickedup ?act ?re)))                                      ; actor doesn't have the resource now
            (at end (rlocation ?re ?ni))                                            ; resource is now at the new location
            (at end (increase (build_resources_at_site ?ni) (resource_size ?re)))   ; build resource count at the site increases
            (at end (idle ?act))                                                    ; actor is now idle
        )
    )

    ; Action to start the site
    (:durative-action start_site
        :parameters (?act - actor ?ni - nodes)
        :duration (= ?duration 1)
        :condition (and 
            (at start (idle ?act))          ; actor must be idle
            (over all (alocation ?act ?ni)) ; to start a site, actor should be at the node
        )
        :effect (and
            (at start (not (idle ?act)))    ; while performing this task, the actor must not be idle
            (at end (siteStartedAt ?ni))    ; site will be started at the node
            (at end (idle ?act))            ; after this the actor is idle
        )
    )
    

    ;; Action to start the construction of building at the node
    (:durative-action start_consturction
        :parameters (?act - actor ?ni - nodes ?bi - building)
        :duration (= ?duration 1)
        :condition (and
            (at start (idle ?act))                                  ; actor must be idle
            (at start (>= (build_resources_at_site ?ni) 3))         ; resource must be sufficient to construct a building
            (over all (alocation ?act ?ni))                         ; actor must be at the location
            (over all (siteStartedAt ?ni))                          ; the site must've been started
        )
        :effect (and 
            (at start (not (idle ?act)))                            ; the actor is not idle
            (at start (startConstruction ?act ?ni))                 ; construction has started
            
            (at end (assign (build_resources_at_site ?ni) 0))       ; build resource are used
            (at end (increase (construction_status ?bi ?ni) 1))     ; construction status to be increased
            (at end (underConstruction ?bi ?ni))                    ; update the status to building is under construction
            (at end (idle ?act))                                    ; actor is now free to roam
        )
    )

    (:durative-action finish_construction
        :parameters (?act - actor ?ni - nodes ?bi - building)
        :duration (= ?duration 1)
        :condition (and 
            (at start (idle ?act))                          ; actor must be idle
            (at start (>= (build_resources_at_site ?ni) 1)) ; resource must be sufficient to construct a building
            (at start (>= (construction_status ?bi ?ni) 2)) ; construction is just starting
            (at start (underConstruction ?bi ?ni))          ; building should've been under construction to proceed

            (over all (alocation ?act ?ni))                 ; actor must be at the location
            (over all (siteStartedAt ?ni))                  ; the site must've been started

        )
        :effect (and 
            (at start (not (idle ?act)))                    ; the actor is not idle
           
            (at end (constructed ?bi ?ni))                  ; the bulding is constructed
            (at end (not (siteStartedAt ?ni)))              ; site is finished
            (at end (not (startConstruction ?act ?ni)))     ; can start again
            (at end (not (underConstruction ?bi ?ni)))      ; construction stops
            (at end (idle ?act))                            ; actor is now free to roam
        )
    )
    
)
