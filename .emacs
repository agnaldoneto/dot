;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Basics

;; Emacs aspect
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(setq inhibit-splash-screen t)

;; Follow symlinks by default
(setq vc-follow-symlinks t)

;; Option is meta in mac
(setq mac-option-modifier 'none)
(setq mac-command-modifier 'meta)

;; Don't save backups
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Highlight current line
(global-hl-line-mode)

;; Font
(set-default-font "Inconsolata 12")

;; Indentation is with spaces
(setq-default indent-tabs-mode nil)

;; Frame title
(setq-default frame-title-format '(buffer-file-name "%f" "%b"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Package

(require 'package) 
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

;; List my packages
(setq package-list '(
                     cyberpunk-theme
                     flx-ido
                     neotree
                     ag
                     projectile
                     markdown-mode
                     rainbow-delimiters
                     clojure-mode
                     cider
                     ac-cider
                     clj-refactor
                     align-cljlet
                     helm
                     helm-projectile
                     ))

;; Activate all the packages
(package-initialize)

;; Fetch the list of packages available 
(unless package-archive-contents (package-refresh-contents))

;; Install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package) (package-install package)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Load theme

(add-hook 'after-init-hook 
      (lambda () (load-theme 'cyberpunk t)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Line numbers everywhere

(require 'linum)
(global-linum-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Markdown mode config

(autoload 'markdown-mode "markdown-mode" "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Rainbow delimiters when programming

(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Setup Helm

(setq tramp-ssh-controlmaster-options
      (concat
       "-o ControlPath=/tmp/ssh-ControlPath-%%r@%%h:%%p "
       "-o ControlMaster=auto -o ControlPersist=yes"))

(require 'helm-config)
(helm-mode 1)

(setq helm-M-x-fuzzy-match t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Enable NeoTree

(require 'neotree)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Enable IDO

;; (require 'ido)
;; (require 'flx-ido)

;; (ido-mode 1)
;; (ido-everywhere 1)
;; (flx-ido-mode 1)

;; ;; disable ido faces to see flx highlights.
;; (setq ido-enable-flex-matching t)
;; (setq ido-use-faces nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Projectile

(projectile-global-mode)
(setq projectile-enable-caching t)
(setq projectile-switch-project-action 'neotree-show)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Org mode

(require 'org)
(setq org-log-done t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Sets keybindings

(global-set-key (kbd "C-x f") 'projectile-find-file)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key [f8] 'neotree-toggle)
