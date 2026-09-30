;; General settings for ess (mainly R)

(use-package ess-r-mode
  :ensure nil
  :custom
  (ess-ask-for-ess-directory nil)
  (inferior-R-args "--no-save")
  (ess-indent-with-fancy-comments nil)	; Do not indent # comments
  :config
  (setq ess-set-style 'RStudio)
  (global-set-key (kbd "<f12>") 'ess-switch-to-inferior-or-script-buffer)
  (setq ess-R-font-lock-keywords
	(quote
	 ((ess-R-fl-keyword:modifiers . t)
          (ess-R-fl-keyword:fun-defs . t)
          (ess-R-fl-keyword:fun-defs2 . t)
          (ess-R-fl-keyword:keywords . t)
          (ess-R-fl-keyword:assign-ops . t)
          (ess-R-fl-keyword:%op% . t)
	  (ess-R-fl-keyword:constants . t)
          (ess-fl-keyword:fun-calls . t)
          (ess-fl-keyword:numbers . t)
          (ess-fl-keyword:operators . t)
          (ess-fl-keyword:delimiters)
          (ess-fl-keyword:=)
          (ess-fl-keyword::= . t)
          (ess-R-fl-keyword:F&T)
          (ess-R-fl-keyword:%op%))))
    (setq inferior-ess-r-font-lock-keywords
	(quote
	 ((ess-S-fl-keyword:prompt . t)
          (ess-R-fl-keyword:messages . t)
          (ess-R-fl-keyword:modifiers . t)
          (ess-R-fl-keyword:fun-defs . t)
          (ess-R-fl-keyword:fun-defs2 . t)
          (ess-R-fl-keyword:keywords . t)
          (ess-R-fl-keyword:assign-ops . t)
	  (ess-R-fl-keyword:%op% . t)
          (ess-R-fl-keyword:constants . t)
          (ess-fl-keyword:matrix-labels)
          (ess-fl-keyword:fun-calls . t)
          (ess-fl-keyword:numbers)
          (ess-fl-keyword:operators . t)
          (ess-fl-keyword:delimiters)
          (ess-fl-keyword:=)
          (ess-fl-keyword::= . t)
          (ess-R-fl-keyword:F&T)))))

(use-package ess-view-data
  :bind (:map ess-r-mode-map
	      ("C-c v" . ess-view-data-print))
  :config
  (add-to-list 'display-buffer-alist	; Nicer buffer display
	       '("\\*R Data View.*\\*"
		 (display-buffer-reuse-window display-buffer-pop-up-window)
		 (reusable-frames . nil)))
  )

(provide 'ess-settings)
