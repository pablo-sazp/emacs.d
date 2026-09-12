(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/Vault/")
  :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n n" . org-roam-node-find)
	 ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-db-autosync-enable))

;; Show filetags on node find
(setq org-roam-node-display-template
      (concat "${title:*} " (propertize "${tags:20}" 'face 'org-tag)))

;; Node templates
(with-eval-after-load 'org-roam
  (setq org-roam-capture-templates
	'(("d" "default" plain "%?"
	   :target (file+head "01-Notes/${slug}.org" "#+title: ${title}")
	   :unnarrowed t)
	  ("m" "meeting" plain
	   (file "~/.emacs.d/org-templates/meeting.org")
	    :target (file "04-Meetings/%<%Y%m%d>-meeting.org")
	    :jump-to-captured t
	    :unnarrowed t)
	  ("s" "seminar" plain
	   (file "~/.emacs.d/org-templates/seminar.org")
	    :target (file "05-Seminars/%<%Y%m%d-%H>-seminar.org")
	    :jump-to-captured t
	    :unnarrowed t)
	  ("l" "literature" plain
	   (file "~/.emacs.d/org-templates/literature.org")
	   :target (file "06-Literature/${citar-citekey}.org")
	   :jump-to-captured t
	   :unarrowed t))
	))

;; Citar nodes
(use-package citar-org-roam
  :after citar
  :config (citar-org-roam-mode)
  :custom
  (citar-org-roam-capture-template-key "l")
  (citar-notes-paths '("~/Vault/06-Literature/"))
  (citar-file-note-extensions '("org"))
  (citar-org-roam-template-fields
   '((:citar-title "title")
     (:citar-author "author")
     (:citar-date "date")
     (:citar-pages "pages")
     (:citar-type "=type=")
     (:citar-abstract "abstract"))))

(global-set-key (kbd "C-c n b") #'citar-open-notes)

;; (use-package org-roam-bibtex
;;   :after (org-roam citar-org-roam)
;;   :config
;;   (citar-register-notes-source
;;  'orb-citar-source (list :name "Org-Roam Notes"
;;         :category 'org-roam-node
;;         :items #'citar-org-roam--get-candidates
;;         :hasitems #'citar-org-roam-has-notes
;;         :open #'citar-org-roam-open-note
;;         :create #'orb-citar-edit-note
;;         :annotate #'citar-org-roam--annotate))

;;   (setq citar-notes-source 'orb-citar-source))

(provide 'orgroam-custom)
