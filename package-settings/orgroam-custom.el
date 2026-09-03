(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/Vault/01-Notes/")
  :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n n" . org-roam-node-find)
	 ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-setup))

;; Show filetags on node find
(setq org-roam-node-display-template
      (concat "${title:*} " (propertize "${tags:20}" 'face 'org-tag)))

;; Node templates
(with-eval-after-load 'org-roam
  (setq org-roam-capture-templates
	'(("d" "default" plain "%?"
	   :target (file+head "${slug}.org" "#+title: ${title}")
	   :unnarrowed t)
	  ("s" "seminar" plain (file "~/.emacs.d/org-templates/seminar.org")
	    :target (file "Seminars/%<%Y%m%d-%H>.org")
	    :jump-to-captured t
	    :unnarrowed t)
	  ("m" "meeting" plain (file "~/.emacs.d/org-templates/meeting.org")
	    :target (file "Meetings/%<%Y%m%d>.org")
	    :jump-to-captured t
	    :unnarrowed t))
	))

(provide 'orgroam-custom)
