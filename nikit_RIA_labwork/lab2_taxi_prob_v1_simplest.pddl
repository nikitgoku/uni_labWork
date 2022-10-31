;; Simplest version of problem 
;; No fuel needed, one taxi
;; 5 locations

(define (problem taxi1)
   (:domain taxi_simplest)
   (:objects
        ;; 1 taxi, 5 locations, 3 people
         taxi_1 - taxi
         livingstone_tower barony_hall tic royal_college graham_hills - location
         ;;scott rajesh lingjie - person
        )
    (:init
        ;; Set all to be outside taxi and at different locations
        (= (fuel_level taxi_1) 20)
        ;;(= (fuel_level taxi_2) 20)
        ;;(exited scott taxi_1)
        ;;(plocation scott livingstone_tower)

        ;;(exited rajesh taxi_2)
        ;;(plocation rajesh graham_hills)

        ;;(outsidetaxi lingjie)
        ;;(plocation lingjie barony_hall)
        (fuel_station barony_hall)
        ;; set taxi as active and set location
        (tlocation taxi_1 royal_college)
        (active_taxi taxi_1)
        ;(tlocation taxi_2 livingstone_tower)
        ;(active_taxi taxi_2)
        
        ;; Simple connections
        ;; Initially going to assume simple binary connections (i.e. a circle)
        ;; liv - royal - gra - tic - barony -- liv
        (= (fuel_cost livingstone_tower royal_college) 5)
        (= (fuel_cost royal_college graham_hills) 8)
        (= (fuel_cost graham_hills tic) 3)
        (= (fuel_cost tic barony_hall) 6)
        (= (fuel_cost barony_hall livingstone_tower) 5)

        ;(= (fuel_cost livingstone_tower barony_hall) 5)
        ;(= (fuel_cost barony_hall tic) 8)
        ;(= (fuel_cost tic graham_hills) 3)
        ;(= (fuel_cost graham_hills royal_college) 6)
        ;(= (fuel_cost royal_college livingstone_tower) 5)

        (connects livingstone_tower royal_college)
        (connects royal_college graham_hills)
        (connects graham_hills tic)
        (connects tic barony_hall)
        (connects barony_hall livingstone_tower)
        ;(connects livingstone_tower barony_hall)
        ;(connects barony_hall tic)
        ;(connects tic graham_hills)
        ;(connects graham_hills royal_college)
        ;(connects royal_college livingstone_tower)
    )

    (:goal
      (and
          (tlocation taxi_1 livingstone_tower) 
          ;(tlocation taxi_2 royal_college)
          ;;(outsidetaxi rajesh)
          ;;(outsidetaxi lingjie)
          ;;(plocation scott barony_hall)
          ;;(plocation rajesh livingstone_tower)
          ;;(exited scott taxi_1)
          ;;(active_taxi taxi_1)
          ;;(plocation rajesh barony_hall)
          ;;(plocation lingjie livingstone_tower)
      )
    )
)