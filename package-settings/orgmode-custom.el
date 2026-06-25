;;(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1)
  (setq-local line-spacing 2))

(defun custom/org-mode-custom-fonts () ; Fancy text display customization
  (let* ((base-font-color     (face-foreground 'default nil 'default)) ; Fancy text display for headings
	 (headline           `(:inherit variable-pitch :weight bold)))
    (custom-theme-set-faces
     'user
     `(org-level-3 ((t (,@headline :height 1))))
     `(org-level-2 ((t (,@headline :height 1.05))))
     `(org-level-1 ((t (,@headline :height 1.1))))
     `(org-document-title ((t (,@headline  :height 1.25 :underline nil))))))
  (set-face-attribute 'org-table nil :inherit 'fixed-pitch) ;Small settings for tables, blocks, etc.
  (set-face-attribute 'org-block nil :inherit 'default))

(use-package org
  :hook
  ((org-mode . efs/org-mode-setup)
  (org-mode . (lambda () (custom-theme-set-faces
   'user
   '(fixed-pitch ((t ( :family "Hack" :height 124))))
   '(variable-pitch ((t (:family "DejaVu Sans" :height 124)))))))
  )
  :config
  (setq org-ellipsis " ▾")
  ;;(efs/org-font-setup)
  (setq org-hide-emphasis-markers t)
  ;; (require 'org-tempo)			; Allows expanding snippets to code blocks
  (setq org-support-shift-select t)
  (setq org-confirm-babel-evaluate nil)
  (setq org-startup-with-inline-images t)
  (custom/org-mode-custom-fonts)  
  )

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  )


;; Centered org mode

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))


;; --------------- ORG-AGENDA -------------

(setq org-agenda-files '("~/Vault/02-Agenda/"))
(setq org-agenda-span 20)

(provide 'orgmode-custom)


;; Clocking time

(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)


;; --------------- ORG-BABEL -------------

(with-eval-after-load 'org
  ;; Languages
    (org-babel-do-load-languages
     'org-babel-load-languages
     '((R . t)))
  (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)) ; Redisplay images when executing code


;; Code block settings

(with-eval-after-load 'org
  (dolist (el '(("r" . "src R :session :results output")
		("rf" . "src R :session :results graphics file :file \"org-images/a.png\"")
		("p" . "src python :session")
		("pf" . "src python :session :results graphics file :file \"org-images/a.png\"")))
    (add-to-list 'org-structure-template-alist el)))
