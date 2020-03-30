;; 1. Connect to MELPA

;; Package configs
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("org"   . "http://orgmode.org/elpa/")
			 ("gnu"   . "http://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")))
(unless package--initialized (package-initialize))

;; Bootstrap `use-package`
(eval-when-compile
  (require 'use-package))
(require 'bind-key)

;; Install by hand:
;; - org
(use-package org
  :ensure t
  :config
  (load "~/.config/emacs/org-config.el"))

;; PACKAGES

;; Personally Included Packages
(add-to-list 'load-path "~/.config/emacs/elisp")
(load "wc")

;; autopair
;; (autopair-global-mode)
;; (diminish 'autopair-mode)
(electric-pair-mode)

;; dired-sidebar
(use-package dired-sidebar
  :bind ([f8] . dired-sidebar-toggle-sidebar)
  :ensure t
  :commands (dired-sidebar-toggle-sidebar))

;; CMake
(use-package cmake-mode
  :mode ("\\.cmake\\'"
         "CMakeLists\\.txt\\'"))

(use-package cmake-font-lock
  :init
  (autoload 'cmake-font-lock-activate "cmake-font-lock" nil t)
  :hook (cmake-mode . cmake-font-lock-activate))

(use-package eldoc-cmake
  :hook (cmake-mode . eldoc-cmake-enable))

;; MAGIT
(use-package magit
  :bind (("C-x g" . magit-status)
         ("C-x C-g" . magit-file-dispatch))
  :config
  (set-face-attribute 'magit-diff-context-highlight t :background "grey45" :foreground "grey50")
  (set-face-attribute 'magit-section-highlight t :background "grey45")
  :ensure t)

(use-package forge
  :after magit
  :ensure t)

;; Markdown
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :bind ("C-c C-e" . markdown-export-and-preview)
  :config (setq markdown-command "kramdown"))

;; multiple-cursors
(use-package multiple-cursors
  :bind (("<f2>" . mc/mark-previous-like-this)
         ("S-<f2>" . mc/unmark-previous-like-this)
         ("<f3>" . mc/mark-next-like-this)
         ("S-<f3>" . mc/unmark-next-like-this)
         ("C-c <f2>" . mc/mark-all-like-this)
         ("C-S-<mouse-1>" . mc/add-cursor-on-click)
         ("<ESC> <ESC>" . mc/keyboard-quit))
  :ensure t)

(use-package expand-region
  :ensure expand-region
  :bind ("M-=" . er/expand-region))

;; csv
(use-package csv-mode
  :mode ("\\.csv\\'"))

;; json
(use-package json-mode
  :mode ("\\.json\\'"))

;; rust
(use-package rust-mode
  :mode ("\\.rs\\'"))

;; graphviz
(use-package graphviz-dot-mode
  :mode ("\\.gv\\'"))

;; counsel -> swiper -> ivy
;; thanks abo-abo
(use-package counsel
  :ensure t
  :diminish ivy-mode
;;  )

;; ;; swiper pop-up search
;; (use-package swiper
;;   :ensure t
;;   :diminish ivy-mode
  :bind (("C-s" . swiper)
         ("C-c C-r" . ivy-resume)
         ("C-c j" . ivy-immediate-done)
         ("M-C-s" . counsel-git-grep))
  :init
  (ivy-mode 1)
  (counsel-mode 1)
  :config
  (setq ivy-use-virutal-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-display-style 'fancy)
  (setq ivy-count-format "(%d/%d) "))

;; dashboard
(use-package dashboard
  :ensure t
  :diminish page-break-lines-mode
  :config
  (load "~/.config/emacs/my-dashboard-extras.el"))

(use-package auto-dim-other-buffers
  :ensure t
  :diminish auto-dim-other-buffers-mode
  :init (auto-dim-other-buffers-mode t)
  :config
  (set-face-attribute 'auto-dim-other-buffers-face nil
                      :background "#42444C"))

;; Python development
(use-package elpy
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable))
(use-package flycheck
  :after elpy
  :hook (elpy-mode . flycheck-mode))
(use-package py-autopep8
  :after elpy
  :hook (elpy-mode . py-autopep8-enable-on-save))

;; window management
(use-package win-switch
  :load-path "~/.config/emacs/elisp/win-switch"
  :ensure t
  :config
  (win-switch-setup-keys-ijkl-dvorak "\C-xo")
  (win-switch-add-key "o" 'next-window)
  (setq win-switch-idle-time 2.0)
  (setq win-switch-window-threshold 2)
  (setq win-switch-other-window-first nil)
  (setq win-switch-feedback-background-color "#536fd6"))
