;;; toggle-terminal.el --- Activate terminal or relevant REPL depending on the current major mode
;;; ~70% of this was done with the help of an LLM

(defvar myfun/layout-window-config nil)

(defun myfun/layout-spec ()
  "Return a layout specification based on current major mode."
  (cond
   ((derived-mode-p 'python-mode 'inferior-python-mode)
    '((bottom "*Python*")))
   ((derived-mode-p 'ess-r-mode 'inferior-ess-mode)
    '((bottom "*R"))) ;; Match *R*, *R:2*, *R:project*, etc.
   (t
    '((bottom "*vterm*")))))

(defun myfun/get-buffer (name-or-regexp)
  "Find an active buffer matching NAME-OR-REGEXP string."
  (or (get-buffer name-or-regexp)
      (cl-find-if (lambda (buf)
                    (string-match-p name-or-regexp (buffer-name buf)))
                  (buffer-list))))

(defun myfun/get-create-buffer (buf-spec)
  "Get or create the REPL buffer without triggering duplicate processes."
  (let ((existing-buf (myfun/get-buffer buf-spec)))
    (if (and existing-buf (get-buffer-process existing-buf))
        existing-buf
      ;; If no process/buffer, launch it
      (cond
       ((string-match-p "vterm" buf-spec)
        (if (fboundp 'vterm) (vterm) (ansi-term "/bin/bash")))
       ((string-match-p "Python" buf-spec)
        (run-python nil nil nil)) ;; nil args prevent window switching
       ((string-match-p "R" buf-spec)
        (require 'ess-r-mode)
        (let ((ess-ask-for-ess-directory nil)) ;; Prevent prompt for dir
          (R)))
       (t (get-buffer-create buf-spec)))
      ;; Return the buffer now that it's created
      (myfun/get-buffer buf-spec))))


(defvar myfun/layout-bottom-height 30
  "Default height (in lines) for the bottom layout window.")

;; (defvar myfun/layout-right-width 45
;;   "Default width (in columns) for the right layout window.")

(defun myfun/display-buffer-at (buffer direction)
  "Display BUFFER in the specified DIRECTION ('bottom or 'right).
Respects user configurations in `display-buffer-alist` first, 
falling back to default side-window layouts."
  (let ((action
         (cond
          ((eq direction 'bottom)
           `((display-buffer-in-side-window)
             (side . bottom)
             (window-height . ,myfun/layout-bottom-height)
             (dedicated . t)))
          ;; ((eq direction 'right)
          ;;  `((display-buffer-in-side-window)
          ;;    (side . right)
          ;;    (window-width . ,myfun/layout-right-width)
          ;;    (dedicated . t)))
          (t nil))))
    ;; display-buffer automatically checks display-buffer-alist first.
    ;; If no match is found, it falls back to the `action` we provided.
    (display-buffer buffer action)))

(defun myfun/layout-active-p (spec)
  "Return non-nil if all buffers in SPEC are visible in the current frame."
  (cl-every (lambda (item)
              ;; Use myfun/get-buffer instead of get-buffer
              (let ((buf (myfun/get-buffer (cadr item))))
                (and buf (get-buffer-window buf))))
            spec))

;;;###autoload
(defun myfun/toggle-layout ()
  "Toggle terminal/REPL window at the bottom of the screen."
  (interactive)
  (let ((spec (myfun/layout-spec)))
    (if (myfun/layout-active-p spec)
        ;; Hide layout: Restore config
        (progn
          (if myfun/layout-window-config
              (progn
                (set-window-configuration myfun/layout-window-config)
                (setq myfun/layout-window-config nil))
            (dolist (item spec)
              (let* ((buf (myfun/get-buffer (cadr item)))
                     (win (and buf (get-buffer-window buf))))
                (when win (delete-window win))))))
      ;; Show layout: Reset stale config, save current config, and display
      (setq myfun/layout-window-config (current-window-configuration))
      (let ((origin-win (selected-window)))
        (dolist (item spec)
          (let* ((dir (car item))
                 (buf-name (cadr item))
                 (buf (myfun/get-create-buffer buf-name)))
            (myfun/display-buffer-at buf dir)))))))


(provide 'toggle-terminal)
