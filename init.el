;;; init.el --- Trevor Bekolay's emacs configuration.
;;
;; Copyright (c) 2014-2020 Trevor Bekolay
;;
;; Author: Trevor Bekolay <tbekolay@gmail.com>
;; URL: https://github.com/tbekolay/dotfiles
;; Version: 0.1.0

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This file sets up Emacs like Trevor likes it.

;;; License:

;; Copyright (c) 2014-2020 Trevor Bekolay
;;
;; Permission is hereby granted, free of charge, to any person
;; obtaining a copy of this software and associated documentation
;; files (the "Software"), to deal in the Software without
;; restriction, including without limitation the rights to use, copy,
;; modify, merge, publish, distribute, sublicense, and/or sell copies
;; of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:
;;
;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
;; BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
;; ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
;; CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

;;; Code:

;; --- Set up straight.el

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(custom-set-variables
 '(straight-use-package-by-default t)
 '(tramp-default-method "ssh"))

(straight-use-package 'use-package)

;; --- General settings

(setq user-full-name "Trevor Bekolay")
(setq user-mail-address "tbekolay@gmail.com")
(setq gc-cons-threshold 50000000)
(setq large-file-warning-threshold 100000000)
(setq inhibit-startup-screen t)
(setq initial-scratch-message "")
(setq initial-major-mode 'fundamental-mode)
(setq visible-bell t)
(setq scroll-margin 10)
(setq scroll-conservatively 100000)
(setq scroll-preserve-screen-position 1)
(setq save-interprogram-paste-before-kill t)
(setq mouse-yank-at-point t)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq auto-save-list-file-prefix nil)

(blink-cursor-mode -1)
(global-auto-revert-mode t)
(show-paren-mode 1)
(global-hl-line-mode +1)

(fset 'yes-or-no-p 'y-or-n-p)
(set-face-background hl-line-face "azure2")
(set-face-attribute 'default nil :height 94)

(add-hook 'focus-out-hook (lambda () (save-some-buffers t)))

(use-package bind-key)

(use-package compile
  :init
  (setq compilation-ask-about-save nil)
  (setq compilation-always-kill t)
  (setq compilation-scroll-output 'first-error))

(use-package diminish)

(use-package flycheck
  :init (setq-default flycheck-emacs-lisp-load-path 'inherit)
  :config (global-flycheck-mode t)
  :bind (("M-n" . flycheck-next-error)
         ("M-p" . flycheck-previous-error)))

(use-package re-builder
  :init (setq reb-re-syntax 'string))

(use-package saveplace
  :init (setq-default save-place t))

(use-package savehist
  :init
  (setq savehist-additional-variables '(search-ring regexp-search-ring))
  (setq savehist-autosave-interval 60)
  (setq savehist-file (concat user-emacs-directory "savehist"))
  :config
  (savehist-mode +1))

(use-package undo-tree
  :config (global-undo-tree-mode))

(use-package uniquify
  :straight nil
  :init
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-separator "/")
  (setq uniquify-after-kill-buffer-p t)
  (setq uniquify-ignore-buffers-re "^\\*"))

(use-package volatile-highlights
  :config (volatile-highlights-mode t))

;; --- Windows and frames

(when (window-system)
  (tool-bar-mode -1)
  (menu-bar-mode 1)
  (toggle-scroll-bar -1)
  (when (fboundp 'horizontal-scroll-bar-mode)
    (horizontal-scroll-bar-mode -1)))

(unless (window-system)
  (menu-bar-mode 0))

(add-hook
 'after-make-frame-functions
 (lambda (frame)
   (with-selected-frame frame
     (tool-bar-mode -0)
     (menu-bar-mode 1)
     (toggle-scroll-bar -1)
     (when (fboundp 'horizontal-scroll-bar-mode)
       (horizontal-scroll-bar-mode -1)))))

(setq frame-title-format
      '(:eval (if (buffer-file-name)
                  (abbreviate-file-name (buffer-file-name))
                "%b")))

;; --- Whitespace stuff

(setq-default indent-tabs-mode nil)
(setq tab-width 4)
(setq-default c-basic-offset 4)
(setq-default tab-always-indent 'complete)
(setq require-final-newline t)
(add-hook 'before-save-hook 'whitespace-cleanup)

(use-package whitespace
  :init
  (setq whitespace-line-column 80)
  (setq whitespace-style '(face tabs empty trailing lines-tail))
  :hook ((text-mode org-mode) . whitespace-mode))

;; --- Helper functions

(defun tb-dont-clean-whitespace ()
  "Set `before-save-hook' to nil in this buffer."
  (add-hook 'before-save-hook nil nil t))

(defun tb-query-to-camelcase ()
  "Convert a query to camelcase."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (query-replace-regexp "\(\w\)_\(\w\)" "\1\,(upcase \2)")))

(defun tb-to-camelcase ()
  "Convert a buffer to camelcase."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward-regexp "\(\w\)_\(\w\)" nil 'noerror)
      (replace-match "\1\,(upcase \2)" nil 'literal))))

(defun tb-rename-buffer-and-file ()
  "Rename current buffer and if the buffer is visiting a file, rename it too."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (rename-buffer (read-from-minibuffer "New name: " (buffer-name)))
      (let ((new-name (read-file-name "New name: " filename)))
        (cond
         ((vc-backend filename) (vc-rename-file filename new-name))
         (t
          (rename-file filename new-name t)
          (set-visited-file-name new-name t t)))))))

(defun tb-delete-file-and-buffer ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (when filename
      (if (vc-backend filename)
          (vc-delete-file filename)
        (when (y-or-n-p (format "Are you sure you want to delete %s? " filename))
          (delete-file filename)
          (message "Deleted file %s" filename)
          (kill-buffer))))))

(defun unfill-paragraph ()
  "Take a multi-line paragraph and make it into a single line of text."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

;; --- Mac OS X specific

(defvar mac-command-modifier)
(defvar mac-option-modifier)

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :config (exec-path-from-shell-initialize))

;; Swap meta (alt/option) and super (command).
(when (eq system-type 'darwin)
  (defun tb-swap-meta-and-super ()
    "Swap the mapping of Meta and Super."
    (interactive)
    (if (eq mac-command-modifier 'super)
        (progn
          (setq mac-command-modifier 'meta)
          (setq mac-option-modifier 'super)
          (message "Command is now bound to META and Option is bound to SUPER."))
      (progn
        (setq mac-command-modifier 'super)
        (setq mac-option-modifier 'meta)
        (message "Command is now bound to SUPER and Option is bound to META.")))))
(when (fboundp 'tb-swap-meta-and-super) (tb-swap-meta-and-super))

;; --- Mode line config

(column-number-mode t)
(use-package smart-mode-line
  :init
  (setq sml/no-confirm-load-theme t)
  (setq sml/theme 'respectful)
  :config
  (sml/setup)
  (add-to-list 'sml/replacer-regexp-list '("^~/Code/nengo/" ":Nengo:"))
  (add-to-list 'sml/replacer-regexp-list '("^~/Dropbox/" ":DB:"))
  (add-to-list 'sml/replacer-regexp-list '("^~/Code/" ":C:"))
  (smart-mode-line-enable))

(use-package anzu
  :config (global-anzu-mode +1))

;; --- Fringe

(use-package diff-hl
  :hook (dired-mode . diff-hl-dired-mode)
  :config (global-diff-hl-mode +1))

;; --- Key bindings

(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)
(global-set-key (kbd "C-q") 'unfill-paragraph)

;; --- Dired

(setq dired-recursive-deletes 'always)
(setq dired-recursive-copies 'always)

(use-package dired-details
  :init (setq dired-details-hidden-string "* ")
  :config (dired-details-install))

;; --- Ido

(use-package ido
  :config
  (ido-mode 1)
  (ido-everywhere 1))

(use-package ido-completing-read+
  :config (ido-ubiquitous-mode 1))

(use-package flx-ido
  :init (setq ido-enable-flex-matching t)
  :config (flx-ido-mode 1))

(use-package ido-vertical-mode
  :init (setq ido-vertical-define-keys 'C-n-C-p-up-and-down)
  :config (ido-vertical-mode 1))

;; --- Ibuffer

(global-set-key (kbd "C-x C-b") 'ibuffer)

;; --- smex

(use-package smex
  :bind (("M-x" . smex)
         ("M-z" . smex)
         ("M-X" . smex-major-mode-commands)
         ("C-c C-c M-x" . execute-extended-command)))

;; --- Spell checking

(cond
 ((executable-find "hunspell")
  (use-package flyspell
    :hook ((text-mode . flyspell-mode)
           (python-mode . flyspell-prog-mode))
    :init
    (setq ispell-program-name "hunspell")
    (setq ispell-really-hunspell t)
    (setq flyspell-issue-message-flag nil)
    (setq ispell-local-dictionary "en_US")
    (setq ispell-local-dictionary-alist
          '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8)))))
  ((executable-find "aspell")
   (use-package flyspell
     :hook ((text-mode . flyspell-mode)
            (python-mode . flyspell-prog-mode))
     :init
     (setq ispell-program-name "aspell")
     (setq ispell-extra-args '("--sug-mode=ultra" "--lang=en_US")))))


;; TODO: do I miss this yank stuff?

;; Max number of characters to indent
;; (defvar yank-indent-threshold 1000)

;; Programming-modes with indentation senstivity should be listed here
;; (defvar indent-sensitive-modes
;;   '(conf-mode coffee-mode haml-mode python-mode slim-mode yaml-mode))

;; Only non-programming modes need to be listed here
;; (defvar yank-indent-modes '(LaTeX-mode TeX-mode))

;; (defun yank-advised-indent-function (beg end)
;;   "Do indentation, as long as the region isn't too large."
;;   (if (<= (- end beg) yank-indent-threshold)
;;       (indent-region beg end nil)))

;; Make it possible to advise multiple functions
;; (defmacro advise-commands (advice-name commands class &rest body)
;;   "Apply advice named ADVICE-NAME to multiple COMMANDS.

;; The body of the advice is in BODY."
;;   `(progn
;;      ,@(mapcar (lambda (command)
;;                  `(defadvice ,command (,class ,(intern (concat (symbol-name command) "-" advice-name)) activate)
;;                     ,@body))
;;                commands)))

;; (advise-commands "indent" (yank yank-pop) after
;;   "If current mode is one of `yank-indent-modes',
;; indent yanked text (with prefix arg don't indent)."
;;   (if (and (not (ad-get-arg 0))
;;            (not (member major-mode indent-sensitive-modes))
;;            (or (derived-mode-p 'prog-mode)
;;                (member major-mode yank-indent-modes)))
;;       (let ((transient-mark-mode nil))
;;         (yank-advised-indent-function (region-beginning) (region-end)))))

;; --- Magit

(use-package magit
  :init (setq magit-last-seen-setup-instructions "1.4.0"))

;; --- Org mode

(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

;; --- LaTeX

;; (use-package tex
;;     :ensure auctex
;;     :init (setq TeX-auto-save t)
;;           (setq TeX-parse-self t)
;;           (setq-default TeX-master nil)
;;     :mode (("\\.tex$" . LaTeX-mode)))

;; --- Shell scripting

(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)
(add-to-list 'auto-mode-alist '("\\.zsh\\'" . shell-script-mode))

;; --- Python

(use-package anaconda-mode
  :hook python-mode)
(use-package blacken
  :init (setq-default blacken-executable "/home/tbekolay/.virtualenvs/nengo/bin/black")
  :hook (python-mode . blacken-mode))

;; --- Matlab

(use-package octave-mode
  :mode "\\.m$"
  :straight nil)

;; --- Web programming

(use-package web-mode
  :mode ("\\.html?$"
         "\\.jsx?$"
         "\\.css$"
         "\\.xml$"
         "\\.json$")
  :init
  (setq-default js-indent-level 2)
  (setq-default css-indent-offset 2)
  (setq-default web-mode-attr-indent-offset 2)
  (setq-default web-mode-css-indent-offset 2)
  (setq-default web-mode-code-indent-offset 2)
  (setq-default web-mode-markup-indent-offset 2)
  (setq-default web-mode-enable-auto-quoting nil))

(use-package prettier-js
  :init
  (setq prettier-js-command "/home/tbekolay/.npm/bin/prettier")
  (setq prettier-js-args '("--trailing-comma" "es5"))
  :hook (web-mode . prettier-js-mode))

;; --- YAML

(use-package yaml-mode
  :mode "\\.ya?ml$")

;; --- Markdown

(use-package markdown-mode
  :mode (("README\\.md$" . gfm-mode)
         ("\\.md$" . markdown-mode)
         ("\\.markdown" . markdown-mode))
  :init (setq markdown-command "pandoc"))

(provide 'init)
;;; init ends here
