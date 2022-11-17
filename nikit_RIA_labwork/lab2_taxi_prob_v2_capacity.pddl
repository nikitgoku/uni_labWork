;; Simplest version of problem 
;; No fuel needed, one taxi
;; 5 locations

(define (problem taxi2)
   (:domain taxi_capacity)
   (:objects
        ;; 1 taxi, 5 locations, 6 people
         taxi_1 taxi_2 taxi_3 - taxi
         livingstone_tower royal_college graham_hills tic barony_hall - location
         scott rajesh lingjie yan misbah stuart - person
        )
    (:init
        ;; Set all to be outside taxi and at different locations
        (outsidetaxi scott)
        (plocation scott livingstone_tower)

        (outsidetaxi rajesh)
        (plocation rajesh graham_hills)

        (outsidetaxi lingjie)
        (plocation lingjie barony_hall)

        (outsidetaxi misbah)
        (plocation misbah graham_hills)

        (outsidetaxi yan)
        (plocation yan royal_college)

        (outsidetaxi stuart)
        (plocation stuart tic)
                
        ;; set taxi as active and set location
        (taxistate taxi_1)
        (tlocation taxi_1 tic)
        ;; set taxi to be empty
        (t_empty taxi_1)

        ;; Add our second taxi
        (taxistate taxi_2)
        (tlocation taxi_2 tic)
        (t_empty taxi_2)
        
        ;; Add our second taxi
        (taxistate taxi_3)
        (tlocation taxi_3 tic)
        (t_empty taxi_3)
        

        ;; Simple connections
        ;; Initially going to assume simple binary connections (i.e. a circle)
        ;; liv - royal - gra - tic - barony -- liv
        (connects livingstone_tower royal_college)
        (connects royal_college graham_hills)
        (connects graham_hills tic)
        (connects tic barony_hall)
        (connects barony_hall livingstone_tower)

        (connects royal_college livingstone_tower)
        (connects graham_hills royal_college)
        (connects tic graham_hills)
        (connects barony_hall tic)
        (connects livingstone_tower barony_hall)
        )
    
    (:goal
      (and
       (outsidetaxi scott)
        (outsidetaxi rajesh)
        (outsidetaxi lingjie)
        (outsidetaxi misbah)
        (outsidetaxi yan)
        (outsidetaxi stuart)
        (plocation scott graham_hills)
        (plocation rajesh barony_hall)
        (plocation lingjie livingstone_tower)
        (plocation yan tic)
        (plocation misbah barony_hall )
        (plocation stuart livingstone_tower)

       ))
)