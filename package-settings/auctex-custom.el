;; Here go all auctex + latex writing settings

;;AucTEX
(use-package auctex
  :hook
  ((LaTeX-mode . turn-on-reftex)	;Activate reftex
   (LaTeX-mode . (lambda ()
		   (company-mode -1) ;Disable suggestions
		   (setq-local sentence-end-double-space nil)	;Jump to points with M-e
		   (variable-pitch-mode)
		   (visual-line-mode)
		   (setq-local line-spacing 0.05))))
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq TeX-electric-math '("$" . "$"))
  (setq TeX-electric-sub-and-superscript t) ;Auto brackets in math mode
  ;; (setq reftex-cite-format		; Reftex custom cite comands
  ;; 	'((?\C-m . "\\parencite{%l}")
  ;;         (?t    . "\\textcite{%l}")))
  (setq TeX-save-query nil)		;Do not ask for saving - always save
  )
  
(setq-default TeX-master nil)
(setq LaTeX-command-style '(("" "%(PDF)%(latex) -synctex=1 -shell-escape %S%(PDFout)")))
;; (setq-default TeX-engine 'pdftex)


;; Other related packages
;; (use-package latex-preview-pane
;;   :after auctex
;;   :config (latex-preview-pane-enable)
;;   ;; :bind (:map LaTeX-mode-map
;;   ;; 	      ("M-p" . latex-preview-pane-mode))
;;   )


;; Custom functions
(defun my/text-parreference-TeX (reftype)
  "Inserts a reference of the type (REFTYPE #ref)"
  (interactive "sInsert text: ")
  (insert (format "\\textbf{(%s " reftype))
  (reftex-reference)
  (insert ")}"))

(defun my/text-reference-TeX (reftype)
  "Inserts a reference of the type (REFTYPE #ref)"
  (interactive "sInsert text: ")
  (insert (format "\\textbf{%s " reftype))
  (reftex-reference)
  (insert "}"))

(add-hook 'LaTeX-mode-hook
	  (lambda () 
	    (define-key LaTeX-mode-map (kbd "C-c r") 'my/text-parreference-TeX)
	    (define-key LaTeX-mode-map (kbd "C-c M-r") 'my/text-reference-TeX))
	  )

(provide 'auctex-custom)
