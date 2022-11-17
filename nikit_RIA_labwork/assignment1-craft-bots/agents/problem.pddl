(define(problem craft-bots-problem)
(:domain craft-bots)
(:objects
 a29 a31 a30 - actor
 node0 node1 node3 node5 node8 node10 node12 node16 node18 node20 - nodes
 mine36 mine33 mine34 mine32 mine35  - mines
 red blue green orange black - resource
 building23 building24 building25 building26 building27 building28  - building
)

(:init
 (idle a29)
 (idle a31)
 (idle a30)
 
 (alocation a29 node20)
 (alocation a31 node5)
 (alocation a30 node3)
 
 (= (inventory_space a29) 7)
 (= (inventory_space a31) 7)
 (= (inventory_space a30) 7)
 
 (adjacent node0 node1)
 (adjacent node1 node3)
 (adjacent node3 node5)
 (adjacent node5 node8)
 (adjacent node8 node10)
 (adjacent node10 node12)
 (adjacent node12 node16)
 (adjacent node16 node18)
 (adjacent node18 node20)
 
 (adjacent node1 node0)
 (adjacent node3 node1)
 (adjacent node5 node3)
 (adjacent node8 node5)
 (adjacent node10 node8)
 (adjacent node12 node10)
 (adjacent node16 node12)
 (adjacent node18 node16)
 (adjacent node20 node18)
 
 (mfree mine36)
 (mfree mine33)
 (mfree mine34)
 (mfree mine32)
 (mfree mine35)
 
 (mlocation mine36 node5)
 (mlocation mine33 node10)
 (mlocation mine34 node1)
 (mlocation mine32 node16)
 (mlocation mine35 node8)
 
 (mineResource mine36 red)
 (mineResource mine33 blue)
 (mineResource mine34 green)
 (mineResource mine32 orange)
 (mineResource mine35 black)
 
 (= (resource_size red) 1)
 (= (resource_size blue) 1)
 (= (resource_size green) 1)
 (= (resource_size orange) 1)
 (= (resource_size black) 1)
 
 (= (build_resources_at_site node0) 0)
 (= (build_resources_at_site node1) 0)
 (= (build_resources_at_site node3) 0)
 (= (build_resources_at_site node5) 0)
 (= (build_resources_at_site node8) 0)
 (= (build_resources_at_site node10) 0)
 (= (build_resources_at_site node12) 0)
 (= (build_resources_at_site node16) 0)
 (= (build_resources_at_site node18) 0)
 (= (build_resources_at_site node20) 0)
 
 (= (construction_status building23 node1) 0)
 (= (construction_status building24 node10) 0)
 (= (construction_status building25 node8) 0)
 (= (construction_status building26 node20) 0)
 (= (construction_status building27 node5) 0)
 (= (construction_status building28 node0) 0)
 
 )

(:goal (and
 (constructed building23 node1)
 )
)
)
