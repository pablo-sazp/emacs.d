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
(add-to-list 'default-frame-alist
             '(font . "Hack-11"))
(set-face-attribute 'default nil :font "Hack" :height 114)
(set-face-attribute 'variable-pitch nil :font "DejaVu Sans" :height 125 :weight 'regular)

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
  (load-theme 'doom-material-dark t)
  ;;(load-file "~/.emacs.d/themes/material-darker-custom.el")
  (set-emacs-frames "dark"))

(if (window-system)
    (set-emacs-theme-dark))

;;CUA mode
(cua-mode t)
(global-set-key (kbd "C-S-z") #'undo-redo)

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
   ("C-c e" . embark-export)
   :map minibuffer-mode-map
   ("C-c b" . embark-become))
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
(setq delete-by-moving-to-trash t)	; Send to trash when deleting with dired

(use-package nerd-icons
  :demand t
  :custom
  (nerd-icons-font-family "Symbols Nerd Font Mono")
  )

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
  (setq company-idle-delay 0.1)
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

;; Project management
(use-package projectile
  :init
  (setq projectile-project-search-path '("~/Projects/"))
  (require 'transient)
  :config
  (global-set-key (kbd "C-c p") 'projectile-dispatch)
  (projectile-mode 1))
  

;;Line numbers + others
(setq-default display-line-numbers-type 'relative)
(dolist (hook '(prog-mode-hook
		LaTeX-mode-hook))
  (add-hook hook #'display-line-numbers-mode)) ; Enable line numbers only in these modes

(use-package smartparens
  :ensure smartparens  ;; install the package
  ;;:hook (prog-mode text-mode markdown-mode) ;; add `smartparens-mode` to these hooks
  :config
  ;; load default config
  (require 'smartparens-config)
  (smartparens-global-mode t)
  :bind
  (("M-l" . sp-up-sexp)			; Movement out of parenthesis
   ("M-L" . sp-backward-up-sexp)
   ("C-M-d" . sp-down-sexp)
   ("C-M-f" . sp-forward-sexp)		; Movement across sexps
   ("C-M-b" . sp-backward-sexp)))

;; Language server

(use-package eglot
  :ensure t
  :hook ((python-mode . eglot-ensure)
         (python-ts-mode . eglot-ensure))
  :config
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode) . ("pylsp"))))

;; Terminal

(use-package vterm
  :config
  (add-to-list 'display-buffer-alist
	     `("*vterm*"
	       (display-buffer-reuse-window display-buffer-at-bottom)
	       (window-height . 0.3)
	       (reusable-frames . nil)))
  :bind (:map vterm-mode-map
	      ("C-S-v" . vterm-yank)))

;; LLM integration

(use-package gptel
  :bind
  ("C-x l" . gptel-menu)
  :config
  (setq
   gptel-model 'gemini-flash-lite-latest
   gptel-backend (gptel-make-gemini "Gemini"
                   :key "AQ.Ab8RN6I1h9erWnYczH1LIoTbfMCEa29mVuqJHosEgbHQAfUSYQ"
                   :stream t)))


(use-package markdown-mode		; Pretty markdown mode
  :after gptel
  :hook
  (gptel-mode-hook . variable-pitch-mode))

;; -------------------------------------------------------------------------------------
(use-package which-key
  :init
  (which-key-mode)
  :config
  (setq which-key-idle-delay 0.8))

(use-package jinx
  :hook
  (LaTeX-mode . jinx-mode)		;Activate jinx mode only in latex
  (text-mode . jinx-mode)
  (org-mode . jinx-mode)
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
  :config
  ;; Conda environment on modeline
  (doom-modeline-def-segment conda-env	
    (when (and (boundp 'conda-env-current-name) conda-env-current-name)
      (concat " " 
	      (nerd-icons-devicon "nf-dev-anaconda" :face 'font-lock-escape-face :height 1.0) 
	      (propertize (format " %s " conda-env-current-name)
			  'face '(:inherit font-lock-escape-face :height 1.0)))))
  ;; This defines the order on the right side of the modeline
  (doom-modeline-def-modeline 'main
    '(bar matches buffer-info remote-host buffer-position parrot selection-info)
    '(misc-info minor-modes input-method buffer-encoding conda-env major-mode process vcs)))

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


;; Line numbers + others
(setq-default display-line-numbers-type 'relative)
(global-display-line-numbers-mode -1)	; Line numbers disabled by default
(dolist (hook '(prog-mode-hook
		LaTeX-mode-hook))
  (add-hook hook (display-line-numbers-mode 1))) ; Enable line numbers only in these modes

(use-package smartparens
  :ensure smartparens  ;; install the package
  ;;:hook (prog-mode text-mode markdown-mode) ;; add `smartparens-mode` to these hooks
  :config
  ;; load default config
  (require 'smartparens-config)
  (smartparens-global-mode t))


;;Autosaves on .emacs.d/auto-save/
(setq auto-save-file-name-transforms
      `((".*" ,(concat user-emacs-directory "auto-save/") t)))
(setq backup-directory-alist
      `((".*" ,(concat user-emacs-directory "auto-save/") t)))

;;Usage
(setq enable-recursive-minibuffers t)

(delete-selection-mode 1)
(setq switch-to-buffer-obey-display-actions nil)

(setq mark-ring-max '5); Mark ring
(setq global-mark-ring-max '5)

(use-package expand-region  ; Expand regions
  :ensure t
  :bind
  (("M-h" . er/expand-region)
   ("M-H" . mark-paragraph)))


;; Buffer navigation
(use-package ace-window					; Switch windows
  :bind
  (("C-x C-o" . ace-window)))

(use-package buffer-move
  :bind
  (("C-<left>" . buf-move-left)
   ("C-<right>" . buf-move-right)
   ("C-<up>" . buf-move-up)
   ("C-<down>" . buf-move-down)))

;; Load programing packages + custom settings
(add-to-list 'load-path "~/.emacs.d/package-settings/")

(require 'auctex-custom)
(require 'orgmode-custom)
(require 'orgroam-custom)
(require 'python-custom)

;; General ess settings
(with-eval-after-load 'ess-site
  (require 'ess-custom)
  )

(add-to-list 'display-buffer-alist
	     `("^\\*R\\(?::.*\\)?\\*$"
	       (display-buffer-reuse-window display-buffer-at-bottom)
	       (window-height . 0.3)
	       (reusable-frames . nil)))

;; Custom functions
;;(add-to-list 'load-path "~/.emacs.d/functions/")
(use-package toggle-terminal
  :load-path "~/.emacs.d/functions/"
  :bind
  ("<f12>" . myfun/toggle-layout))


;; Packages installed from git
(use-package ess-plot
  :load-path "~/.emacs.d/git-packages/ess-plot/"
  ;:hook (ess-r-post-run . ess-plot-on-startup-h)
  )
