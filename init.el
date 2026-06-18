;;All automatic settings go here
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)
					
;;; Enable the Emacs server, allows editing via emacsclient
;; (require 'server)
;; (when (not (server-running-p)) (server-start))


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
(set-face-attribute 'fixed-pitch nil :font "Firacode Retina" :height 114)
(set-face-attribute 'variable-pitch nil :font "DejaVu Sans" :height 126 :weight 'regular)

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
(global-set-key (kbd "C-S-z") #'undo)

(require 'ess-site)			; This needs to be near the top, does not work otherwise

;; ------------------------------------ Minibuffer --------------------------------------

;; Vertico + Consult
(use-package vertico
  :custom
  ;; (vertico-scroll-margin 0) ;; Different scroll margin
  ;; (vertico-count 20) ;; Show more candidates
  ;; (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))

(use-package consult
  :bind
  ("C-s" . consult-line)
  ("C-M-s" . isearch-forward)
  ("M-g i" . consult-imenu)
  ("C-x b" . consult-buffer))

(use-package embark
  :bind
  (("C-." . embark-act)
   ("M-." . embark-dwim)
   ("C-c m" . embark-select)
   ("C-c e" . embark-export))
  )

(use-package embark-consult)

(use-package wgrep)

(use-package savehist			;Save history between sessions
  :init
  (savehist-mode))

(use-package orderless			;Fancy autocompletion for vertico
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil) ;; Disable defaults, use our settings
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring


;; Marginalia - annotations in the minibuffer
(use-package marginalia
  :config
  (marginalia-mode))

;; Dired stuff
(use-package nerd-icons
  :demand t)

(use-package nerd-icons-dired
  :after nerd-icons
  :hook
  (dired-mode . nerd-icons-dired-mode))

(dolist (fn '(dired-hide-details-mode))
  (add-hook 'dired-mode-hook fn))

(use-package nerd-icons-completion
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

;;--------------------------------------------------------------------------------------
;; Autocomplete + coding stuff

(use-package company
  :defer t
  :diminish ""
  :hook ((prog-mode) . (lambda () (company-mode)))
  :config
  (setq tab-always-indent 'complete)
  (setq company-idle-delay 1)
  (setq company-minimum-prefix-length 3)
  :bind (:map company-mode-map
	 ("<tab>" . 'company-indent-or-complete-common)
	 :map company-active-map
	 ("RET" . nil)
	 ("<tab>" . company-complete)
	 ("C-n" . 'company-select-next-or-abort)
	 ("C-j" . 'company-select-next-or-abort)
	 ("C-p" . 'company-select-previous-or-abort)
	 ("C-k" . 'company-select-previous-or-abort)))


(use-package magit)
(use-package git-timemachine)

;;Line numbers + others
(setq-default display-line-numbers-type 'relative)
(global-display-line-numbers-mode -1)
(dolist (hook '(emacs-lisp-mode-hook
		LaTeX-mode-hook))
  (add-hook hook #'display-line-numbers-mode)) ; enable line numbers only in these modes

(add-hook 'prog-mode-hook 'electric-pair-mode)

;; -------------------------------------------------------------------------------------
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
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom (doom-modeline-major-mode-icon t)
  (doom-modeline-vcs-icon t)
  (doom-modeline-vcs-display-function #'doom-modeline-vcs-name)
  (setq doom-modeline-env-version t)
  )

;;Visual + editor settings
(setq inhibit-startup-message t)
(desktop-save-mode 1) ;save workspace
(tool-bar-mode -1) ;remove toolbar
(scroll-bar-mode -1)
(menu-bar-mode -1)
(setq ring-bell-function 'ignore)

(defvar display-buffer-alist nil)	; Initializes the variable so that I can add to it later

(setq mouse-wheel-progressive-speed nil) ;Mouse speed settings
(setq mouse-wheel-scroll-amount '(2))

(setf (cdr (assq 'continuation fringe-indicator-alist)) ;Remove newline symbols
      ;; '(nil nil) ;; no continuation indicators
      '(nil right-curly-arrow) ;; right indicator only
      ;; '(left-curly-arrow nil) ;; left indicator only
      ;; '(left-curly-arrow right-curly-arrow) ;; default
      )

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

(setq mark-ring-max '5); Mark ring
(setq global-mark-ring-max '5)

(use-package expand-region  ; Expand regions
  :ensure t
  :bind
  (("M-h" . er/expand-region)
   ("M-H" . mark-paragraph)))

(use-package ace-window					; Switch windows
  :bind
  (("C-x o" . ace-window)))

(global-set-key (kbd "M-l")  'up-list)
(global-set-key (kbd "M-L")  'down-list)

;; Load programing packages + custom settings
(add-to-list 'load-path "~/.emacs.d/package-settings/")

(require 'ess-custom)
(require 'auctex-custom)
(require 'orgmode-custom)
(require 'orgroam-custom)
(require 'python-custom)
