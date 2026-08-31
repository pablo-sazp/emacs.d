;;(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(defun efs/org-mode-setup ()
  (variable-pitch-mode 1)
  (visual-line-mode 1)
  (setq-local line-spacing 3))

(defun custom/org-mode-custom-fonts () ; Fancy text display customization
  (let* ((base-font-color     (face-foreground 'default nil 'default)) ; Fancy text display for headings
	 (headline           `(:inherit variable-pitch :weight bold)))
    (custom-theme-set-faces
     'user
     `(org-level-3 ((t (,@headline :height 1.05))))
     `(org-level-2 ((t (,@headline :height 1.1))))
     `(org-level-1 ((t (,@headline :height 1.25))))
     `(org-document-title ((t (,@headline  :height 1.3 :underline nil))))))
  (set-face-attribute 'org-table nil :inherit 'fixed-pitch) ;Small settings for tables, blocks, etc.
  ;;(set-face-attribute 'org-block nil :inherit 'default :family "Hack")
  )

(use-package org
  :hook
  ((org-mode . efs/org-mode-setup)
  (org-mode . (lambda () (custom-theme-set-faces
   'user
   ;; '(fixed-pitch ((t ( :family "Hack" :height 114))))
   ;; '(variable-pitch ((t (:family "DejaVu Sans" :height 124))))
   '(org-block ((t (:inherit fixed-pitch))))
   '(org-code ((t (:inherit (shadow fixed-pitch)))))
   )))
  )
  :config
  (setq org-ellipsis " ▾")
  (setq org-pretty-entities t)
  (setq org-hide-emphasis-markers t)
  ;; (require 'org-tempo)			; Allows expanding snippets to code blocks
  (setq org-support-shift-select t)
  (setq org-confirm-babel-evaluate nil)
  (setq org-startup-with-inline-images t)
  (custom/org-mode-custom-fonts)
  (setq org-indent-mode nil)	; Disables automatic heading indenting
  (setq org-blank-before-new-entry ; Always insert blank line before headings
      '((heading . t)	   
        (plain-list-item . nil)))
  (setq org-cycle-separator-lines 0)
  (setq org-src-window-setup 'current-window)
  )


(use-package org-modern
  :after org
  :hook ((org-mode-hook . org-modern-mode)
	 (org-agenda-finalize-hook . org-modern-agenda))
  :custom
  (org-modern-star 'replace)
  (org-modern-block-fringe nil))

(use-package org-appear			; Show emphasis markers when hidden
  :hook
  (org-mode . org-appear-mode))

(use-package org-fragtog
  :hook
  (org-mode . org-fragtog-mode))

(with-eval-after-load 'org
  (add-hook 'org-mode-hook (lambda () (org-latex-preview 16))) ; Preview all latex fragments when opening file
  (plist-put org-format-latex-options :scale 1.65)) ; Bigger latex preview


;; Centered org mode

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 120
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(use-package org-download
  :after org
  :custom
  (org-download-image-dir "./.images/")
  (org-download-heading-level nil)
  :bind
  (:map org-mode-map ("C-S-v" . org-download-clipboard)))


;; --------------- ORG-AGENDA -------------

(setq org-agenda-files '("~/Vault/02-Agenda/"
			 "~/Vault/03-Projects/"))
(setq org-agenda-span 20)

;; Clocking time
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)
(setq org-duration-format (quote h:mm))	; Changes time format to only show hours

;; Org templates
(with-eval-after-load 'org
  (setq org-capture-templates
	'(("e" "Emacs config changes" entry
	   (file "~/Vault/02-Agenda/emacs-todo.org")
	   "* TODO %?"))))

(global-set-key (kbd "<f9>") 'org-clock-goto) ; Go to clocked item
(global-set-key (kbd "C-<f9>") 'org-clock-in)

;; Refiling towards all project files
(defun my/org-project-files ()
  (file-expand-wildcards "~/Vault/03-Projects/*.org"))

(setq org-refile-targets
      '((nil :maxlevel . 3)
	;;(org-agenda-files :maxlevel . 1)
        (my/org-project-files :maxlevel . 2)))

(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)

;; Open the corresponding file by current projectile project
(use-package projectile
  :config
  (defun my/projectile-open-associated-note ()
  "Open the Org note corresponding to the current Projectile project."
  (interactive)
  (let* ((project-name (projectile-project-name))
         (note-file (expand-file-name (concat project-name ".org") "~/Vault/03-Projects/")))
    (if (file-exists-p note-file)
        (find-file note-file)
      ;; If the note doesn't exist, offer to create it
      (when (y-or-n-p (format "Note '%s.org' doesn't exist. Create it? " project-name))
        (find-file note-file)))))
  ;; Bind it to Projectile's map (e.g., C-c p n)
  ;; (keymap-set projectile-command-map "n" #'my/projectile-open-associated-note)
  ;; (transient-append-suffix 'projectile-dispatch "f" ; Shows it on the transient menu
  ;;   '("n" "Project Note" my/projectile-open-associated-note))
  :bind
  ("C-c P" . my/projectile-open-associated-note))

;; --------------- ORG-BABEL -------------

(with-eval-after-load 'org
  ;; Languages
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)
     (R . t)
     (python . t))))

(add-hook 'org-babel-after-execute-hook (lambda () 
					  (org-redisplay-inline-images))) ; Redisplay images when executing code

;; Code block settings

(with-eval-after-load 'org
  (dolist (el '(("r" . "src R :session :results output :exports both")
		("rf" . "src R :session :results graphics file :dir .images/ :file 0.png :exports both")
		("p" . "src python :session :results output :exports both")
		("pf" . "src python :session :results graphics file :dir .images/ :file 0.png :exports both")
		("b" . "src bash :results output :eval query :exports both")))
    (add-to-list 'org-structure-template-alist el)))

(setq org-babel-default-header-args:R	; This code evaluate for every R src block
      '((:prologue . "options(readxl.show_progress=FALSE)"))) ; No progress bar when importing files, better output format


;; This allows lsp-mode completion in src python buffers
(defun org-babel-edit-prep:python (babel-info)
  (setq-local buffer-file-name (->> babel-info caddr (alist-get :tangle)))
  (lsp))

;; End of file
(provide 'orgmode-custom)
