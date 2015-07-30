(in-package :retro)

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


(hunchentoot:define-easy-handler (vote :uri "/vote") (name)
  (when (game-stored? name)
    (vote-for (game-from-name name)))
  (hunchentoot:redirect "/retro-games"))

(hunchentoot:define-easy-handler (new-game :uri "/new-game") ()
  (standard-page (:title "Add a new game")
    (:h1 "Add a new game to the chart")
    (:form :action "/game-added" :method "post" :id "addform"
      (:p "What is the name of the game?" (:br)
        (:input :type "text" :name "name" :class "txt"))
      (:p (:input :type "submit" :value "Add" :class "btn")))))

(hunchentoot:define-easy-handler (game-added :uri "/game-added") (name)
  (unless (or (null name) (zerop (length name)))
    (add-game name))
  (hunchentoot:redirect "/retro-games"))


