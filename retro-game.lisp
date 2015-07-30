(in-package :retro)

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

(defun games ()
  (sort (copy-list *games*) #'> :key #'game-votes))

(defun add-game (name)
  (unless (game-stored? name)
    (push (make-instance 'game :name name) *games*)))

(defmethod print-object ((object game) stream)
  (print-unreadable-object (object stream :type t)
    (with-slots (name votes) object
      (format stream "name: ~s with ~d votes" name votes))))

(defmacro standard-page ((&key title) &body body) `(cl-who:with-html-output-to-string
     (*standard-output* nil :prologue t :indent t)
       (:html :lang "en"
         (:head
           (:meta :charset "utf-8")
           (:title ,title)
           (:link :type "text/css"
                  :rel "stylesheet"
                  :href "/retro.css"))
(:body
(:div :id "header" ; Retro games header
              (:img :src "/Commodore64.jpg"
                    :alt "Commodore 64"
                    :class "logo")
              (:span :class "strapline"
                     "Vote on your favourite Retro Game"))
           ,@body))))


(defun start-server (port)
	 (hunchentoot:start (make-instance hunchentoot::'easy-acceptor :port port)))

 (hunchentoot:define-easy-handler (retro-games :uri "/retro-games") ()
	  (standard-page
	      (:title "Top Retro Games")
	    (:h1 "Vote on your all time favourite retro games!")
	    (:p "Missing a game? Make it available for votes "
		(:a :href "new-game" "here"))
	    (:h2 "Current stand")
	    (:div :id "chart" 
		  (:ol
		   (dolist (game (games))
		     (cl-who:htm
		      (:li (:a :href (format nil "vote?name=~a"
					     (hunchentoot:url-encode (game-name game))) "Vote!")
			   (cl-who:fmt "~A with ~d votes" (cl-who:escape-string (game-name game))
				       (game-votes game)))))))))
