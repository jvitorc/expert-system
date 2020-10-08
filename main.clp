
;;;======================================================
;;;     Joao Vitor Cardoso <2020>
;;;
;;;     Expert system to suggest a programming language
;;;     for your project.
;;;
;;;     To execute, merely load, reset and run.
;;;======================================================


;;****************
;;* DEFFUNCTIONS *
;;****************

(deffunction ask-question (?question $?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) 
       then (bind ?answer (lowcase ?answer)))
   (while (not (member ?answer ?allowed-values)) do
      (printout t ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) 
          then (bind ?answer (lowcase ?answer))))
   ?answer)

(deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n))
   (if (or (eq ?response yes) (eq ?response y))
       then yes 
       else no))

;;;***************
;;;* QUERY RULES *
;;;***************

(defrule determine-if-there-are-complex-calculations ""
   (not (complex-calculations ?))
   (not (suggest ?))
   =>
   (assert (complex-calculations (yes-or-no-p "Does the project involve complex calculations? (yes/no)? "))))

(defrule determine-modeling-simulation-project ""
    (complex-calculations yes)
    (not (suggest ?))
    =>
   (assert (modeling-and-simulation (yes-or-no-p "Will you do simulation of a physical systems? (yes/no)? "))))

(defrule determine-numerical-calculation-project ""
    (modeling-and-simulation no)
    (not (suggest ?))
    =>
   (assert (numerical-calculation-algorithms (yes-or-no-p "Will you create numerical calculation algorithms? (yes/no)? "))))

(defrule  determine-machine-learning-project ""
    (or (complex-calculations no) (numerical-calculation-algorithms no))
    (not (suggest ?))
    =>
   (assert (machine-learning (yes-or-no-p "Does your project involve data management or machine learning?? (yes/no)? "))))


(defrule  determine-multiplatform-project ""
    (machine-learning no)
    (complex-calculations no)
    (not (suggest ?))
    =>
   (assert (multiplatform (yes-or-no-p "Is your application multiplatform? (yes/no)? "))))

(defrule  determine-android-project ""
    (multiplatform no)
    (not (suggest ?))
    =>
   (assert (android (yes-or-no-p "Is your application for android? (yes/no)? "))))

(defrule  determine-ios-project ""
    (android no)
    (not (suggest ?))
    =>
   (assert (ios (yes-or-no-p "Is your application for iOS? (yes/no)? "))))


;;;****************
;;;* SUGGEST RULES *
;;;****************

(defrule modelica-language ""
   (modeling-and-simulation yes)
   (not (suggest ?))
   =>
   (assert (suggest "Modelica")))

(defrule octave-language ""
   (numerical-calculation-algorithms yes)
   (not (suggest ?))
   =>
   (assert (suggest "Octave")))

(defrule python-language ""
    (machine-learning yes)
    (not (suggest ?))
    =>
    (assert (suggest "Python")))

(defrule cpp-language ""
    (complex-calculations yes)
    (machine-learning no)
    (not (suggest ?))
    =>
    (assert (suggest "C++")))

(defrule javascript-language ""
    (multiplatform yes)
    (not (suggest ?))
    =>
    (assert (suggest "JavaScript")))


(defrule kotlin-language ""
    (android yes)
    (not (suggest ?))
    =>
    (assert (suggest "Kotlin")))

(defrule swift-language ""
    (ios yes)
    (not (suggest ?))
    =>
    (assert (suggest "Swift")))

(defrule java-language ""
    (ios no)
    (not (suggest ?))
    =>
    (assert (suggest "Java")))

;;;********************************
;;;* STARTUP AND CONCLUSION RULES *
;;;********************************

(defrule system-banner ""
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "Expert System")
  (printout t crlf crlf))

(defrule print-suggest ""
  (declare (salience 10))
  (suggest ?item)
  =>
  (printout t crlf crlf)
  (printout t "Suggested language:")
  (printout t crlf crlf)
  (format t " %s%n%n%n" ?item))