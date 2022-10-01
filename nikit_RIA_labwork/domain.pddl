(define (domain simple_switches)
    ;; The requirements section indicates which feature of the 
    ;; PDDL does the domain uses; what kind of planning problem
    ;; it is.
    (:requirements
        :typing
    )

    (:types
        switch
    )
    
    ;; This section contains the list of model's state variable
    ;; mainly binary variables
    (:predicates
        (off ?s - switch) (on ?s - switch)
    )

    ;; This section defines the transitions between states
    (:action switch_on
        :parameters (?s - switch)
        :precondition (off ?s)
        :effect (and (not (off ?s)) (on ?s))
    )
    
    (:action switch_off
        :parameters (?s - switch)
        :precondition (on ?s)
        :effect (and (not (on ?s)) (off ?s))
    )
)