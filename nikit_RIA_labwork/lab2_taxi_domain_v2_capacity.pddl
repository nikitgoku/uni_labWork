;; Experiment with absolute simplest case
;; No fuel, no taxi limits

(define (domain taxi_capacity)
  (:requirements :strips :equality :typing :conditional-effects)

  (:types  taxi location person)


  (:predicates
    ;; The taxi is running
    (taxistate ?taxi1 - taxi)

    ;; Where taxi is located
    (tlocation ?taxi1 - taxi ?location1 - location)  

    ;; whether a person is inside a taxi (and which one) or outside
    (insidetaxi ?person1 - person ?taxi1 - taxi)
    (outsidetaxi ?person1 - person)

    ;; where that person is located
    (plocation ?person1 - person ?location1 - location)

    ;; how locations are connected, i.e. routes that can be driven
    (connects ?location1 - location ?location2 - location)

    ;; Whether taxi is full or empty
    (t_empty ?taxi - taxi)
    (t_full ?taxi - taxi)
  )
  (:action getout
       :parameters ( ?taxi - taxi ?location - location ?person - person)
       :precondition (and 
            (taxistate ?taxi)
            (tlocation ?taxi ?location)
            (insidetaxi ?person ?taxi)
            (t_full ?taxi)
       )
       :effect (and 
            (not (insidetaxi ?person ?taxi))
            (outsidetaxi ?person)
            (plocation ?person ?location)
            (not (t_full ?taxi))
            (t_empty ?taxi)
        )
    )
  (:action getin
       :parameters ( ?taxi - taxi ?location - location ?person - person)
       :precondition (and 
            (taxistate ?taxi)
            (tlocation ?taxi ?location)
            (outsidetaxi ?person)
            (plocation ?person ?location)
            (t_empty ?taxi)
       )
       :effect (and 
            (not (outsidetaxi ?person))
            (insidetaxi ?person ?taxi)
            (not (plocation ?person ?location))
            (not(t_empty ?taxi))
            (t_full ?taxi)
        )
    )
  (:action move
       :parameters ( ?taxi - taxi ?locationa - location ?locationb - location )
       :precondition (and 
            (taxistate ?taxi)
            (tlocation ?taxi ?locationa)
            (connects ?locationa ?locationb)
       )
       :effect (and 
            (not (tlocation ?taxi ?locationa))
            (tlocation ?taxi ?locationb)    
            )

    )
)