;; ido mode everywhere
;; (ido-mode)

;; no menu, toolbars, scroolbar or splashscreen
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(setq inhibit-splash-screen t)

;; Follow symlinks by default
(setq vc-follow-symlinks t)

;; option is meta in mac
(setq mac-option-modifier 'none)(setq mac-command-modifier 'meta)

;; don't save backups
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Highlight current line
(global-hl-line-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Package and MELPA stuff

(require 'package) 
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)

;; List my packages
(setq package-list '(
		     cyberpunk-theme
                     clojure-mode
                     clj-refactor
                     cider
                     rainbow-delimiters
		     markdown-mode
                     helm-projectile
                     ag
                     projectile
                     helm))

; activate all the packages
(package-initialize)

; fetch the list of packages available 
(unless package-archive-contents (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package) (package-install package)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Sets keybindings

;; copy
(global-set-key (kbd "M-e") 'copy-region-as-kill)

;; Activate smex
;(global-set-key (kbd "M-x") 'smex)
;(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;(global-set-key (kbd "C-x f") 'fiplr-find-file)


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
;; Markdown mode

(autoload 'markdown-mode "markdown-mode" "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Font

(set-default-font "Inconsolata 12")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Tabs and indentation

(setq-default indent-tabs-mode nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Clojure

(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Helm

(require 'helm-config)
(helm-mode 1)

(global-set-key (kbd "M-x") 'helm-M-x)
(setq helm-M-x-fuzzy-match t)
