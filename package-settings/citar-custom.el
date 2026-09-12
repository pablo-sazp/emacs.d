;; Settings configuring citar for bibliography management
;; Symbol definition using nerd-icons
(defun my/citar-icon-setup ()
  (defvar citar-indicator-links-icons
    (citar-indicator-create
     :symbol (nerd-icons-octicon
	      "nf-oct-link"
	      :face 'nerd-icons-orange
	      :height 0.8
	      :width 0.5
	      ;; :v-adjust -0.1
	      )
     :function #'citar-has-links
     :padding " "
     :tag "has:links"))
  (defvar citar-indicator-notes-icons
    (citar-indicator-create
     :symbol (nerd-icons-faicon
              "nf-fa-note_sticky"
              :face 'nerd-icons-blue
	      :height 0.8
	      :width 0.5
              ;; :v-adjust -0.3
	      )
     :function #'citar-has-notes
     :padding " "
     :tag "has:notes"))  
  (defvar citar-indicator-cited-icons
    (citar-indicator-create
     :symbol (nerd-icons-faicon
              "nf-fa-chevron_circle_right"
              :face 'nerd-icons-green
	      :height 0.8
	      :width 0.5
              ;; :v-adjust -0.1
	      )
     :function #'citar-is-cited
     :padding " "
     :tag "is:cited")))

(use-package citar
  :after org
  :custom
  (citar-bibliography '("~/.emacs.d/full_library.bib")) ; Automatically exported from zotero
  (org-cite-insert-processor 'citar)
  (org-cite-follow-processor 'citar)
  (org-cite-activate-processor 'citar)
  :hook
  (LaTeX-mode . citar-capf-setup)
  (org-mode . citar-capf-setup)
  :bind
  (:map org-mode-map :package org ("C-c b" . #'org-cite-insert))
  :config
  (my/citar-icon-setup)
  (setq citar-templates
	'((main . "${author editor:30%sn}     ${date year issued:4}     ${title:48}")
          (suffix . "          ${=key= id:15}    ${=type=:12}    ${tags keywords:20}")
          (preview . "${author editor:%etal} (${year issued date}) ${title}, ${journal journaltitle publisher container-title collection-title}.\n")
          (note . "Notes on ${author editor:%etal}, ${title}")))
  (setq citar-indicators
	(list
	 ;;citar-indicator-files
	 citar-indicator-notes-icons
	 citar-indicator-cited-icons
	 )))

(with-eval-after-load 'AUCTeX
  (keymap-set LaTeX-mode-map "C-c b" #'citar-insert-citation))

(use-package citar-embark
  :after (citar embark)
  :no-require
  :config (citar-embark-mode))

;; End of file
(provide 'citar-custom)
