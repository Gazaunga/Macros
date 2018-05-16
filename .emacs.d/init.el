(require 'package)
(add-to-list 'package-archives'("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives'("org"          . "https://orgmode.org/elpa/"))

(setq debug-on-error t)

(require 'color-theme-sanityinc-tomorrow)

(defvar current-user
  (getenv
   (if (equal system-type 'windows-nt) "USERNAME" "USER")))

(message "Welcome back %s!" current-user)

(setq load-prefer-newer t)

(setq gc-cons-threshold 50000000)

(setq large-file-warning-threshold 100000000)

(setq fancy-splash-image '~/.emacs.d/assets/logo.svg')

(setq user-mail-address "jeremy.ottley@gmail.com")

(setq display-time-24hr-format t)
(setq display-time-and-date t)
(setq display-time-interval 10)
(display-time-mode t)

(setq tab-width 2)

(scroll-bar-mode -1)
;;; (load-theme 'tomorrow-night-blue-theme t)

;;;

;; Change the custom file, so "custom-set-variables" does not clutter up this file.
(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;; Disable the start screen.
(setq-default inhibit-startup-screen t)
(setq-default inhibit-splash-screen t)

;; I don't wanna learn more about gnu.
(setq-default inhibit-startup-message t)

;; Show me what's going on.
(switch-to-buffer "*Messages*")

;; Use the straight package manager.
;;(let ((bootstrap-file (concat user-emacs-directory "straight/bootstrap.el"))
  ;;    (bootstrap-version 2))
  ;;(unless (file-exists-p bootstrap-file)
    ;;(with-current-buffer
      ;;  (url-retrieve-synchronously
        ;; "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         ;;'silent 'inhibit-cookies)
      ;;(goto-char (point-max))
      ;;(eval-print-last-sexp)))
  ;;(load bootstrap-file nil 'nomessage))

;;(straight-use-package 'use-package)

;; Load my custom functions
(load-file (concat user-emacs-directory "functions.el"))

(defun load-directory (directory)
  "Load recursively all '.el' files in DIRECTORY."
  (dolist (element (directory-files-and-attributes directory nil nil nil))
    (let* ((path (car element))
           (fullpath (concat directory "/" path))
           (isdir (car (cdr element)))
           (ignore-dir (or (string= path ".") (string= path ".."))))
      (cond
       ((and (eq isdir t) (not ignore-dir))
        (load-directory fullpath))
       ((and (eq isdir nil) (string= (substring path -3) ".el"))
        (load (file-name-sans-extension fullpath)))))))

;; Make sure packages always get installed by default.
(setq use-package-always-ensure t)

;; Load all folders in $EMACS/config
(mapcar (lambda (dir)
	  (unless (cl-search "." dir)
	    (load-directory (concat user-emacs-directory "config/" dir))))
	(directory-files (concat user-emacs-directory "config")))

;;; ;;; ;;;


;; ORG and main configurations

(use-package org
  :ensure org-plus-contrib
  :pin org
  :config (org-babel-load-file (concat user-emacs-directory "README.org")))
