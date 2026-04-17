;;All automatic settings go here
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)
					

;;Packages
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;;Package management Install packages if not installed
(require 'use-package)
(setq use-package-always-ensure t)

;;Theme
(defun set-emacs-frames (variant)
  (dolist (frame (frame-list))
    (let* ((window-id (frame-parameter frame 'outer-window-id))
	   (id (string-to-number window-id))
	   (cmd (format "xprop -id 0x%x -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT \"%s\""
			id variant)))
      (call-process-shell-command cmd))))

(defun set-emacs-theme-light ()
  (interactive)
  (load-theme 'ef-arbutus t)
  (set-emacs-frames "light"))

(defun set-emacs-theme-dark ()
  (interactive)
  (load-theme 'base16-material-darker t)
  (load-file "~/.emacs.d/themes/material-darker-custom.el")
  (set-emacs-frames "dark"))

(if (window-system)
    (set-emacs-theme-dark))

;;CUA mode
(cua-mode t)

;; Ivy
(use-package ivy
  :config
  (ivy-mode 1))

;; Marginalia - annotations in the minibuffer
(use-package marginalia
  :config
  (marginalia-mode))

;; Autocomplete
(use-package company)
(add-hook 'after-init-hook 'global-company-mode)

;; Swiper
(use-package swiper)
(global-set-key (kbd "M-s") 'swiper)

;;Doom modeline
(use-package nerd-icons)
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom (doom-modeline-major-mode-icon t)
  (doom-modeline-vcs-icon t)
  (doom-modeline-vcs-display-function #'doom-modeline-vcs-name)
  )

;;Visual and other stuff
(setq inhibit-startup-message t)
(desktop-save-mode 1) ;save workspace
(tool-bar-mode -1) ;remove toolbar
(display-line-numbers-mode 1)
(scroll-bar-mode -1)

;;Autosaves on .emacs.d/auto-save/
(setq auto-save-file-name-transforms
      `((".*" ,(concat user-emacs-directory "auto-save/") t)))
(setq backup-directory-alist
      `((".*" ,(concat user-emacs-directory "auto-save/") t)))

;;Usage
(delete-selection-mode 1)
(setq switch-to-buffer-obey-display-actions nil)
				
(global-set-key (kbd "M-s-<left>")  'windmove-left) ; Window selection
(global-set-key (kbd "M-s-<right>") 'windmove-right)
(global-set-key (kbd "M-s-<up>")    'windmove-up)
(global-set-key (kbd "M-s-<down>")  'windmove-down)

;;AucTEX
(use-package auctex)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
      
(setq LaTeX-command-style '(("" "%(PDF)%(latex) -synctex=1 -shell-escape %S%(PDFout)")))
(setq-default TeX-engine 'pdftex)

(use-package latex-preview-pane)
(latex-preview-pane-enable)


(use-package jinx)
