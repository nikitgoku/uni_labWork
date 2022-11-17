(define (domain craft-bots)

    ;remove requirements that are not needed
    (:requirements :strips :fluents :durative-actions :timed-initial-literals 
    :typing :conditional-effects :negative-preconditions :duration-inequalities 
    :equality :numeric-fluents)
    (:types
        actor resource nodes mines building
    )

    (:predicates
        (atRest ?a - actor)                                   ; The actor is atRest
        (connected ?nodeI ?nodeJ - nodes)                    ; Nodes where the actor can travel are connected to each other
        (actorLoc ?a - actor ?node - nodes)                ; Actor should be at any one of the nodes
        (resLocation ?r - resource ?node - nodes)             ; Resource must be at the same node as actor
        (lift ?a - actor ?r - resource)                 ; resource is with the actor
        (mineLoc ?m - mines ?n - nodes)                   ; Mines must be at some of the locations
        (minefree ?m - mines)                                  ; No other actior must be mining for resource
        (mResource ?m - mines ?r - resource)             ; Mine associated with the resource            
        (resourcefree ?r - resource)                               ; resource is free        
        (beginSite ?n - nodes)                          ; site will be started at the node
        (constructed ?bi - building ?n - nodes)             ; building is completed        
        (startConstruct ?a - actor ?n - nodes)           ; actor starts constructing building at the node
        (underConstruct ?b - building ?n - nodes)        ; the building is under construction
    )

    (:functions

        (inventory_size ?a - actor) - number
        (constructStatus ?b - building ?n - nodes) - number
        (siteResources ?n - nodes) - number
        (resource_size ?r - resource) - number
    )

    ;; Action to move the actor from one node to another
    (:durative-action move_actor
        :parameters (?act - actor ?ni ?nj - nodes)
        :duration (= ?duration 1)
        :condition (and 
            (at start (atRest ?act))              ; actor must be atRest
            (over all (connected ?ni ?nj))       ; node1 and node2 are connected            
            (over all (actorLoc ?act ?ni))     ; actor is at node1
        )
        :effect (and
            (at start (not (atRest ?act)))        ; while moving, the actor must not be atRest 
            (at end (actorLoc ?act ?nj))       ; actor is at node2
            (at end (not (actorLoc ?act ?ni))) ; actor is not at node1
            (at end (atRest ?act))                ; actor should be free at the end            
        )
    )
    
    ;; Action to make the actor dig at a mine and pick up resources
    (:durative-action dig_out
        :parameters (?act - actor ?ni - nodes ?re - resource ?mi - mines)
        :duration (= ?duration 3)
        :condition (and 
            (at start (atRest ?act))              ; actor must be atRest
            (over all (actorLoc ?act ?ni))     ; actor must be at the location
            (over all (mResource ?mi ?re))   ; take out only the type of resource the mine has
            (over all (minefree ?mi))              ; mine must not be occupied
            (over all (mineLoc ?mi ?ni))      ; mine shoulb be there at the node            
        )
        :effect (and 
            (at start (not (atRest ?act)))        ; while performing this task, the actor must not be atRest
            (at end (atRest ?act))                ; actor should be free at the end
            (at end (resourcefree ?re))                ; resource is now free to be picked by the actor
            (at end (resLocation ?re ?ni))        ; resource is now placed at the node after mining
        )
    )

    ;; Action to make the actor pick up resource
    (:durative-action liftResource
        :parameters (?act - actor ?ni - nodes ?re - resource)
        :duration (= ?duration 1)
        :condition (and 
            (at start (atRest ?act))                                      ; actor must be atRest
            (over all (actorLoc ?act ?ni))                             ; actor must be at the location
            (over all (resLocation ?re ?ni))                              ; resource must be at the location
            (over all (resourcefree ?re))                                 ; resource must be free (not held by another actor)
            (over all (> (inventory_size ?act) (resource_size ?re)))   ; inventory space of the actor must be greater than the resource size
        )
        :effect (and 
            (at start (not(atRest ?act)))                                     ; actor must not be atRest while performing this task
            (at end (lift ?act ?re))                                    ; actor has picked the resource
            (at end (not(resourcefree ?re)))                                       ; resource should now be free
            (at end (not (resLocation ?re ?ni)))                              ; resource not at it's current location now
            (at end (decrease (inventory_size ?act) (resource_size ?re)))  ; decrease the inventory space by resource size
            (at end (atRest ?act))                                            ; actor is now free to move
        )
    )

    
    ;; Action to make the actor deposit the resources
    (:durative-action deposit_resource
        :parameters (?act - actor ?re - resource ?ni - nodes)
        :duration (= ?duration 1)
        :condition (and 
            (at start (atRest ?act))                          ; actor must be atRest
            (at start (lift ?act ?re))                  ; actor has the resource
            (at start (actorLoc ?act ?ni))                 ; actor must be at the location
            (at start (beginSite ?ni))                  ; only deposit resource at node where the site has started
            (at start (> (inventory_size ?act) 0))         ; There should be some resource in actor's inventory
            (over all (>= (siteResources ?ni) 0)) ; There can be a scenario that the site already has some resource
        )
        :effect (and 
            (at start (not (atRest ?act)))                                            ; while performing the task the actor is not atRest
            (at end (increase (inventory_size ?act) (resource_size ?re)))          ; increase the inventory size by the resource size            
            (at end (not (lift ?act ?re)))                                      ; actor doesn't have the resource now
            (at end (resLocation ?re ?ni))                                            ; resource is now at the new location
            (at end (increase (siteResources ?ni) 1))                     ; build resource count at the site increases
            (at end (atRest ?act))                                                    ; actor is now atRest
        )
    )

    ; Action to start the site
    (:durative-action start_site
        :parameters (?act - actor ?ni - nodes)
        :duration (= ?duration 1)
        :condition (and 
            (at start (atRest ?act))          ; actor must be atRest
            (over all (actorLoc ?act ?ni)) ; to start a site, actor should be at the node
        )
        :effect (and
            (at start (not (atRest ?act)))    ; while performing this task, the actor must not be atRest
            (at end (atRest ?act))            ; after this the actor is atRest            
            (at end (beginSite ?ni))    ; site will be started at the node
        )
    )
    
    (:durative-action finish_construct
        :parameters (?act - actor ?ni - nodes ?bi - building)
        :duration (= ?duration 1)
        :condition (and 
            (at start (atRest ?act))                          ; actor must be atRest
            (at start (>= (siteResources ?ni) 1))  ; resource must be sufficient to construct a building
            (at start (>= (constructStatus ?bi ?ni) 2))      ; construction is just starting
            (at start (underConstruct ?bi ?ni))          ; building should've been under construction to proceed
            (over all (beginSite ?ni))                  ; the site must've been started
            (over all (actorLoc ?act ?ni))                 ; actor must be at the location
        )
        :effect (and 
            (at start (not (atRest ?act)))                    ; the actor is not atRest
           
            (at end (constructed ?bi ?ni))                  ; the bulding is constructed
            (at end (not (beginSite ?ni)))              ; site is finished
            (at end (not (underConstruct ?bi ?ni)))      ; construction stops
            (at end (not (startConstruct ?act ?ni)))     ; can start again
            (at end (atRest ?act))                            ; actor is now free to roam            
        )
    )
    

    ;; Action to start the construction of building at the node
    (:durative-action start_construct
        :parameters (?act - actor ?ni - nodes ?bi - building)
        :duration (= ?duration 1)
        :condition (and
            (at start (atRest ?act))                          ; actor must be atRest
            (at start (>= (siteResources ?ni) 3)) ; resource must be sufficient to construct a building
            (over all (beginSite ?ni))                  ; the site must've been started            
            (over all (actorLoc ?act ?ni))                 ; actor must be at the location
        )
        :effect (and 
            (at start (not (atRest ?act)))                    ; the actor is not atRest
            (at start (startConstruct ?act ?ni))         ; construction has started
            (at end (assign (siteResources ?ni) 0))       ; build resource are used
            (at end (underConstruct ?bi ?ni))                   ; update the status to building is under construction
            (at end (increase (constructStatus ?bi ?ni) 1))     ; construction status to be increased
            (at end (atRest ?act))                              ; actor is now free to roam

        )
    )


)
