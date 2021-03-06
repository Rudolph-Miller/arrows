#|
This file is a part of arrows project.
Copyright (c) 2014 κeen
|#

(in-package :cl-user)
(defpackage arrows.parse-test
  (:use :cl
        :arrows.att
        :arrows.parse
        :arrows.util
        :cl-test-more))
(in-package :arrows.parse-test)

(plan nil)
(diag "test parse")

(is (parse-template-string "aaa")
    (att-progn (att-output (att-string "aaa")))
    "simple text"
    :test #'att-equal)

(is (parse-template-string "{{var sym}}")
    (att-progn (att-output (att-variable 'sym)))
    "var"
    :test #'att-equal)

(is (parse-template-string "{{if cond}}aaa{{endif}}")
    (att-progn (att-if (att-variable 'cond)
                       (att-progn (att-output (att-string "aaa")))
                       (att-nil)))
    "if"
    :test #'att-equal)

(is (parse-template-string "{{if cond}}aaa{{else}}bbb{{endif}}")
    (att-progn (att-if (att-variable 'cond)
                       (att-progn (att-output (att-string "aaa")))
                       (att-progn (att-output (att-string "bbb")))))
    "if else"
    :test #'att-equal)

(is (parse-template-string "{{repeat 10}}<li>item</li>{{endrepeat}}")
    (att-progn (att-loop (att-constant '(1 2 3 4 5 6 7 8 9 10))
                         (att-progn (att-output (att-string "<li>item</li>")))
                         (att-gensym "repeatvar")))
    "repeat"
    :test #'att-equal)

(is (parse-template-string "{{repeat 10 as i}}<li>item{{var i}}</li>{{endrepeat}}")
    (att-progn (att-loop (att-constant '(1 2 3 4 5 6 7 8 9 10))
                         (att-progn (att-output (att-string "<li>item"))
                                    (att-output (att-variable 'i))
                                    (att-output (att-string "</li>")))
                         (att-variable 'i)))
    "repeat with index"
    :test #'att-equal)

(is (parse-template-string "{{loop seq as i}}<li>item{{var i}}</li>{{endloop}}")
    (att-progn (att-loop (att-variable 'seq)
                         (att-progn (att-output (att-string "<li>item"))
                                    (att-output (att-variable 'i))
                                    (att-output (att-string "</li>")))
                         (att-variable 'i)))
    "loop"
    :test #'att-equal)

(is (parse-template-string "the content of foo is {{insert foo}}")
    (att-progn (att-output (att-string "the content of foo is "))
               (att-output (att-string "{{repeat 2 as i}}bar{{endrepeat}}")))
    "insert"
    :test #'att-equal)

(is (parse-template-string "the content of foo is {{include foo}}")
    (att-progn (att-output (att-string "the content of foo is "))
               (att-progn (att-loop
                           (att-constant '(1 2))
                           (att-progn (att-output (att-string "bar")))
                           (att-variable 'i))))
    "include"
    :test #'att-equal)
(finalize)

