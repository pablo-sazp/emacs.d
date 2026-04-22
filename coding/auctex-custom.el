;; Here go all auctex + latex writing settings
(provide 'auctex-custom)

;;AucTEX
(use-package auctex
  :hook
  ((LaTeX-mode . turn-on-reftex)	;Activate reftex
   (LaTeX-mode . (lambda () (company-mode -1))) ;Disable suggestions
   (LaTeX-mode . (lambda () (setq sentence-end-double-space nil)))	;Jump to points with M-e
   )
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq TeX-electric-math '("$" . "$"))
  (setq reftex-cite-format		; Reftex custom cite comands
	'((?\C-m . "\\parencite{%l}")
          (?t    . "\\textcite{%l}")))
  (setq TeX-save-query nil))		;Do not ask for saving - always save

(setq-default TeX-master nil)
(setq LaTeX-command-style '(("" "%(PDF)%(latex) -synctex=1 -shell-escape %S%(PDFout)")))
;; (setq-default TeX-engine 'pdftex)


;; Other related packages
(use-package latex-preview-pane
  :after auctex
  :config (latex-preview-pane-enable)
  ;; :bind (:map LaTeX-mode-map
  ;; 	      ("M-p" . latex-preview-pane-mode))
  )

