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
  (load-theme 'solarized-light t)
  (set-emacs-frames "light"))

(defun set-emacs-theme-dark ()
  (interactive)
  (load-theme 'ef-bio t)
  (set-emacs-frames "dark"))

(if (window-system)
    (set-emacs-theme-dark))

;;CUA mode
(cua-mode t)

;;Ivy
(use-package ivy
  :config
  (ivy-mode 1))

;;Doom modeline
(use-package nerd-icons)
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom (doom-modeline-major-mode-icon t)
  (doom-modeline-vcs-icon t)
  (doom-modeline-vcs-display-function #'doom-modeline-vcs-name)
  )

;;Other
(setq inhibit-startup-message t)
(desktop-save-mode 1) ;save workspace
(tool-bar-mode -1) ;remove toolbar

;;Autosaves on .emacs.d/auto-save/
(setq auto-save-file-name-transforms
      `((".*" ,(concat user-emacs-directory "auto-save/") t)))
(setq backup-directory-alist
      `((".*" ,(concat user-emacs-directory "auto-save/") t)))

;;Usage
(delete-selection-mode 1)
