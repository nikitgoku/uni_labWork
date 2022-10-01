(define (problem kights-tour-problem-8x8)
    (:domain kt_domain)

    (:objects
        A1 A2 A3 A5 A5 A6 A7 A8
        B1 B2 B3 B4 B5 B6 B7 B8
        ...
        H1 H2 H3 H4 H5 H6 H7 H8
    )

    (:init
        ; The Knight's starting squre is arbitrary; here, we have chosen
        ; the upper right corner
        (at A8)
        (visited A8)

        ; We'll have list of valid moves
        (valid_move A8 B6)
        (valid_move B6 A8)
        (valid_move A8 C7)
        (valid_move C7 A8)
        (valid_move B8 A6)
        (valid_move A6 B8)
        (valid_move B8 C6)
        ...
    )

    (goal (and (visited A1)
               (visited A2)
               (visited A3)
               ...
               (visited  H8)   
            )
    )

)