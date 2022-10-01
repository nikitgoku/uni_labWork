(define (problem simple_problem)
(:domain simple_switches)

    (:objects
        ;; switches
        switch_1 - switch
        switch_2 - switch
        switch_3 - switch
    )

    ;; This section defines the initial state of the problem instance by
    ;; listing down all the facts that are true in that state
    (:init
        (off switch_1) (off switch_2) (off switch_3)
    )
    
    ;; This sections specifies a condition that must be satisfied at the
    ;; end of the valid plan
    (:goal (and
        (on switch_1) (on switch_2) (on switch_3)
    ))

)