;; Conda config
(use-package conda
  :config
  (add-hook 'find-file-hook (lambda () (when (bound-and-true-p conda-project-env-path)
                                         (conda-env-activate-for-buffer)))) ;This can be improved
  (custom-set-variables '(conda-anaconda-home "~/.miniconda/"))
  ;;(conda-env-autoactivate-mode 1)
  :bind
  ("C-x c" . conda-env-activate))

;; Use tree-sitter python mode even in org-src buffers
(add-hook 'python-mode-hook
          (lambda ()
            (when (fboundp 'python-ts-mode)
              (python-ts-mode))))

;; Extra indent-bars settings for python
(use-package indent-bars
  :custom
  (indent-bars-treesit-wrap '((python argument_list parameters
				      list list_comprehension
				      dictionary dictionary_comprehension
				      parenthesized_expression subscript)))
  (indent-bars-treesit-scope '((python function_definition class_definition for_statement
				       if_statement with_statement while_statement)))
  (indent-bars-treesit-ignore-blank-lines-types '("module")))

;; LSP-mode for all python buffers
(use-package lsp-pyright
  :ensure t
  :custom
  (lsp-pyright-langserver-command "basedpyright")
  :hook ((python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp)))
	 (python-ts-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp)))))  ; or lsp-deferred

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
