(import [numpy :as np]
        [numpy.linalg :as la]
        [numpy.random :as rd])

(defn copula/amh/2 [u v theta]
    (/ (* u v)
       (- 1 (* theta (- 1 u) (- 1 v)))))

(defn copula/amh/N [theta &rest u]
    (defn m1 [x] (- 1 x))
    (/ (* #*u)
       (m1 (* theta
            (reduce (fn [x y] (* x y))(map m1 u))))))

    ; ;;; nonfunctional
    ; #_(defn copula/gaussian [quantile-func u v sigma &optional [samples 1000]]
    ;     (setv A (la.cholesky A))
    ;     (setv Z (rd.multivariate_normal
    ;                 :mu (np.zeros :size (first (getattr sigma shape)))
    ;                 :cov A 
    ;                 :size samples))
    ;     (setv U (np.matmul (. A T) 
    ;                         Z))
    ;     (setv ucols (np.hsplit U)))