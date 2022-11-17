;Header and description
(define (domain matchcellar)

;remove requirements that are not needed
(:requirements :typing :strips :fluents :durative-actions :timed-initial-literals 
 :typing :conditional-effects :negative-preconditions :duration-inequalities 
 :equality)

(:types
;todo: enumerate types and their hierarchy here, e.g. car truck bus-vehicle
    match fuse
)

; un-comment following line if constants are needed
;(:constants )

(:predicates ;todo: define predicates here
    (light ?m -match)
    (unused ?m - match)
    (mended ?f - fuse)
    (handsfree)
)


(:functions ;todo: define numeric functions here
)

;define actions here
(:durative-action light_match
    :parameters (?m - match)
    :duration (= ?duration 8)
    :condition (and 
        (at start (unused ?m))
    )
    :effect (and 
        (at start (not (unused ?m)))
        (at start (light ?m ))
        (at end (not (light ?m)))
    )
)

(:durative-action mend_fuse
    :parameters (?f - fuse ?m - match)
    :duration (= ?duration 5)
    :condition (and 
        (at start (handsfree))
        (over all (light ?m))
    )
    :effect (and 
        (at start (not (handsfree)))
        (at end (mended ?f))
        (at end (not (light ?m)))
    )
)


)