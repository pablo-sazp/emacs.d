(provide 'ess-custom)

;; Buffer organization like RStudio
(add-to-list 'display-buffer-alist
      `(("^\\*R Dired"
         (display-buffer-reuse-window display-buffer-in-side-window)
         (side . right)
         (slot . -1)
         (window-width . 0.33)
         (reusable-frames . nil))
        ("^\\*R"
         (display-buffer-reuse-window display-buffer-at-bottom)
         (window-height . 0.33)
         (reusable-frames . nil))
        ("^\\*Help"
         (display-buffer-reuse-window display-buffer-in-side-window)
         (side . right)
         (slot . 1)
         (window-width . 0.33)
         (reusable-frames . nil))))

(setq ess-set-style 'RStudio)
