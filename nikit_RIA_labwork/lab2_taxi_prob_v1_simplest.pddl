;; Simplest version of problem 
;; No fuel needed, one taxi
;; 5 locations

(define (problem taxi1)
   (:domain taxi_simplest)
   (:objects
        ;; 1 taxi, 5 locations, 3 people
         taxi_1 taxi_2 - taxi
         livingstone_tower royal_college graham_hills tic barony_hall - location
         scott rajesh lingjie - person
        )
    (:init
        ;; Set all to be outside taxi and at different locations
        (exited scott taxi_1)
        (plocation scott livingstone_tower)

        (exited rajesh taxi_2)
        (plocation rajesh graham_hills)

        ;;(outsidetaxi lingjie)
        ;;(plocation lingjie barony_hall)
        
        ;; set taxi as active and set location
        (tlocation taxi_1 tic)
        (active_taxi taxi_1)
        (tlocation taxi_2 livingstone_tower)
        (active_taxi taxi_2)
        
        ;; Simple connections
        ;; Initially going to assume simple binary connections (i.e. a circle)
        ;; liv - royal - gra - tic - barony -- liv
        (connects livingstone_tower royal_college)
        (connects royal_college graham_hills)
        (connects graham_hills tic)
        (connects tic barony_hall)
        (connects barony_hall livingstone_tower)
        )
    (:goal
      (and
        ;;(tlocation taxi_1 livingstone_tower)
       ;; (boarded scott taxi_1)
       ;; (tlocation taxi_1 barony_hall)
        ;;(outsidetaxi rajesh)
        ;;(outsidetaxi lingjie)
        (plocation scott barony_hall)
        (plocation rajesh livingstone_tower)
       ;; (exited scott taxi_1)
       ;; (active_taxi taxi_1)
        ;;(plocation rajesh barony_hall)
        ;;(plocation lingjie livingstone_tower)

       ))
)