(in-package :cl-user)

(defpackage :retro-asd
  (:use :cl :asdf))

(in-package :retro-asd)

(defsystem :retro
  :description "Simple web app for game voting"
  :serial t
  :components ((:file "packages")
	       (:file "retro-game")
	       (:file "handlers"))
  :depends-on (:cl-who :hunchentoot :parenscript))
