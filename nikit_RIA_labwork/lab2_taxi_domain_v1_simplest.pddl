;Header and description

(define (domain taxi_simplest)

;remove requirements that are not needed
(:requirements :strips :fluents :durative-actions :timed-initial-literals 
 :typing :conditional-effects :negative-preconditions :duration-inequalities 
 :equality :numeric-fluents)
(:types 
    ;todo: enumerate types and their hierarchy here, e.g. car truck bus -vehicle
    location locatable - object
    taxi person - locatable
)

; un-comment following line if constants are needed
;(:constants )

;todo: define predicates here
(:predicates
    (tlocation ?loc - locatable ?l - location)
    (plocation ?loc - locatable ?l - location)
    (connects ?from ?to - location)
    (active_taxi ?t - locatable)
    (not_active_taxi ?t - locatable)
    (boarded ?p - person ?t - locatable)
    (exited ?p - person ?t - locatable)
)


(:functions ;todo: define numeric functions here
    (fuel_cost ?from ?to - location)- number
    (fuel_level ?t - taxi)- number
)

;define actions here
(:action move_taxi
    :parameters (?t - taxi ?from ?to - location)
    :precondition (and 
        ;; if the fuel capacity is greater than the fuel cost of the location, 
        ;; then only move the taxi
        (> (fuel_level ?t) (fuel_cost ?from ?to))
        (tlocation ?t ?from)          ;; taxi at location
        (connects ?from ?to)          ;; the locations are connected
    )
    :effect (and 
        (not (tlocation ?t ?from))    ;; taxi is moved
        (tlocation ?t ?to)            ;; taxi is at desired location
        ;; decrease the overall fuel capacity by the fuel cost
        ;; to travel from location 1 to location 2
        (decrease (fuel_level ?t) (fuel_cost ?from ?to))
    )
)

(:action board_taxi
    :parameters (?t - taxi ?p - person ?tp - location)
    :precondition (and
        (active_taxi ?t)          ;; taxi should be active
        (tlocation ?t ?tp)        ;; taxi should be at the location
        (plocation ?p ?tp)        ;; person should also be at the location
    )
    :effect (and 
        (not_active_taxi ?t)      ;; remove the active_taxi mark
        (boarded ?p ?t)           ;; taxi is boarded
        (not(exited ?p ?t))
    )

)

(:action exit_taxi
    :parameters (?t - taxi ?p - person ?gp - location)
    :precondition (and 
        (not_active_taxi ?t)      ;; taxi should not be active
        (tlocation ?t ?gp)        ;; taxi should be at the goal location
    )
    :effect (and 
        (active_taxi ?t)          ;; taxi now should be acitve
        (exited ?p ?t)            ;; person should now exit
        (plocation ?p ?gp)
    )
)

(:action refuel
    :parameters (?t - taxi ?rl - refuel_location)
    :precondition (and
        (tlocation ?t ?rl)      ;; taxi is at the refuel location
        (= (fuel_level ?t) 0)   ;; only refuel when the taxi has no fuel left
    )
    :effect (and 
            ;; Restore the fuel to 20
            (assign (fuel_level ?t) 20)
    )
)

)