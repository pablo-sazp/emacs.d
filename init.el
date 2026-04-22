;;All automatic settings go here
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)
					

;;Packages
(require 'package)

(setq package-archives '(("elpa" . "https://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ))

;;Package management
(require 'use-package)
(setq use-package-always-ensure t)

;;Theme
(use-package base16-theme)
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

;;Ivy
 (use-package ivy
   :demand t
   :init
   (ivy-mode 1)
   :config
   (counsel-mode 1)
   )

;; Swiper
(use-package swiper
  :bind (("C-s" . swiper-isearch)
	 ("C-M-s" . swiper-all))
  )

;; Marginalia - annotations in the minibuffer
(use-package marginalia
  :config
  (marginalia-mode))

;; Autocomplete + coding stuff
(use-package company)
(add-hook 'after-init-hook 'global-company-mode)

(use-package which-key
  :init
  (which-key-mode)
  :config
  (setq which-key-idle-delay 0.8))

(use-package jinx
  :hook
  (LaTeX-mode . jinx-mode)		;Activate jinx mode only in latex
  (text-mode-hook . jinx-mode)
  :config
  (global-jinx-mode -1))		;Disabled by default

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
(scroll-bar-mode -1)
(setq ring-bell-function 'ignore)

(setq-default display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)



(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook
		shell-mode-hook
		help-mode-hook
		doc-view-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0)))) ; disable line numbers for modes in term-mode				


;;Autosaves on .emacs.d/auto-save/
(setq auto-save-file-name-transforms
      `((".*" ,(concat user-emacs-directory "auto-save/") t)))
(setq backup-directory-alist
      `((".*" ,(concat user-emacs-directory "auto-save/") t)))

;;Usage
(setq enable-recursive-minibuffers t)

(delete-selection-mode 1)
(setq switch-to-buffer-obey-display-actions nil)
				
(global-set-key (kbd "M-s-<left>")  'windmove-left) ; Window selection
(global-set-key (kbd "M-s-<right>") 'windmove-right)
(global-set-key (kbd "M-s-<up>")    'windmove-up)
(global-set-key (kbd "M-s-<down>")  'windmove-down)

(setq mark-ring-max '4); Mark ring
(setq global-mark-ring-max '3)

(use-package expand-region  ; Expand regions
  :ensure t
  :bind
  (("M-s" . er/expand-region)
   ("M-S" . er/contract-region)))

(use-package ace-window					; Switch windows
  :bind
  (("C-o" . ace-window)))


;; Load programing packages + custom settings
(add-to-list 'load-path "~/.emacs.d/coding/")

(require 'auctex-custom)
