;; 1. Presonal Preferences
;;    These settings should work in all versions of emacs

;; package.el will insert this, but I call it from init.el
;; (package-initialize)

;; minimal UI
(when (display-graphic-p)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))
(tooltip-mode    -1)
(menu-bar-mode   -1)

(if (<= 26 emacs-major-version)
    (global-display-line-numbers-mode t)
  (when (fboundp 'linum-mode)
    (setq linum-format "%d ")
    (global-linum-mode 1)))

(set-default 'cursor-type 'bar)
(show-paren-mode 1)

;; Fancy titlebar for MacOS
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
(setq ns-use-proxy-icon  nil)
(setq frame-title-format nil)

;; emacs behaviour settings
(setq make-backup-files nil)
(defalias 'yes-or-no-p 'y-or-n-p)
(delete-selection-mode 1)
(setq inhibit-splash-screen t)
(global-auto-revert-mode)
(when (display-graphic-p)
  (setq default-directory (concat (getenv "HOME") "/")))

;; file settings
(setq-default indent-tabs-mode nil)
(setq-default c-basic-offset 4)
(setq gdb-gud-control-all-threads t)
(setq require-final-newline t)
(setq-default truncate-lines t)
(setq large-file-warning-threshold 100000000)

;; scrolling
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 5)))
;; ;; keep currently line vertically centered
;; (setq scroll-preserve-screen-position t
;;       scroll-conservatively 0
;;       maximum-scroll-margin 0.5
;;       scroll-margin 99999)

;; never kill my frame (GUI window). CMD-w (s-w) on mac
(when (display-graphic-p)
  (put 'delete-frame 'disabled t)
  (put 'save-buffers-kill-terminal 'disabled t))

;; hooks
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'org-mode-hook 'turn-on-visual-line-mode)

;; spell check all the time
(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))
(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
  (add-hook hook (lambda () (flyspell-mode -1))))

;; KEYBINDINGS
(load "~/.config/emacs/keybindings.el")

;; MY FUNCTIONS

;; UNDO Chris's AutoFillText
(defun unfill-paragraph ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))
(defun unfill-region ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-region (region-beginning) (region-end) nil)))

;; ibuffer
(require 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(setq ibuffer-default-sorting-mode 'major-mode)

;; line mode
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)
(when (< 23 emacs-major-version)
  (add-hook 'prog-mode-hook #'hs-minor-mode))

;; Scratch
;; from https://www.emacswiki.org/emacs/RecreateScratchBuffer
(defun unkillable-scratch-buffer ()
  (if (equal (buffer-name (current-buffer)) "*scratch*")
      (progn
	(delete-region (point-min) (point-max))
        (insert initial-scratch-message)
        nil)
    t))
(add-hook 'kill-buffer-query-functions 'unkillable-scratch-buffer)
(defun switch-to-scratch-and-back ()
  "Toggle between *scratch* buffer and the current buffer.
If the *scratch* buffer does not exist, create it."
  (interactive)
  (let ((scratch-buffer-name (get-buffer-create "*scratch*")))
    (if (equal (current-buffer) scratch-buffer-name)
        (switch-to-buffer (other-buffer))
      (switch-to-buffer scratch-buffer-name (lisp-interaction-mode)))))
(global-set-key (kbd "C-c s") 'switch-to-scratch-and-back)
(set-variable 'initial-scratch-message
";; This buffer is for text that is not saved, and for Lisp evaluation.
;; Run lisp code by going to end-of-line and typing C-j

")

;; Load Packages if on a Mac
(when (eq system-type 'darwin)
  ;; ensure running latest emacs
  (when (< 24 emacs-major-version)
    (load "~/.config/emacs/init.el")))

;; Load colors & theme
;; must come after init.el to ensure packages for guis
(load "~/.config/emacs/theme.el")
(load "~/.config/emacs/eshell.el")

;; Machine-specific configs
(if (eq system-type 'darwin)
    (setq cursys (car (split-string (system-name) "\\." t)))
  (setq cursys (getenv "LCSCHEDCLUSTER")))
(setq custom-file (concat "~/.emacs.d/custom-" cursys ".el"))
(load custom-file 'noerror)
