"Rejection samplers

Implements:

    rejection-sampler/1, rejection-sampler/2, rejection-sampler/N"
(import [numpy :as np])


(defn rejection-sampler/1 [pdf low high
                         &optional [dist-args {}]]
    "One-dimensional rejection sampler
    
    Parameters
    ----------
    pdf : probability density function
    low, high: endpoints of distribution support
    dist-args (optional): arguments to be passed to the pdf
    "
    (setv accepted False)
    (while (not accepted)
        (setv q-sample (np.random.uniform low high))
        (setv p-sample (np.random.uniform 0 1))
        (setv accepted (< p-sample  (pdf q-sample #**dist-args))))
    q-sample)

(defn rejection-sampler/2 [pdf low high
                         &optional [dist-args {}]]
    "Two-dimensional rejection sampler
    (meant for marginals with same support)
    Parameters
    ----------
    
    pdf: bivariate probability density function
    low, high: endpoints of distribution support
    dist-args (optional): arguments to be passed to the pdf"

    (setv accepted False)
    (while (not accepted)
        (setv q-sample/x (np.random.uniform low high))
        (setv q-sample/y (np.random.uniform low high))
        (setv p-sample (np.random.uniform 0 1))
        (setv prob (pdf q-sample/x q-sample/y #**dist-args))
        (setv accepted (<  p-sample prob)))
    [q-sample/x q-sample/y])

(defn rejection-sampler/N [pdf lows highs &optional [dist-args {}]]
    "N-dimensional rejection sampler
    
    Parameters
    ----------
    
    pdf: N-variate probability density function
    low: lower ends of marginal distribution supports
    high: higher ends of marginal distribution supports
    dist-args (optional): arguments to be passed to the pdf"
    (setv accepted False)
    (while (not accepted)
        (setv q-samples (lfor [lo hi] (zip lows highs)
                         (np.random.uniform lo hi)))
        (setv p-sample   (np.random.uniform 0 1))
        (setv prob (pdf q-samples #**dist-args))
        (setv accepted (< p-sample prob))))