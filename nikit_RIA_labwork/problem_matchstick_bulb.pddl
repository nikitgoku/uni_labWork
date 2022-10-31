(define (problem mendFUSE) 
    (:domain matchcellar)
    (:objects   
        match1 match2 - match
        fuse1 fuse2 - fuse
    )

    (:init
        ;todo: put the initial state's facts and numeric values here
        (unused match1)
        (unused match2)
        (handsfree)
    )

    (:goal 
        (and
            ;todo: put the goal condition here
            (mended fuse1)
            (mended fuse2)
        )
    )

    ;un-comment the following line if metric is needed
    ;(:metric minimize (???))
)
