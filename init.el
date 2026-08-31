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
(push '(fullscreen . maximized) default-frame-alist) ; Start EMACS maximized

(setq-default line-spacing 2)

(add-to-list 'default-frame-alist
             '(font . "Hack-11"))
(set-face-attribute 'default nil :font "Hack" :height 114)
(set-face-attribute 'variable-pitch nil :font "DejaVu Sans" :height 114 :weight 'regular)

(use-package doom-themes)
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

(defvar display-buffer-alist nil)	; Initializes the variable so that I can add to it later

;;CUA mode
(cua-mode t)
(global-set-key (kbd "C-S-z") #'undo-redo)

(require 'ess-r-mode)			; This needs to be near the top, does not work otherwise

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
  ("C-x b" . consult-buffer)
  ("C-M-v" . consult-yank-from-kill-ring))

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
(setq dired-dwim-target t)
(setq dired-kill-when-opening-new-dired-buffer t) ; Delete buffer when opening a new directory

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
  :hook
  (prog-mode . company-mode)
  :config
  (setq tab-always-indent 'complete)
  (setq company-idle-delay 0.15)
  (setq company-minimum-prefix-length 3)
  (setq company-selection-wrap-around t)
  :bind (:map company-mode-map
	 ("<tab>" . 'company-indent-or-complete-common)
	 :map company-active-map
	 ("RET" . nil)
	 ("<tab>" . company-complete)
	 ("C-n" . 'company-select-next-or-abort)
	 ("C-j" . 'company-select-next-or-abort)
	 ("C-p" . 'company-select-previous-or-abort)
	 ("C-k" . 'company-select-previous-or-abort)))

(use-package company-box
  :after company
  :hook (company-mode . company-box-mode)
  :config
  (setq company-box-doc-enable nil)
  (setq company-auto-update-doc nil))

;; Git integration
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


;; ElDoc settings
(setq eldoc-echo-area-use-multiline-p nil)
(setq eldoc-echo-area-display-truncation-message nil)


;; Language server

;; (defun efs/lsp-mode-setup ()
;;   (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
;;   (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook
  ((python-mode . lsp-deferred)
   (ess-r-mode . lsp-deferred))
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  ;; Performance improvements from the lsp-mode documentation
  (setq gc-cons-threshold 100000000)
  (setq read-process-output-max (* 1024 1024)) ;; 1mb
  :config
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
  (lsp-enable-which-key-integration t)
  (setq lsp-eldoc-enable-hover nil)	       ; Disable description in echo area
  (setq lsp-signature-auto-activate nil)
  (setq lsp-signature-render-documentation nil))

(defun my/lsp-enable-other-completions ()
  "Allow company-files (and other backends) to run alongside company-capf in LSP buffers."
  (setq-local company-backends
              (list (append '(company-capf) '(:with company-files company-dabbrev-code)))))

(add-hook 'lsp-managed-mode-hook #'my/lsp-enable-other-completions)

(use-package lsp-ui
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom)
  (lsp-ui-doc-delay 0.5))

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

(setq auth-sources '("~/.emacs.d/.authinfo"))
(use-package gptel
  :bind
  ("C-x l" . gptel-menu)
  :config
  (setq
   gptel-model 'gemini-flash-lite-latest
   gptel-backend (gptel-make-gemini "Gemini"
		   :key (lambda () (gptel-api-key-from-auth-source "generativelanguage.googleapis.com"))
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
(desktop-save-mode -1) ;save workspace
(tool-bar-mode -1) ;remove toolbar
(scroll-bar-mode -1)
(menu-bar-mode -1)
(setq ring-bell-function 'ignore)

(setq mouse-wheel-progressive-speed nil) ;Mouse speed settings
(setq mouse-wheel-scroll-amount '(2))

(setf (cdr (assq 'continuation fringe-indicator-alist)) ;Remove newline symbols
      ;; '(nil nil) ;; no continuation indicators
      '(nil right-curly-arrow) ;; right indicator only
      ;; '(left-curly-arrow nil) ;; left indicator only
      ;; '(left-curly-arrow right-curly-arrow) ;; default
      )


;; Line numbers and other programing features
(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook #'display-line-numbers-mode) ; Enable line numbers only in programming modes
(setq display-line-numbers-width-start +1)

(use-package smartparens
  :ensure smartparens  ;; install the package
  ;;:hook (prog-mode text-mode markdown-mode) ;; add `smartparens-mode` to these hooks
  :config
  ;; load default config
  (require 'smartparens-config)
  (smartparens-global-mode t)
  :custom
  (show-smartparens-global-mode t)
  :bind
  (("M-l" . sp-up-sexp)			; Movement out of parenthesis
   ("M-L" . sp-backward-up-sexp)
   ("C-M-d" . sp-down-sexp)
   ("C-M-f" . sp-forward-sexp)		; Movement across sexps
   ("C-M-b" . sp-backward-sexp)))

;; Indent highlighting
(use-package indent-bars
  :hook (prog-mode . indent-bars-mode)
  :custom
  (indent-bars-color '("dimgray" :face-bg t :blend 0.8))
  (indent-bars-color-by-depth nil)
  (indent-bars-highlight-current-depth '(:color "DarkSeaGreen" :blend 0.7))
  (indent-bars-pattern ".")
  (indent-bars-display-on-blank-lines 'least)
  (indent-bars-starting-column 0)
  (indent-bars-no-descend-lists 'skip))

;; Multiple cursors
(use-package multiple-cursors
  :bind
  ("M-n" . mc/mark-next-like-this)
  ("M-N" . mc/unmark-next-like-this)
  ("M-p" . mc/mark-previous-like-this)
  ("M-P" . mc/unmark-previous-like-this)
  ("<f2>" . mc/mark-all-like-this))


;;Autosaves on .emacs.d/auto-save/
(setq auto-save-file-name-transforms
      `((".*" ,(concat user-emacs-directory "auto-save/") t)))
(setq backup-directory-alist
      `((".*" ,(concat user-emacs-directory "auto-save/") t)))

;; Revert buffers automatically when file updates on disk
(setq global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers 1) ; Also for dired

;;Usage
(setq enable-recursive-minibuffers t)

(delete-selection-mode 1)
(setq switch-to-buffer-obey-display-actions nil)

(setq mark-ring-max '5); Mark ring
(setq global-mark-ring-max '5)

(global-set-key (kbd "C--") #'join-line)

(use-package expand-region  ; Expand regions
  :ensure t
  :bind
  (("M-h" . er/expand-region)
   ("M-H" . mark-paragraph)))

(use-package casual
  :bind
  (:map calc-mode-map ("?" . casual-calc-tmenu))
  (:map calc-alg-map ("?" . casual-calc-tmenu))
  (:map dired-mode-map ("?" . casual-dired-tmenu)))
  ;;(:map org-mode-map ("?" . casual-org-tmenu))

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

(use-package popper
  :bind (("C-+"   . popper-toggle)
         ("M-+"   . popper-cycle)
         ("C-M-+" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          "\\*Async Shell Command\\*"
	  "\\*Gemini.*\\*"
	  "\\*Buffer List\\*"
          help-mode
          compilation-mode
	  occur-mode
	  "\\*vterm.*\\*"
	  "\\*Python.*\\*"
	  "\\*R.*\\*"
	  "\\*TeX Help\\*"
	  "\\*lsp-help\\*"
	  "\\*eshell\\*"))
  (popper-mode +1)
  (popper-echo-mode +1)
  :config
  (setq popper-group-function #'popper-group-by-projectile)
  (setq popper-display-control nil))

;; Load programing packages + custom settings
(add-to-list 'load-path "~/.emacs.d/package-settings/")

(require 'auctex-custom)
(require 'orgmode-custom)
(require 'orgroam-custom)
(require 'python-custom)

;; General ess settings
(require 'ess-settings)

(add-to-list 'display-buffer-alist
	     `("^\\*R\\(?::.*\\)?\\*$"
	       (display-buffer-reuse-window display-buffer-at-bottom)
	       (window-height . 0.3)
	       (reusable-frames . nil)))

;; Modified Help buffer size
(with-eval-after-load 'company
  (add-to-list 'display-buffer-alist
               '("^\\*Help\\*$"
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . right)
                 (slot . 1)             ; Slot 1 keeps it separate from Slot 0 (your active *Help*)
                 (window-width . 0.45)
                 (inhibit-same-window . t))))


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
