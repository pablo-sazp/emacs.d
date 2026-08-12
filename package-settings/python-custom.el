;; Conda config

(use-package conda
  :config
  (add-hook 'find-file-hook (lambda () (when (bound-and-true-p conda-project-env-path)
                                         (conda-env-activate-for-buffer)))) ;This can be improved
  (custom-set-variables '(conda-anaconda-home "~/.miniconda/"))
  :bind
  ("C-x c" . conda-env-activate))

;; LSP-mode for all python buffers
(with-eval-after-load 'lsp-mode
  (add-hook 'python-mode-hook 'lsp))

;; Disable eldoc when lsp is active
(add-hook 'python-mode-hook
          (lambda ()
            (setq-local eldoc-documentation-functions
                        (list #'lsp-eldoc-function))))

;; Buffer position
(add-to-list 'display-buffer-alist
             '("^\\*Python"
               (display-buffer-reuse-window display-buffer-at-bottom)
               (window-height . 0.33) 
               (reusable-frames . nil)))

(add-to-list 'display-buffer-alist
             '("^\\*Python-Help"
               (display-buffer-reuse-window display-buffer-in-side-window)
               (side . right)
               (slot . 1)
               (window-width . 0.33)
               (reusable-frames . nil)))

(provide 'python-custom)
