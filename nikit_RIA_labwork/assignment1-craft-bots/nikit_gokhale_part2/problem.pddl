(define(problem craft-bots-problem)
(:domain craft-bots)
(:objects
 a24 a25 a23 - actor
 node0 node1 node3 node6 node8 node11 node13 node15 node17 node20 - nodes
 mine29 mine26 mine28 mine30 mine27  - mines
 red blue green orange black - resource
 building22  - building
)

(:init
 (idle a24)
 (idle a25)
 (idle a23)
 
 (alocation a24 node1)
 (alocation a25 node8)
 (alocation a23 node20)
 
 (= (inventory_space a24) 7)
 (= (inventory_space a25) 7)
 (= (inventory_space a23) 7)
 
 (adjacent node0 node1)
 (adjacent node1 node3)
 (adjacent node3 node6)
 (adjacent node6 node8)
 (adjacent node8 node11)
 (adjacent node11 node13)
 (adjacent node13 node15)
 (adjacent node15 node17)
 (adjacent node17 node20)
 
 (adjacent node1 node0)
 (adjacent node3 node1)
 (adjacent node6 node3)
 (adjacent node8 node6)
 (adjacent node11 node8)
 (adjacent node13 node11)
 (adjacent node15 node13)
 (adjacent node17 node15)
 (adjacent node20 node17)
 
 (mfree mine29)
 (mfree mine26)
 (mfree mine28)
 (mfree mine30)
 (mfree mine27)
 
 (mlocation mine29 node20)
 (mlocation mine26 node13)
 (mlocation mine28 node8)
 (mlocation mine30 node0)
 (mlocation mine27 node1)
 
 (redResourcemine mine29 red)
 (mineResource mine26 blue)
 (mineResource mine28 green)
 (orangeResourcemine mine30 orange)
 (mineResource mine30 orange)
 (mineResource mine27 black)
 
 (at 2 (redResource red))
 (at 120 (not (redResource red)))
 (blueResource blue)
 (greenResource green)
 (orangeResource orange)
 (blackResource black)
 
 (= (resource_size red) 1)
 (= (resource_size blue) 1)
 (= (resource_size green) 1)
 (= (resource_size orange) 1)
 (= (resource_size black) 7)
 
 (= (build_resources_at_site node0) 0)
 (= (build_resources_at_site node1) 0)
 (= (build_resources_at_site node3) 0)
 (= (build_resources_at_site node6) 0)
 (= (build_resources_at_site node8) 0)
 (= (build_resources_at_site node11) 0)
 (= (build_resources_at_site node13) 0)
 (= (build_resources_at_site node15) 0)
 (= (build_resources_at_site node17) 0)
 (= (build_resources_at_site node20) 0)
 
 (= (construction_status building22 node1) 0)
 
 )

(:goal (and
 (constructed building22 node1)
 )
)
)
