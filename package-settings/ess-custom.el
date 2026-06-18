;; Buffer organization like RStudio
(with-eval-after-load 'ess-site
  (add-to-list 'display-buffer-alist
	       `("^\\*R Dired\\*"
		  (display-buffer-reuse-window display-buffer-in-side-window)
		  (side . right)
		  (slot . -1)
		  (window-width . 0.33)
		  (reusable-frames . nil)))
  (add-to-list 'display-buffer-alist
	       `("^\\*R\\(?: ?:[^*]+\\)?\\*$"
		  (display-buffer-reuse-window display-buffer-at-bottom)
		  (window-height . 0.3)
		  (reusable-frames . nil)))
  (add-to-list 'display-buffer-alist
	       `("^\\*Help"
		  (display-buffer-reuse-window display-buffer-in-side-window)
		  (side . right)
		  (slot . 1)
		  (window-width . 0.33)
		  (reusable-frames . nil))))

(setq ess-set-style 'RStudio)

(provide 'ess-custom)
