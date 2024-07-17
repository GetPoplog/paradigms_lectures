
(define for-each
    (lambda (proc ls)
        (if (not (null? ls))
            (begin
                (proc (car ls))
                (for-each (proc (cdr ls)))))))


(define map
    (lambda (proc ls)
        (if (null? ls) '()
            (cons (proc (car ls)) (map proc (cdr ls))))))


(define error
    (lambda args
        (display "Error:")
        (for-each (lambda (value) (display " ") (display value)) args)
        (newline)
        (reset)
))
