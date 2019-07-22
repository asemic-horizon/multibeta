(import [matplotlib.cm :as cm]
        [matplotlib.pyplot :as plt]
        [numpy :as np]
        [surfplot [surface-plot]]
        [multibeta [*]])

(defn test-beta-plot [a1 b1 a2 b2 theta
    &optional [cmap cm.bone] [h 0.01]
              [levels 100]]
    (setv samples (lfor _ (range 1000) 
                    (amh/2beta-sampler a1 b1 a2 b2 theta)))
    (setv fig (surface-plot 
                :points [(list (map first samples))
                         (list (map last samples))]
                :func (fn [x y] 
                  (amh/2beta x y a1 b1 a2 b2 theta))
                :xlims [0 1] :ylims [0 1]
                :h h
                :scatter-alpha 0.4
                :cmap cmap
                :levels levels))
    ((. (get fig.axes 0) set_title)
     f"$\\alpha_1$ = {a1}, $\\alpha_2$ = {a2}, $\\beta_1$ ={b1}, $\\beta_2$ ={b2}, $\\theta$ ={theta}")
    ((. fig savefig ) "surface.png")
    (fig.show)
    fig)

(defn run-beta-copulas [a1 b1 a2 b2 
                ]
    (for [theta (np.linspace -1 1 10)] 
        (test-beta-plot a1 b1 a2 b2 theta)
        (setv _ (input))))

(defn guess-theta [&optional [a1 3] [b1 4][ a2 2] [b2 6][ theta .25] [samples 1000] [Ns 25]]
    (setv samples (lfor _ (range samples) 
                    (amh/2beta-sampler a1 b1 a2 b2 theta)))
    (amh/2beta-likelihood-maximizer samples a1 b1 a2 b2 :Ns Ns))


(defn nbeta-test [&rest xs]
  (setv params [[3 1] [2 4]])
  (amh/nbeta xs params .5)
)