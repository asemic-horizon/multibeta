"Multibeta distributions

    Provides high-dimensional distributions with beta marginals
    using the Ali-Mikhail-Haq copula.

    Joint dependence is driven by a single parameter theta 
    ranging from -1 to 1, where 0 is statistical independence.
"
(import 
        [scipy.stats :as stats]
        [scipy.optimize [brute]]
        [sampler [rejection-sampler/2]]
        [copula [*]])

(defn amh/2beta [x y a1 b1 a2 b2 theta]
    "Bivariate amh/beta pdf.
    
    Parameters
    --------- 
    x, y: coordinates at which the amh/2beta pdf
          is evaluated
    a1, b1: parameters for the first marginal beta
    a2, b2: parameters for the second marginal beta
    theta: Joint dependence parameter for the AMH copula  
    "
    (copula/amh/2
        :u (stats.beta.pdf x a1 b1)
        :v (stats.beta.pdf y a2 b2)
        :theta theta))

(defn amh/nbeta [xs params theta]
    "Multivariate amh/beta pdf.
    
    Parameters
    --------- 
    xs: vector at which the amh/nbeta pdf is evaluated.
    params: vector of a,b pairs for the marginal betas
    theta: Joint dependence parameter for the AMH copula  
    "
    (copula/amh/N 
        theta
         #*(lfor [x [a b]] (zip xs params)
            (stats.beta.pdf x a b))))

(defn amh/2beta-sampler [a1 b1 a2 b2 theta]
    "Obtains one sample from an amh/2beta distribution

    Relies on sampler.rejection-sampler/2 for rejection sampling
    "
    (rejection-sampler/2 
        :pdf (fn [x y] 
            (amh/2beta x y a1 b1 a2 b2 theta))
        :low 0
        :high 1))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defmacro safe-log [x]
    `(if (pos? ~x) (np.log ~x) -1e9))

(defn amh/2beta-likelihood [points a1 b1 a2 b2 theta]
    (np.sum (lfor [x y] points 
                (- (safe-log (amh/2beta x y a1 b1 a2 b2 theta))))))

(defn amh/2beta-likelihood-maximizer [points a1 b1 a2 b2 
                                    &optional [Ns 20] [verbose True]]
    "EXPERIMENTAL (not working all the time) maximum likelihood
                  estimation for the amh/2beta"
    (defn internal-likelihood [theta]
        (amh/2beta-likelihood points a1 b1 a2 b2 theta))
    (setv res (brute internal-likelihood [(, -1 1)]))
    (if verbose (print res))
    res)