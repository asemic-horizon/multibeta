(import [matplotlib [pyplot :as plt]]
            [matplotlib.cm :as cm]
            [math [sqrt floor ceil]]
            [numpy :as np]
            [numpy [concatenate meshgrid arange c_  min max]])

(defmacro slice [xs axis i]  `(.take ~xs ~i :axis ~axis ))  ;
    
(defn surface-plot 
      [points func xlims ylims h 
       &optional 
        [cmap cm.coolwarm] 
        [scatter-alpha 0.8]
        [levels 50]]
  (setv [fig ax] (plt.subplots :figsize (, 10 10)))
  (setv [xmin xmax] xlims) 
  (setv [ymin ymax] ylims)
  (setv [xx yy] (meshgrid
                  (arange xmin (+ h xmax) h)
                  (arange ymin (+ h ymax) h)))
  (setv Z (func #*(get c_ [((. xx ravel)) 
                            ((. yy ravel))])))
  (setv cf(ax.contourf xx yy 
                      ((. Z reshape) (getattr yy "shape"))
                      :cmap cmap 
                      :alpha .9
                      :levels levels))


  (setv sc (ax.scatter (first points) (last points)
                      :c "k"
                      :cmap cmap
                      :alpha scatter-alpha
                      :s 25
                      :edgecolors "w"))
  (ax.set_xlim xmin xmax) 
  (ax.set_ylim ymin ymax)

  (plt.colorbar cf :ax ax)
 fig)



(defn test-surface-plot []

    (setv fig (surface-plot :points [(np.random.exponential :scale 1/2 :size 1500)
                                     (np.random.exponential :scale 1/3 :size 1500)]
                            :func (fn [x y] 
                              (* (* 2 (np.exp (- (* 2 x))))
                                 (* 3 (np.exp (- (* 3 y))))))
                            :xlims [0 1.5] :ylims [0 1.5]
                            :h 0.1
                            :scatter-alpha 0.4
                            :cmap cm.cubehelix))
    ((. fig savefig ) "surface.png")) 
