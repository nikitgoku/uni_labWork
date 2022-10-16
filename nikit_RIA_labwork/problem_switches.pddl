(define (problem simple_problem)
(:domain simple_switches)

    (:objects
        ;; switches
        switch_1 switch_2 switch_3 switch_4 switch_5 - switch
        switch_6 switch_7 switch_8 switch_9 switch_10 - switch
    )

    ;; This section defines the initial state of the problem instance by
    ;; listing down all the facts that are true in that state
    ;; A desription of the initial situation
    (:init
        (on switch_1) 
        (off switch_2) 
        (on switch_3)
        (off switch_4)
        (off switch_5)
        (on switch_6)
        (off switch_7)
        (off switch_8)
        (on switch_9)
        (off switch_10)
        (neighbours_3 switch_1 switch_2 switch_3)
        (neighbours_3 switch_2 switch_3 switch_4)
        (neighbours_3 switch_3 switch_4 switch_5)
        (neighbours_3 switch_4 switch_5 switch_6)
        (neighbours_3 switch_5 switch_6 switch_7)
        (neighbours_3 switch_6 switch_7 switch_8)
        (neighbours_3 switch_7 switch_8 switch_9)
        (neighbours_3 switch_8 switch_9 switch_10)
        (neighbours_3 switch_10 switch_9 switch_8)
        (neighbours_3 switch_9 switch_8 switch_7)
        (neighbours_3 switch_8 switch_7 switch_6)
        (neighbours_3 switch_7 switch_6 switch_5)
        (neighbours_3 switch_6 switch_5 switch_4)
        (neighbours_3 switch_5 switch_4 switch_3)
        (neighbours_3 switch_4 switch_3 switch_2)
        (neighbours_3 switch_3 switch_2 switch_1)
        ;;(neighbours switch_2 switch_3)
        ;;(neighbours switch_3 switch_4)
        ;;(neighbours switch_4 switch_5)
        ;;(neighbours switch_5 switch_6)
        ;;(neighbours switch_6 switch_7)
        ;;(neighbours switch_7 switch_8)
        ;;(neighbours switch_8 switch_9)
        ;;(neighbours switch_9 switch_10)
        ;;(neighbours switch_10 switch_9)
        ;;(neighbours switch_9 switch_8)
        ;;(neighbours switch_8 switch_7)
        ;;(neighbours switch_7 switch_6)
        ;;(neighbours switch_6 switch_5)
        ;;(neighbours switch_5 switch_4)
        ;;(neighbours switch_4 switch_3)
        ;;(neighbours switch_3 switch_2)
        ;;(neighbours switch_2 switch_1)
    )
    
    ;; This sections specifies a condition that must be satisfied at the
    ;; end of the valid plan
    ;; A description of the desired situation
    (:goal (and
        (on switch_4) 
        (on switch_2) 
        (on switch_5)
        (on switch_7)
        (on switch_8)
        (on switch_10)
    ))

)