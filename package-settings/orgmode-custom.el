(provide 'orgmode-custom)

(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1)
  (setq-local line-spacing 2))

;;(require 'color)
;; (let* ((variable-tuple
;;         (cond ((x-list-fonts "Noto Sans")         '(:font "Noto Sans"))
;; 	      ((x-list-fonts "DejaVu Sans")         '(:font "DejaVu Sans"))
;;                 ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
;;                 ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
;;                 ((x-list-fonts "Verdana")         '(:font "Verdana"))
;;                 ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
;;                 (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
;;          ;; (base-font-color     (face-foreground 'default nil 'default))
;;          ;; (headline           `(:inherit default :weight bold :foreground ,base-font-color)))

;;   ;; Theme-derived colors
;;        (base-font-color (face-foreground 'default nil 'default))
;;        (blue            (face-foreground 'font-lock-keyword-face))
;;        (cyan            (face-foreground 'font-lock-builtin-face))
;;        (green           (face-foreground 'font-lock-string-face))

;;   ;; subtle lower-level color
;;        (subtle-color
;;         (color-lighten-name base-font-color -15))

;;    ;; generic headline template
;;        (headline
;;         `(:inherit default
;;                    :weight semi-bold
;;                    :foreground ,base-font-color)))

;;     (custom-theme-set-faces
;;      'user
;;      `(org-level-8 ((t (,@headline ,@variable-tuple))))
;;      `(org-level-7 ((t (,@headline ,@variable-tuple))))
;;      `(org-level-6 ((t (,@headline ,@variable-tuple))))
;;      `(org-level-5 ((t (,@headline ,@variable-tuple))))
;;      `(org-level-4 ((t (,@headline ,@variable-tuple))))
;;      `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.05))))
;;      `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.1))))
;;      `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.25))))
;;      `(org-document-title ((t (,@headline ,@variable-tuple :height 1.5 :underline nil))))))

(use-package org
  :hook
  ((org-mode . efs/org-mode-setup)
  (org-mode . (lambda () (custom-theme-set-faces
   'user
   '(variable-pitch ((t (:family "Noto Sans" :height 125))))
   '(fixed-pitch ((t ( :family "JetBrains Mono" :height 125)))))))
  )
  :config
  (setq org-ellipsis " ▾")
  ;;(efs/org-font-setup)
  (setq org-hide-emphasis-markers t)
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
(setq org-agenda-files '("~/Vault/02-Agenda/agenda.org"))
(setq org-agenda-span 20)
