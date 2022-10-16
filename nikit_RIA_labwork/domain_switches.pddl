(define (domain simple_switches)
    ;; The requirements section indicates which feature of the 
    ;; PDDL does the domain uses; what kind of planning problem
    ;; it is.
    (:requirements
        :typing
    )

    ;; Set of thing that make up the world
    (:types
        switch - object
    )
    
    ;; This section contains the list of model's state variable
    ;; mainly binary variables
    ;; The properties that describe the state of the things that make
    ;; up the world (objects)
    (:predicates
        (off ?s - switch)   ;; We're trying to turn the switch "OFF"
        (on ?s - switch)    ;; We're trying to turn the switch "ON"
        (neighbours ?s1 ?s2 - switch)
        (neighbours_3 ?s1 ?s2 ?s3 - switch)
    )

    ;; This section defines the transitions between states
    ;; A description of how the world behaves and the capabilities of the agent
    ;;(:action switch_on_neighbour
    ;;    :parameters (?s1 ?s2 - switch)
    ;;    :precondition (and
    ;;        (neighbours ?s1 ?s2)    ;; And both the switches are noighbours 
    ;;        (off ?s1)               ;; Assuming the switch is OFF initially
    ;;        (on ?s2)                ;; Assuming the next witch is 'ON' initially
    ;;    )
    ;;    :effect (and 
    ;;        (not (off ?s1))         ;; Switch should not be 'OFF'
    ;;        (on ?s1))               ;; Switch must be 'ON'
    ;;)

    (:action switch_on_with_centre_one_on
        :parameters (?s1 ?s2 ?s3 - switch)
        :precondition (and 
            (neighbours_3 ?s1 ?s2 ?s3)    ;; All the three switches are neighbours
            (off ?s1)
            (off ?s3)
            (on ?s2)
        )
        :effect (and 
            (not (off ?s1))         ;; Switch should not be 'OFF'
            (on ?s1))               ;; Switch must be 'ON'
    )

    (:action switch_on_with_one_end_on
        :parameters (?s1 ?s2 ?s3 - switch)
        :precondition (and 
            (neighbours_3 ?s1 ?s2 ?s3)    ;; All the three switches are neighbours
            (off ?s1)
            (off ?s2)
            (on ?s3)
        )
        :effect (and 
            (not (off ?s2))         ;; Switch should not be 'OFF'
            (on ?s2))               ;; Switch must be 'ON'
    )

    ;;(:action switch_on
    ;;    :parameters (?s - switch)   
    ;;    :precondition (off ?s)       ;; Assuming the switch is 'ON'
    ;;    :effect (and 
    ;;        (not (off ?s))          ;; Switch should be 'ON'
    ;;        (on ?s))               ;; Switch must be 'OFF'
    ;;)
    
    (:action switch_off
        :parameters (?s - switch)   
        :precondition (on ?s)       ;; Assuming the switch is 'ON'
        :effect (and 
            (not (on ?s))           ;; Switch should be 'ON'
            (off ?s))               ;; Switch must be 'OFF'
    )
)