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
     `(org-level-3 ((t (,@headline :height 1))))
     `(org-level-2 ((t (,@headline :height 1.05))))
     `(org-level-1 ((t (,@headline :height 1.1))))
     `(org-document-title ((t (,@headline  :height 1.25 :underline nil))))))
  ;;(set-face-attribute 'org-table nil :inherit 'fixed-pitch) ;Small settings for tables, blocks, etc.
  ;;(set-face-attribute 'org-block nil :inherit 'default :family "Hack")
  )

(use-package org
  :hook
  ((org-mode . efs/org-mode-setup)
  (org-mode . (lambda () (custom-theme-set-faces
   'user
   '(fixed-pitch ((t ( :family "Hack" :height 114))))
   '(variable-pitch ((t (:family "DejaVu Sans" :height 124))))
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
  (setq org-indent-mode nil)		; Disables automatic heading indenting
  )

;; (use-package org-bullets
;;   :after org
;;   :hook (org-mode . org-bullets-mode)
;;   )


(use-package org-modern
  :after org
  :hook ((org-mode-hook . org-modern-mode)
	 (org-agenda-finalize-hook . org-modern-agenda))
  :custom
  (org-modern-star 'replace)
  (org-modern-block-fringe nil))

;; Centered org mode

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 125
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))


;; --------------- ORG-AGENDA -------------

(setq org-agenda-files '("~/Vault/02-Agenda/"))
(setq org-agenda-span 20)

;; Clocking time

(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)


;; --------------- ORG-BABEL -------------

(with-eval-after-load 'org
  ;; Languages
    (org-babel-do-load-languages
     'org-babel-load-languages
     '((emacs-lisp . t)
       (R . t)
       (python . t)))
  (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)) ; Redisplay images when executing code


;; Code block settings

(with-eval-after-load 'org
  (dolist (el '(("r" . "src R :session :results output")
		("rf" . "src R :session :results graphics file :file \"org-images/a.png\"")
		("p" . "src python :session :results output")
		("pf" . "src python :session :results graphics file :file \"org-images/a.png\"")))
    (add-to-list 'org-structure-template-alist el)))


;; This allows eglot to activate in src buffers

(with-eval-after-load 'eglot
  (defun sloth/org-babel-edit-prep (info)
    (setq buffer-file-name (or (alist-get :file (caddr info))
                               "org-src-babel-tmp"))
    (eglot-ensure))

  (advice-add 'org-edit-src-code
              :before (defun sloth/org-edit-src-code/before (&rest args)
			(when-let* ((element (org-element-at-point))
                                    (type (org-element-type element))
                                    (lang (org-element-property :language element))
                                    (mode (org-src-get-lang-mode lang))
                                    ((eglot--lookup-mode mode))
                                    (edit-pre (intern
                                               (format "org-babel-edit-prep:%s" lang))))
                          (if (fboundp edit-pre)
                              (advice-add edit-pre :after #'sloth/org-babel-edit-prep)
                            (fset edit-pre #'sloth/org-babel-edit-prep))))))


;; End of file
(provide 'orgmode-custom)
