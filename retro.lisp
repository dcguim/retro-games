
(defpackage :retro-game
	    (:use :cl :cl-who :hunchentoot :parenscript))

(in-package :retro-game)

(defclass game ()
  ((name  :reader game-name
  	  :initarg  :name)	  
   (votes :accessor game-votes
   	  :initform 0)))

(defmethod vote-for (user-selected-game)
  (incf (game-votes user-selected-game)))

(defvar *games* '())

(defun game-from-name (name)
  (find name *games* :test #'string-equal
	:key #'game-name))

(defun game-stored? (name)
  (game-from-name name))

(defun print-games ()
  (sort (copy-list *games*) #'> :key #'game-votes))

(defun add-game (name)
  (unless (game-stored? name)
    (push (make-instance 'game :name name) *games*)))

(defmethod print-object ((object game) stream)
  (print-unreadable-object (object stream :type t)
    (with-slots (name votes) object
      (format stream "name: ~s with ~d votes" name votes))))


