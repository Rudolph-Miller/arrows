(in-package :cl-user)
(defpackage arrows.backend.fast-io
  (:use :cl :arrows.util :arrows.att :arrows.backend)
  (:import-from :arrows.backend.stream
                :buffer-of)
  (:import-from :arrows.backend.sequence
                :octet-backend)
  (:import-from :babel
                :string-to-octets)
  (:import-from :fast-io
                :with-fast-output
                :fast-write-sequence)
  (:export :fast-io-backend))
(in-package :arrows.backend.fast-io)

(defclass fast-io-backend (octet-backend)
  ())

(defmethod make-backend ((backend (eql :fast-io)) &key &allow-other-keys)
  (make-instance 'fast-io-backend))

(defmethod emit-lambda ((backend fast-io-backend) att)
  (let* ((code (emit-code backend att)))
    (eval
     `(lambda (,(buffer-of backend) ,@(emit-parameters backend))
        ,code))))

