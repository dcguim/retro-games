(in-package :cl-user)

(defpackage :retro
  (:use :cl)
  (:export #:vote-for
	   #:*games*
	   #:game-from-name
	   #:game-stored?
	   #:print-games
	   #:add-game
	   #:print-object))
