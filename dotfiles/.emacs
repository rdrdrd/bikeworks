;;; -*- mode: lisp; -*-
;;; S. Khamsi
;;; 13 May 1997
;;;
;;; $Id: .emacs,v 1.127 2010/07/23 18:26:20 khamsi Exp $
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Notes:
;; To append to the PATH
;; (setq exec-path (append exec-path '("c:\\usr\\cygwin64\\bin")))

;; note the current time when we start to calculate Emacs uptime
(defconst sk-emacs-load-start-time (current-time) "Record Emacs start time.")

(defun sk-message (MSG &optional ARGS)
  "Do special stuff to regular (message) function using MSG and ARGS."
  (interactive "S")
  (message (concat "sk: " MSG) ARGS))

(put 'scroll-left 'disabled nil)
(setq message-log-max t) ; use a larger *Messages* buffer

;;(add-to-list 'load-path "~/.emacs.d") ; causes warning
(if (file-exists-p "~/.emacs.d/elisp")
    (add-to-list 'load-path "~/.emacs.d/elisp"))
(if (file-exists-p "/usr/local/share/emacs/site-lisp")
    (add-to-list 'load-path "/usr/local/share/emacs/site-lisp"))

;; the new package manager
(when (require 'package nil t)
  (package-initialize)
  ;; (add-to-list 'package-archives
  ;;              '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives
               '("melpa" . "http://melpa.milkbox.net/packages/")))
(prefer-coding-system 'utf-8)

;; load ~/.gnus, if we got one sport
;; (if (file-exists-p "~/.gnus")
;;     (load-file "~/.gnus"))

;; hold some constants so we can system-specific stuff
(defconst sk-winnt-p (eq system-type 'windows-nt) "System type bool.")
(defconst sk-gnu/linux-p (eq system-type 'gnu/linux) "System type bool.")
(defconst sk-gnu/kfreebsd-p (eq system-type 'gnu/kfreebsd) "System type bool.")
(defconst sk-darwin-p (eq system-type 'darwin) "System type bool.")
(defconst sk-ms-dos-p (eq system-type 'ms-dos) "System type bool.")
(defconst sk-cygwin-p (eq system-type 'cygwin) "System type bool.")
(defconst sk-laptop-hostname "ZTUAI180056" "My laptop hostname.")
(defconst sk-desktop-hostname "ZTURA097226" "My desktop hostname.")
(defconst sk-orig-scroll-bar-mode scroll-bar-mode "The original value")

;; I use different drives on different computers, so make this work
;; across different machines
(cond ((equal sk-winnt-p t)
       (progn
         (setq shell-file-name "bash")
         (setq doc-view-ghostscript-program "gswin64c")
         (if (or (equal system-name sk-desktop-hostname)
                 (equal system-name (concat sk-desktop-hostname ".us.ray.com")))
             (defconst sk-main-drive "d:" "desktop main drive"))
         (defconst sk-main-drive "c:" "laptop main drive")
         ;; fix git/magit/cygwin/emacs problems
         (if (file-exists-p "c:/usr/cygwin64")
             (setq cygwin-root-directory "c:/usr/cygwin64"))
         (if (require 'cygwin-mount nil t)
             (cygwin-mount-activate))
         (require 'setup-cygwin nil t)))
      ((equal sk-cygwin-p t)
       (progn
         (if (or (equal (system-name) sk-desktop-hostname)
                 (equal (system-name)
                        (concat sk-desktop-hostname ".us.ray.com")))
             (defconst sk-main-drive "d:" "desktop main drive"))
         (defconst sk-main-drive "c:" "laptop main drive")))
      ((equal sk-gnu/linux-p t)
       (progn
         (add-hook 'c++-mode-hook #'global-flycheck-mode)
         (defconst sk-main-drive (getenv "HOME") "main drive"))))

;; point some tools to the right place depending on the system
(defconst sk-yasnippet-path
  (concat sk-main-drive "/cm/github/yasnippet") "Yasnippet.")
(defconst sk-magit-path (concat sk-main-drive "/cm/github/magit/lisp") "Magit.")
(defconst sk-auto-complete-path
  (concat sk-main-drive "/cm/github/auto-complete") "Auto-complete.")
(defconst sk-multiple-cursors-path
  (concat sk-main-drive
          "/cm/github/multiple-cursors.el") "Multiple-cursors.el.")
(defconst sk-markdown-path
  (concat sk-main-drive "/cm/github/markdown-mode") "Markdown-mode.el.")
(defconst sk-mediawiki-path
  (concat sk-main-drive "/cm/github/orgmode-mediawiki"))
(defconst sk-bbdb-file (concat sk-main-drive "/cm/emacsOrg/.bbdb") "My BBDB file.")

;; make sure another instance of Emacs is not running
(when (not (file-exists-p "~/.emacs.desktop.lock"))
  (server-start))
;;(add-to-list 'load-path "~/.emacs.d/") ; for general smaller packages

;;(setq debug-on-error t)

(defun sk-user-khamsi-p ()
  "Return t if username is Sarir Khamsi's."
  (interactive)
  (or (string-equal (getenv "USERNAME") "vav5315")
      (string-equal (getenv "USER") "khamsi")))

;;(require 'gnus-load nil t)

(require 'gnutls nil t)

;;(global-set-key "\eg" 'fill-region)
;;(global-set-key "\C-xt" 'unscroll)
;; (global-set-key [C-up] 'sk-scroll-up-in-place)
;; (global-set-key [C-down] 'sk-scroll-down-in-place)
(global-set-key [?\M-p] 'sk-scroll-up-in-place)
(global-set-key [?\M-n] 'sk-scroll-down-in-place)
(global-set-key [M-up] (lambda () (interactive) (scroll-other-window-down 1)))
(global-set-key [M-down] (lambda () (interactive) (scroll-other-window 1)))
(global-set-key [f1] (lambda () (interactive) (enlarge-window 1)))
(global-set-key [f2] 'shrink-window)
(global-set-key [f3] 'ispell-word)
(global-set-key [f4] 'call-last-kbd-macro)
(global-set-key [f5] 'next-error)
(global-set-key [f6] 'compile)
(global-set-key [f7] 'ediff-buffers)
(global-set-key [f8] 'other-window)
(global-set-key [f9] 'undo)
(global-set-key [f10] 'sk-convert-to-ctor-init-list)
(global-set-key [f11] 'goto-line)
(global-set-key [f12] 'sk-align-comma-arg-list)
(global-set-key [?\C-.] 'find-tag-other-window)
(global-set-key [C-f1] (quote revert-buffer))
;;(global-set-key [M-f1] (quote insert-patterned))
;;(global-set-key [M-f1] (quote sk-wiki-mode))
;;(global-set-key [M-f2] (quote sk-markup-region))
(global-set-key [M-f3] (quote sk-comment-endif))
;;(global-set-key [M-f6] (quote sk-run-current-file))
(global-set-key [M-f6] (quote sk-remove-space-around-parens))
(global-set-key [C-f2] (quote sk-dup-and-comment-line))
(global-set-key [C-f3] (quote sk-comment-exp))
(global-set-key [C-f4] (quote sk-capit))
(global-set-key [C-f5] (quote compilation-mode))
(global-set-key [C-f6] (quote sk-fix-whitespace-and-indent))
;;(global-set-key [C-f7] (quote sk-split-window-recent))
(global-set-key [C-f7] (quote sk-cap-char))
(global-set-key [C-f8] (quote sort-lines))
(global-set-key [C-f9] (quote sk-todo))
(global-set-key [C-f10] (quote sk-toggle-summary))
(global-set-key [C-f11] (quote sk-width))
(global-set-key [C-f12] (quote sk-insert-date))
(global-set-key [(control meta down)] (quote sk-grow-frame-height))
(global-set-key [(control meta f11)] (quote sk-grow-frame-height))
(global-set-key [(control meta up)]
                (lambda () (interactive) (sk-grow-frame-height -1)))
(global-set-key [(control meta f12)]
                (lambda () (interactive) (sk-grow-frame-height -1)))
(global-set-key [(control meta right)] (quote sk-grow-frame-width))
(global-set-key [(control meta left)]
                (lambda () (interactive) (sk-grow-frame-width -1)))
(global-set-key [(control meta f10)] (quote sk-grow-frame-width))
(global-set-key [(control meta f9)]
                (lambda () (interactive) (sk-grow-frame-width -1)))
(global-set-key [?\C-x ?\C-\\] (quote sk-kill-to-somewhere))
(global-set-key [?\C-\(] (quote sk-insert-parens))
(global-set-key [?\C-\:] (quote sk-insert-smiley))

(define-prefix-command 'lisp-find-map)
(define-key global-map [(control ?h) ?e] 'lisp-find-map)
(define-key lisp-find-map [?f] 'find-function)
(define-key lisp-find-map [?v] 'find-variable)
(define-key lisp-find-map [?k] 'find-function-on-key)
(define-key global-map [(control return)] 'other-window)
(fset 'yes-or-no-p 'y-or-n-p)

(when (require 'ido nil t)
  (setq ido-enable-flex-matching t)
  (setq ido-create-new-buffer 'always)
  (ido-mode 'both))

;; (add-hook 'dired-load-hook
;;           (lambda () (load "ls-lisp" t)))

;;; Append ~/devel/lisp to the load-path if it exist. Add some lisp files
;;; that I wrote
(when (file-exists-p (concat sk-main-drive "/cm/devel/lisp"))
  (setq load-path (cons (expand-file-name
                         (concat sk-main-drive "/cm/devel/lisp")) load-path))
  (require 'sk-create-class "create-class" t))
;;      (require 'sk-scrolling-madness "sk-scroll" t)))

;; (cond ((file-exists-p "~/.backups")
;;        (setq auto-save-list-file-prefix "~/.backups/.saves-")))
(when (file-exists-p "~/.backups")
  (setq auto-save-list-file-prefix "~/.backups/.saves-"))
(setq
 c-brace-offset -3
 enable-local-variables t
 perl-indent-level 3
 sh-indentation 3
 sh-basic-offset 3
 tab-width 3
 tab-interval 3
 next-line-add-newlines nil
 delete-old-versions t
 kept-new-versions 5
 version-control t
 make-backup-files t
 set-fill-column 80
 visible-bell t
 inhibit-startup-screen nil)

(column-number-mode 1) ; show column numbers
(setq-default indent-tabs-mode nil) ; use spaces instead of tabs
(setq-default python-indent 3)
(setq-default c-basic-offset 3)
(setq-default python-indent-offset 3)
(setq-default frame-title-format '("%f - " user-login-name "@" system-name))
;; (setq frame-title-format
;;       '((buffer-file-name "%f" (dired-directory dired-directory "%b")) " - "
;;         user-login-name "@" system-name))
(setq icon-title-format "Emacs: %b")
;; (standard-display-8bit ?\223 ?\224)
;; (standard-display-ascii ?\223 "\"")
;; (standard-display-ascii ?\224 "\"")
;; (standard-display-ascii ?\222 "\'")
;; ;;(standard-display-european t)
;; (standard-display-8bit 128 255)
;;(setq enable-local-eval 'ask-me)
;;(set-face-background 'modeline "slateblue4")
;;(set-face-foreground 'modeline "white")
(setq buffers-menu-max-size 20)
(menu-bar-mode -99) ;; hide menus and show with C-mouse-3
(scroll-bar-mode -1) ; turn off scroll bars...they are for sissies
(setq sgml-transformation 'upcase) ;; make HTML uppercase
(setq cursor-in-non-selected-windows nil) ; don't show hollow cursor in other window
(setq org-log-done t)
(add-hook 'org-mode-hook 'turn-on-flyspell)

;; yasnippet == yet another snippet
(when (file-exists-p sk-yasnippet-path)
  (add-to-list 'load-path sk-yasnippet-path))
(if (require 'yasnippet nil t)
    (yas-global-mode 1))

;; (when (file-exists-p sk-auto-complete-path)
;;   (add-to-list 'load-path sk-auto-complete-path)
;;   (when (require 'auto-complete nil t)
;;     (add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/ac-dict")
;;     (if (require 'auto-complete-config nil t)
;;         (ac-config-default))))

;; This causes some timer problems. sak - 2016-03-03
;; (when (file-exists-p sk-auto-complete-path)
;;   (add-to-list 'load-path sk-auto-complete-path)
;;   (when (require 'auto-complete-config nil t)
;;     (add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/ac-dict")
;;     ;;      (setq ac-use-quick-help t)
;;     (ac-config-default)

;;     ;; Comment out on 2014-10-20
;;     (add-hook 'c-mode-common-hook
;;               '(lambda ()
;;                  (add-to-list 'ac-omni-completion-sources
;;                               (cons "\\." '(ac-source-semantic)))
;;                  (add-to-list 'ac-omni-completion-sources
;;                               (cons "->" '(ac-source-semantic)))
;;                  (setq ac-source-yasnippet nil)
;;                  (setq ac-sources
;;                        '(ac-source-semantic ac-source-yasnippet))))))
;; (require 'auto-complete-extension nil t)

;; ;; auto-complete stuff, this needs to be *before* jdee
;; (if (require 'auto-complete-config nil t)
;;     (progn
;;       (add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/ac-dict")
;;       ;;      (setq ac-use-quick-help t)
;;       (ac-config-default)

;;       ;; Comment out on 2014-10-20
;;       (add-hook 'c-mode-common-hook
;;                 '(lambda ()
;;                    (add-to-list 'ac-omni-completion-sources
;;                                 (cons "\\." '(ac-source-semantic)))
;;                    (add-to-list 'ac-omni-completion-sources
;;                                 (cons "->" '(ac-source-semantic)))
;;                    (setq ac-source-yasnippet nil)
;;                    (setq ac-sources
;;                          '(ac-source-semantic ac-source-yasnippet))))
;;       ))

(defun sk-auto-complete-mode-maybe ()
  "No maybe for you.  Only AC!"
  ;;http://stackoverflow.com/questions/8095715/emacs-auto-complete-mode-at-startup
  (unless (minibufferp (current-buffer))
    (auto-complete-mode 1)))

;;(global-semantic-idle-completions-mode t)
;;(global-semantic-show-unmatched-syntax-mode t)
;;(global-semantic-decoration-mode nil)
;;(setq jde-enable-abbrev-mode t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil nil (frame))
 '(c-report-syntactic-errors t)
 '(canlock-password "40a3ba8e73f715d1457ea4a13b9fe188da3b8cc1")
 '(case-fold-search t)
 '(compilation-scroll-output t)
 '(compilation-window-height 10)
 '(compile-auto-highlight t)
 '(cperl-continued-statement-offset 2)
 '(cperl-highlight-variables-indiscriminately nil)
 '(cperl-under-as-char nil)
 '(current-language-environment "Latin-1")
 '(default-input-method "latin-1-prefix")
 '(dired-listing-switches "-agG")
 '(display-time-24hr-format t)
 '(display-time-format nil)
 '(display-time-mode t nil (time))
 '(doxymacs-external-xml-parser-executable "c:/home/khamsi/bin/doxymacs_parser.exe")
 '(doxymacs-group-comment-end "//!")
 '(doxymacs-group-comment-start "//!")
 '(ediff-grab-mouse nil)
 '(enable-recursive-minibuffers t)
 '(eudc-protocol (quote ldap))
 '(eudc-server "ldap.directory.ray.com")
 '(eudc-strict-return-matches t)
 '(flyspell-delay 5)
 '(font-lock-support-mode (quote jit-lock-mode))
 '(global-font-lock-mode t nil (font-lock))
 '(gnus-use-cache nil)
 '(grep-command "egrep -n -e ")
 '(imap-default-user "sarir.khamsi@raytheon.com")
 '(ispell-program-name "aspell")
 '(ispell-silently-savep t)
 '(jde-gen-k&r nil)
 '(jde-jdk-registry (quote (("1.7.0_45" . "c:/usr/java/jdk1.8.0_77"))))
 '(ldap-default-base "ou=PERSON,o=RAYTHEON.COM,C=US")
 '(ldap-default-host "ldap.directory.ray.com")
 '(ldap-default-port 389)
 '(ldap-host-parameters-alist
   (quote
    (("ldap.directory.ray.com" base "dn" binddn "OU=PERSON,O=RAYTHEON.COM,C=US" passwd "****" auth simple))))
 '(mail-signature "None")
 '(matlab-indent-level 3)
 '(message-dont-reply-to-names "sarir.*khamsi")
 '(message-log-max t)
 '(message-mode-hook nil)
 '(message-send-mail-partially-limit nil)
 '(message-signature nil)
 '(mouse-avoidance-mode (quote proteus) nil (avoid))
 '(mouse-avoidance-nudge-dist 30)
 '(nxml-child-indent 3)
 '(nxml-outline-child-indent 3)
 '(org-agenda-files
   (quote
    ("c:/cm/emacsOrg/softwareDevelopment.org" "c:/cm/emacsOrg/rmsProjects.org" "c:/cm/emacsOrg/raytheonWeeklyStatus.org")))
 '(org-babel-load-languages
   (quote
    ((sh . t)
     (python . t)
     (R . t)
     (ruby . t)
     (ditaa . t)
     (dot . t)
     (octave . t)
     (sqlite . t)
     (perl . t)
     (C . t))))
 '(package-selected-packages
   (quote
    (magit yasnippet flycheck matlab-mode markdown-mode multiple-cursors auto-complete-c-headers auto-complete-chunk bbdb haskell-mode vlf json-mode csv-mode cmake-ide auto-complete all)))
 '(python-continuation-offset 3)
 '(python-indent-offset 3)
 '(recentf-max-saved-items 9000)
 '(recentf-mode t nil (recentf))
 '(safe-local-variable-values
   (quote
    ((flycheck-gcc-language-standard . c++11)
     (flycheck-gcc-language-standard . c++14)
     (eval flyspell-mode 1)
     (flyspell-mode . t))))
 '(sh-indentation 3)
 '(show-paren-mode t)
 '(smtpmail-debug-info nil)
 '(smtpmail-smtp-server "us.rmail.ray.com")
 '(speedbar-update-speed 2 t)
 '(spell-command "aspell")
 '(standard-indent 3)
 '(tab-width 3)
 '(temp-buffer-resize-mode t)
 '(tool-bar-button-margin 4 t)
 '(tool-bar-button-relief 1 t)
 '(tool-bar-mode nil nil (tool-bar))
 '(woman-use-own-frame nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; JDEE
;; Note: moved this from before the custom part
;; (defvar sk-jdee-dir "~/.emacs.d/elisp/jdee-2.4.1/lisp" "Path to JDEE")
;; (if (file-exists-p sk-jdee-dir)
;;     (progn
;;       (add-to-list 'load-path sk-jdee-dir)
;;       (load "jde" t)
;;       (push 'jde-mode ac-modes)
;;       ;; this didn't seem to work for AC-mode
;;       ;; (setq auto-mode-alist
;;       ;;       (append '(("\\.java\\'" . jde-mode)) auto-mode-alist))
;;       (add-hook 'jde-mode-hook
;;                 (lambda () (push 'ac-source-semantic ac-sources)))))

(add-hook 'text-mode-hook 'turn-on-auto-fill)
(setq text-mode-hook          ; do auto fill mode in text mode
      '(lambda () (auto-fill-mode 1)))
(if (executable-find "aspell")
    (progn
      (add-hook 'org-mode-hook '(lambda () (flyspell-mode 1)))
      (add-hook 'text-mode-hook '(lambda () (flyspell-mode 1)))))
(setq mouse-buffer-menu-mode-mult 1)

(setq sk-height (/ (display-pixel-height) (frame-char-height)))
(setq sk-win-height (let ((env-val (getenv "EWH")))
                      (if env-val
                          (string-to-number env-val)
                        20)))

(defun sk-font-exists-p (font)
  "Test if FONT exists."
  (if (string-equal (describe-font font)
                    "No matching font being used")
      nil
    t))

;; intial frame, font, stuff

(when (member "-outline-Courier New-normal-normal-normal-mono-13-*-*-*-c-*-iso8859-1" (font-family-list))
  (set-face-attribute 'default nil :font "-outline-Courier New-normal-normal-normal-mono-13-*-*-*-c-*-iso8859-1"))

;; (can also set second-frame-alist)
(setq default-frame-alist
      '((cursor-color . "blue")
        (foreground-color . "black")
        (background-color . "white")
        ;;        (font . "-*-6X13-medium-r-*-*-13-97-*-*-p-60-*-ansi-")
        ;;        (font . "-outline-Lucida Console-normal-r-normal-normal-16-120-96-96-c-*-iso10646-1")
        ;;              (font . "-outline-Lucida Console-normal-r-normal-normal-19-142-96-96-c-*-iso10646-1")
        ;;        (font . "-outline-Courier New-normal-normal-normal-mono-13-*-*-*-c-*-iso8859-1")
        ;; use an env variable for the windows height, or just default it
        ;;        (width . 80) (height . sk-win-height)
        (width . 80) (height . 64)
        ;;              (width . 80) (height . sk-height)
        (top . 5) (left . 600)))

;;(setq sk-new-frame-height (/ (display-pixel-height) (frame-char-height)))
;;(push '((height . sk-new-frame-height)) default-frame-alist)

(setq initial-frame-alist '((top . 5) (left . 30)))

;;; OS specific stuff
;; (if (eq system-type 'windows-nt) ;; init for NT
;;     (progn
;;       (defun sk-my-shell-setup ()
;;         "For Cygwin bash under Emacs 20"
;;         (setq comint-scroll-show-maximum-output 'this)
;;         (make-variable-buffer-local 'comint-completion-addsuffix))
;;       (setq comint-completion-addsuffix t)
;;       (setq comint-eol-on-send t)
;;       (setq w32-quote-process-args ?\")

;;       (if (require 'cygwin-mount nil t)
;;           (cygwin-mount-activate))

;;       (add-hook 'shell-mode-hook 'sk-my-shell-setup)

;;       (setq python-shell-interpreter "c:\\usr\\cygwin64\\bin\\python3.4m.exe")
;;       (setq sk-acrobat-path "c:/Program Files (x86)/Adobe/Acrobat 11.0/Acrobat")
;;       (setq sk-acrobat-executable "AcroRd32.exe")

;;       (setenv "PATH" (concat "c:\\Program Files\\Java\\jdk1.8.0_65\\bin;"
;;                              (getenv "PATH")))

;;       (setq shell-file-name "bash")
;;       (setenv "SHELL" shell-file-name)
;;       (setq explicit-shell-file-name shell-file-name)
;;       (let* ((cyg-root (concat sk-main-drive "\\usr\\cygwin64"))
;;              (cyg-bin (concat cyg-root "\\bin"))
;;              (cyg-bash (concat cyg-bin "\\bash.exe")))
;;         (if (file-exists-p cyg-bash)
;;             (setq shell-file-name cyg-bash))
;;         (setq exec-path (cons cyg-bin exec-path))
;;         (setenv "PATH" (concat cyg-bin ";" (getenv "PATH"))))
;;       ;;      (setq exec-path (append "c:/usr/anaconda3"
;;       ;; for some reason, I can't get the right svn in my path
;;       ;; (if (file-exists-p "c:/usr/subversion/bin/svn.exe")
;;       ;;     (progn
;;       ;;       (setq exec-path (append '("c:/usr/subversion/bin") exec-path))))
;;       ;; (add-hook 'comint-output-filter-functions 'shell-strip-ctrl-m nil t)
;;       (setenv "LANG" "C")) ; fix strange svn problem
;;   (defconst sk-bbdb-file "~/cm/emacsOrg/.bbdb" "My BBDB file."))

;; gdb stuff
(setq gdb-many-windows t)

(setq shell-command-switch "-c")

;;; Colorized fonts
(defvar info-font-lock-keywords
  (list
   '("^\\* [^:]+:+" . font-lock-function-name-face)
   '("\\*[Nn]ote\\b[^:]+:+" . font-lock-reference-face)
   '("  \\(Next\\|Prev\\|Up\\):" . font-lock-reference-face))
  "Additional expressions to highlight in Info mode.")

(add-hook 'Info-mode-hook
          (lambda ()
            (make-local-variable 'font-lock-defaults)
            (setq font-lock-defaults '(info-font-lock-keywords nil t))))

;; color me human...with font-lock
(setq font-lock-maximum-decoration t)
(global-font-lock-mode t)
;;(setq font-lock-support-mode 'lazy-lock-mode)
(setq query-replace-highlight t)    ;highlight during query
(setq search-highlight t)     ;incremental search highlights

;;; Setup C/C++/Java indentation
(if (require 'cc-mode nil t)
    (progn
      (add-hook 'c++-mode-hook
                (function (lambda () (c-set-style "ellemtel"))))
      (add-hook 'c-mode-hook
                (function (lambda () (c-set-style "ellemtel"))))))
(add-hook 'c++-mode-hook
          (lambda () (setq flycheck-clang-language-standard "c++14")))

;; set a java mode hook
(add-hook 'java-mode-hook (function (lambda () (setq c-basic-offset 3))))
(add-hook 'java-mode-hook (function (lambda () (c-set-style "ellemtel"))))
(add-hook 'java-mode-hook (function (lambda () (flyspell-prog-mode))))

;; highlight some comments
(add-hook 'c-mode-common-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))

;;; Go into the following modes depending on file extention
(setq auto-mode-alist
      (append '(("\\.C$"   . c++-mode)
                ("\\.cc$"  . c++-mode)
                ("\\.cpp$" . c++-mode)
                ("\\.cxx$" . c++-mode)
                ("\\.hpp$" . c++-mode)
                ("\\.hxx$" . c++-mode)
                ("\\.h$"   . c++-mode)
                ("\\.hh$"  . c++-mode)
                ("\\.idl$" . c++-mode)
                ("\\.c$"   . c-mode)
                ("\\.pl$" . perl-mode)
                ("\\.pm$" . perl-mode)
                ;;                ("\\.py$" . python-mode)
                ;;                ("\\.java$" . java-mode)
                ;;     ("\\.?[Ff][Aa][Qq]$" . faq-mode)
                ("\\.txt$" . text-mode)
                ("\\.org$" . org-mode)
                ("\\.cs$" . csharp-mode)
                ;;                ("\\.js" . js-mode)
                ("\\.[Mm][Aa][Kk]$" . makefile-mode)
                ("\\.g4" . antlr-mode)
                ("[Mm]akefile.*" . makefile-mode))
              auto-mode-alist))

;;(c-set-style "ellemtel") ; set up indentation style

;; (setq interpreter-mode-alist (cons '("python" . python-mode)
;;                                    interpreter-mode-alist))
;; (autoload 'python-mode "python-mode" "Python editing mode." t)

;;; Mail related stuff
;; Some place to put copies for me
;;(setq mail-archive-file-name "~/Mail/my_messages_at_raytheon")
(setq rmail-delete-after-output t)

;;; Set up fill mode
(setq mail-mode-hook          ; do auto fill mode in mail mode
      '(lambda () (auto-fill-mode 1)))
(setq news-reply-mode-hook
      '(lambda ()
         (auto-fill-mode 1)
         (abbrev-mode 1)))
(setq news-post-mode-hook
      '(lambda ()
         (auto-fill-mode 1)
         (abbrev-mode 1)))
(setq news-reply-followup-to-mode-hook
      '(lambda ()
         (auto-fill-mode 1)
         (abbrev-mode 1)))

;;; Set up abbreviation mode
(if (< emacs-major-version 23)
    (progn
      (setq-default abbrev-mode t)
      (cond ((file-exists-p "~/.emacs.d/abbrev_defs")
             (read-abbrev-file "~/.emacs.d/abbrev_defs")))
      (setq save-abbrevs t)))

;;; Set up mail stuff
(setq user-full-name "Sarir Khamsi")
(setq user-mail-address "sarir.khamsi@raytheon.com")
;; (setq smtpmail-default-smtp-server "mailhost.ray.com")
(setq smtpmail-default-smtp-server "us.rmail.ray.com")
(setq smtpmail-local-domain nil)
;;(setq smtpmail-local-domain "mailhost.ray.com")
(setq send-mail-function 'smtpmail-send-it)
(setenv "MAILHOST" "rwsmail25")

;;(load-library "smtpmail")
(put 'eval-expression 'disabled nil)

(if (not (load "repeat-insert" t))
    (sk-message "Error: repeat-insert not found"))

;;; Start off in "home" dir.
(cd (getenv "HOME"))
;;; Show matching parens
(load "paren")
;;; Set up faq-mode
;;(load "faq-mode")
;;; Used to override ls-lisp.el for ls use in dired
;;(load-library "files")
(put 'narrow-to-region 'disabled nil)
;;(require 'custom nil t)

(if (require 'ctypes "ctypes.elc" t)
    (progn
      (setq ctypes-write-types-at-exit t)
      (ctypes-read-file nil nil t t)
      (ctypes-auto-parse-mode 1)))

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(setq dabbrev-case-fold-search nil)

;;; Setup the desktop package.
;;(load "desktop")
(setq sk-desk-top-path (concat (getenv "HOME") "/.emacs.d/desktop"))
(if (not (file-exists-p sk-desk-top-path))
    (make-directory sk-desk-top-path))

(setq desktop-dirname sk-desk-top-path
      desktop-base-file-name "emacs.desktop"
      desktop-base-lock-name "lock"
      desktop-path (list desktop-dirname)
      desktop-save t
      desktop-missing-file-warning nil
      desktop-restore-frames nil
      desktop-files-not-to-save "^$" ;reload tramp paths
      desktop-load-locked-desktop nil)
(desktop-save-mode 1)
;; stuff not to save
(add-to-list 'desktop-modes-not-to-save 'dired-mode)
(add-to-list 'desktop-modes-not-to-save 'Info-mode)
(add-to-list 'desktop-modes-not-to-save 'info-lookup-mode)

;;; Set frame size and position
;;(set-frame-height (selected-frame) (- (/ (x-display-pixel-height) 13) 7))
(set-frame-width (selected-frame) 80)

(when (require 'filladapt "filladapt.elc" t)
  ;;(setq-default filladapt-mode t)
  (add-hook 'text-mode-hook 'turn-on-filladapt-mode))

;; load packages if they exist
(defsubst load-if (package-name)
  (unless (load package-name t)
    (sk-message "Error: %s not found" package-name)))

(load-if "ps-print")
(setq ps-landscape-mode t)
(setq ps-lpr-command "lpr")
(setq ps-print-only-one-header t)
(setq ps-number-of-columns 2)
(setq ps-printer-name "m09lf4x6200c")
(setq ps-line-number t)
(setq ps-left-margin 50)
(setq ps-right-margin 30)

;; setup flyspell-mode for message mode
(if (executable-find "aspell")
    (add-hook 'message-mode-hook '(lambda () (flyspell-mode 1))))

;; subversion
(if (require 'psvn nil t)
    (if (executable-find "aspell")
        (add-hook 'svn-log-edit-mode-hook '(lambda () (flyspell-mode 1)))))

(load-if "htmlize")
;;(load-if "htmlize-view")
;; (htmlize-view-add-to-files-menu)

;;(require 'erc nil t)
;;(require 'sasl nil t)

;;(autoload 'w3 "w3/w3" "WWW Browser" t)
;;(load "emacs-wiki")
;;(require 'wiki nil t)

(autoload 'rs-info-insert-current-node "rs-info"
  "Insert reference to current Info node using STYPE in buffer." t nil)
(autoload 'rs-info-boxquote "rs-info"
  "Yank text (from an info node), box it and use current info node as title."
  t nil)
(autoload 'rs-info-reload "rs-info" "Reload current info node." t nil)
(autoload 'rs-info-insert-node-for-variable "rs-info"
  "Insert a custom style info node for the top level form at point." t nil)
(defalias 'boxquote-info 'rs-info-boxquote)

(when (require 'bbdb nil t)
  (bbdb-initialize 'gnus 'message)
  (setq bbdb-user-mail-names
        (regexp-opt '("sarir_a_khamsi@raytheon.com"
                      "khamsi@raytheon.com"
                      "sarir.khamsi@raytheon.com")))
  ;;cycling while completing email addresses
  (setq bbdb-complete-name-allow-cycling t)
  ;; Hack for posting on foreign servers
  (add-hook 'message-setup-hook 'bbdb-define-all-aliases)
  (setq bbdb-completion-display-record nil)
  (if (file-exists-p sk-bbdb-file)
      (setq bbdb-file sk-bbdb-file))
  (setq bbdb-offer-save (quote savenoprompt))
  ;; (setq gnus-startup-hook (quote (bbdb-insinuate-gnus)))
  ;;No popup-buffers
  (setq bbdb-use-pop-up nil))

;; allow mail aliases for BBDB
;; (DELETE THE NEXT 2 LINES AFTER IT GETS FIXED!)
(defadvice expand-abbrev (before make-sure-things-expand activate)
  (run-hooks 'pre-abbrev-expand-hook))
(load "mailalias")
;;(add-hook 'message-setup-hook 'mail-abbrevs-setup)
;; (eval-after-load
;;     "message"
;;   '(define-key message-mode-map [f12] 'bbdb-complete-name))

;; Hack for posting on foreign servers
(add-hook 'message-setup-hook
          (lambda ()
            (local-set-key "\C-c\C-c" 'message-send-and-exit-with-prefix)))

;; My fancy functions

;;; use C-c C-c in perl to comment out a region
(defun sk-perl-mode-hook ()
  (define-key perl-mode-map "\C-c\C-c" 'comment-region))
(add-hook 'perl-mode-hook 'sk-perl-mode-hook)

(defun sk-scroll-down-in-place (n)
  "Allow the cursor to remain stationary and have the screen move."
  (interactive "p")
  (previous-line n)
  (scroll-down n))

(defun sk-scroll-up-in-place (n)
  "Allow the cursor to remain stationary and have the screen move."
  (interactive "p")
  (next-line n)
  (scroll-up n))

;; expand if block by typing "ifx"
(define-skeleton my-skeleton-c-if
  "Insert a c if statement" nil
  "if (" > _ ")" \n
  "{" '(indent-for-tab-command) \n
  \n
  "}" '(indent-for-tab-command))
(define-abbrev c++-mode-abbrev-table "ifx" "" 'my-skeleton-c-if)

(defun sk-insert-date ()
  "Inserts the current date at point."
  (interactive)
  (insert (format-time-string "%Y-%m-%d")))
;;  (insert (format-time-string "%a %b %d %T %Z %Y")))

;;; Define two functions to bind to function keys for font sizes
(defun sk-large-font ()
  (interactive)
  (set-default-font "-outline-Lucida Console-normal-r-normal-normal-19-142-96-96-c-*-iso8859-1"))
(defun sk-medium-font ()
  (interactive)
  (set-default-font "-outline-Lucida Console-normal-r-normal-normal-16-142-96-96-c-*-iso8859-1"))
(defun sk-small-font ()
  (interactive)
  (set-default-font "-raster-6X13-normal-normal-normal-*-13-*-*-*-c-*-iso8859-1"))
(defun sk-courier-font ()
  (interactive)
  (set-default-font "-outline-Courier New-normal-normal-normal-mono-19-*-*-*-c-*-iso8859-1"))

(defun sk-courier-font-variable (value)
  (interactive "sFont size: ")
  (set-default-font (concat "-outline-Courier New-normal-normal-normal-mono-" value "-*-*-*-c-*-iso8859-1")))
(defun sk-courier-font-variable-bold (value)
  (interactive "sFont size: ")
  (set-default-font (concat "-outline-Courier New-bold-normal-normal-mono-" value "-*-*-*-c-*-iso8859-1")))

(defun sk-large-font-Linux ()
  (interactive)
  (set-default-font "-unknown-DejaVu Sans Mono-normal-normal-normal-*-16-*-*-*-m-0-iso10646-1"))
(defun sk-large-font-variable-Linux (value)
  (interactive "sFont size: ")
  (set-default-font (concat "-unknown-DejaVu Sans Mono-normal-normal-normal-*-" value "-*-*-*-m-0-iso10646-1")))

(defun sk-dejavu ()
  "Does not come with Win 7 distro. See http://dejavu-fonts.org/wiki/Main_Page."
  (interactive)
  (set-default-font "-outline-DejaVu Sans Mono-normal-normal-normal-mono-19-*-*-*-c-*-iso8859-1 (#x0D)"))
(defun sk-dejavu-variable (value)
  "Does not come with Win 7 distro. See http://dejavu-fonts.org/wiki/Main_Page."
  (interactive "sFont size: ")
  (set-default-font (concat "-outline-DejaVu Sans Mono-normal-normal-normal-mono-" value "-*-*-*-c-*-iso8859-1 (#x0D)")))
(defun sk-courier-font-variable (value)
  (interactive "sFont size: ")
  (set-default-font (concat "-outline-Courier New-normal-normal-normal-mono-" value "-*-*-*-c-*-iso8859-1")))
(defun sk-courier-font-variable-bold (value)
  (interactive "sFont size: ")
  (set-default-font (concat "-outline-Courier New-bold-normal-normal-mono-" value "-*-*-*-c-*-iso8859-1")))

(defun sk-width ()
  "Sets the width of a window to 80 columns."
  (interactive)
  (set-frame-width (selected-frame) 80))

;;; Setup functions to allow toggling between quoting args and not
(defun sk-quote-process-args (state)
  (interactive "sState: ")
  (cond ((equal state "t")
         (setq win32-quote-process-args t))
        (not equal (state "t")
             (setq win32-quote-process-args t))))

(defun sk-forward-dec-2-include ()
  "Change a forward declaration to a #include directive."
  (interactive)
  (beginning-of-line)
  (kill-word 1)
  (delete-char 1)
  (insert "#include \"")
  (end-of-line)
  (backward-delete-char-untabify 1)
  (insert ".hpp\""))

(defun sk-change-font-and-return ()
  "Bring up the font selection dialog box and insert the selection
into the current buffer."
  (interactive)
  (insert (prin1-to-string (w32-select-font))))

(defun message-send-and-exit-with-prefix ()
  "Call the message-send-and-exit function with a positive number argument
to make it post the message on the foreign NNTP server of a group, instead
of the default NNTP server"
  (interactive)
  (message-send-and-exit 1))

(defun sk-sponge-mail-address ()
  "Use my mail address as sponge@futureone.com."
  (interactive)
  (setq mail-default-reply-to "Sarir Khamsi <sponge@futureone.com>"
        user-mail-address "sponge@futureone.com"))

(defun sk-chickenphat-mail-address ()
  "Set my email address to my chickenphat one."
  (interactive)
  (setq user-mail-address "chickenphat@gmail.com"))

(defun sk-ray-mail-address ()
  "Use my work mail."
  (interactive)
  (setq mail-default-reply-to "Sarir Khamsi <sarir.khamsi@raytheon.com>"
        user-mail-address "sarir.khamsi@raytheon.com"))

(defun sk-compile ()
  "Switch to compilation buffer, if available, before compiling.  By M. Young."
  (interactive)
  (let ((compile-buf (get-buffer
                      (funcall (or compilation-buffer-name-function
                                   (function (lambda ()
                                               (quote "*compilation*"))))))))
    (if compile-buf
        (switch-to-buffer compile-buf))
    (call-interactively 'compile)))

(defun sk-purge-buffer ()
  "Remove non-local compiler messages.  By M. Young."
  (interactive)
  (point-to-register 'z)
  (goto-char (point-min))
  (delete-matching-lines "warning C4786")
  (goto-char (point-min))
  (delete-matching-lines "see reference to class template instantiation")
  (goto-char (point-min))
  (delete-matching-lines "while compiling class-template member")
  (jump-to-register 'z))

(defun sk-comment-endif ()
  "Automatically comment the matching #endif statement.

Point needs to be on the line where the #if statement is."
  (interactive)
  (save-excursion
    (hide-ifdef-mode 1)
    (beginning-of-line)
    (let (start-pos point))
    (set-mark-command ())
    (end-of-line)
    (copy-region-as-kill (mark) (point))
    (hif-ifdef-to-endif)
    (end-of-line)
    (insert " // ")
    (yank)))

(defun sk-comment-exp ()
  "Automatically comment the matching ending brace.

Point needs to on the line containing the starting brace statement."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (indent-for-tab-command)
    (set-mark-command ())
    (end-of-line)
    (copy-region-as-kill (mark) (point))
    (save-match-data
      (search-forward "{")
      (goto-char (match-beginning 0))
      (forward-sexp)
      (insert " // ")
      (yank))))

(defun sk-format-variables ()
  "Format a list of variable declarations into neat columns."
  (interactive)
  (save-excursion
    (let ((here (point))
          (there (mark))
          (top)
          (bottom)
          (count)
          (column 0))
      (if (< there here)
          (progn
            (setq top there)
            (setq bottom (+ here 1)))
        (setq top here)
        (setq bottom there))
      (goto-char top)
      (while (< (point) bottom)
        (progn
          (beginning-of-line)
          (re-search-forward "[A-Za-z\\*\\&]")
          (search-forward " ")
          (re-search-forward "[A-Za-z\\*\\&]")
          (backward-char)
          (if (> (current-column) column)
              (setq column (current-column)))
          (forward-line)))
      (goto-char top)
      (while (< (point) bottom)
        (progn
          (beginning-of-line)
          (re-search-forward "[A-Za-z\\*\\&]")
          (search-forward " ")
          (re-search-forward "[A-Za-z\\*\\&]")
          (backward-char)
          (insert (make-string (- column (current-column)) 32))
          (forward-line))))))

(defun sk-capit()
  "Turn underscore var and functions into mixed case
 (eg, some_value -> someValue"
  (interactive)
  (save-excursion
    (save-match-data
      (re-search-forward "_[a-z]")
      (backward-char)
      (capitalize-word 1)
      (search-backward "_")
      (delete-char 1))))

(defun sk-netdir()
  "Show only network mapped drives."
  (interactive)
  (require 'widget nil t)
  (let ((drvL))
    (with-temp-buffer
      (shell-command "net use" (current-buffer))
      (while (re-search-forward "[A-Z]: +\\\\\\\\[^ ]+" nil t nil)
        (setq drvL (cons (split-string (match-string 0)) drvL))))
    (pop-to-buffer "*NET DIR LIST*")
    (erase-buffer)
    (widget-minor-mode 1)
    (mapcar
     (lambda (x)
       (lexical-let ((x x))
         (widget-create 'push-button
                        :notify (lambda (widget &rest ignore)
                                  (kill-buffer (current-buffer))
                                  (dired (car x)))
                        (concat (car x) "  " (cadr x))))
       (widget-insert "\n"))
     drvL)))

(defun sk-split-window-recent ()
  "Split the current window and place the previous most recent
buffer in the other window."
  (interactive)
  (split-window)
  (show-buffer (next-window (selected-window))
               (other-buffer)))

(defun sk-grow-frame-height (&optional increment frame)
  "Increase the height of FRAME (default: selected-frame) by INCREMENT.
Interactively, INCREMENT is given by the prefix argument."
  (interactive "p")
  (set-frame-height frame (+ (frame-height frame) increment)))

(defun sk-grow-frame-width (&optional increment frame)
  "Increase the width of FRAME (default: selected-frame) by INCREMENT.
Interactively, INCREMENT is given by the prefix argument."
  (interactive "p")
  (set-frame-width frame (+ (frame-width frame) increment)))

(defun sk-code-to-ps-with-faces (&optional file)
  "Run a couple commands to take a file, ps-spool it with faces and then
run ps-despool on it to write it to disk. If the optional FILE is not
gived, use the current buffer."
  (interactive)
  (save-excursion
    (if file
        (find-file file))
    (ps-spool-buffer-with-faces)
    (ps-despool (concat (buffer-file-name) ".ps"))))

(defun sk-dup-and-comment-region ()
  "Copy the current region and call comment-region on the original."
  (interactive)
  (save-excursion
    (save-match-data
      (if (< (point) (mark))
          (exchange-point-and-mark))
      (kill-ring-save (point) (mark))
      (comment-region (point) (mark))
      (yank)
      (forward-line))))

(defun sk-dup-and-comment-line ()
  "Copy the line and call comment-region on the original."
  (interactive)
  (save-excursion
    (save-match-data
      (move-beginning-of-line nil)
      (set-mark-command ())
      (forward-line)
      (kill-ring-save (point) (mark))
      (comment-region (point) (mark))
      (yank)))
  (forward-line 1))

(defun sk-kill-to-somewhere (&optional endpoint)
  "Kill from point to some other place. If ENDPOINT is non-nil, use the end
of buffer, that is, (point-max)."
  (interactive)
  (let ((end-point (point-max)))
    (if endpoint
        (setq end-point endpoint))
    (kill-region (point) end-point)))

(defun insert-quotes (arg)
  "Enclose following ARG sexps in quotes.  Leave point after open-quote."
  (interactive "P")
  (if arg (setq arg (prefix-numeric-value arg))
    (setq arg 0))
  (cond ((> arg 0) (skip-chars-forward " \t"))
        ((< arg 0) (forward-sexp arg) (setq arg (- arg))))
  (and parens-require-spaces
       (not (bobp))
       (memq (char-syntax (preceding-char)) '(?w ?_ ?\" ))
       (insert " "))
  (insert ?\")
  (save-excursion
    (or (eq arg 0) (forward-sexp arg))
    (insert ?\")
    (and parens-require-spaces
         (not (eobp))
         (memq (char-syntax (following-char)) '(?w ?_ ?\" ))
         (insert " "))))

(define-key global-map [(meta ?\")] 'insert-quotes)

(defun sk-insert-include-guards ()
  "Insert C/C++ include guards in a header file based on filename.

With help from www.nafees.net."
  (interactive)
  (save-excursion
    (let* ((inc-name (replace-regexp-in-string  "\\." "_"
                                                (buffer-name (current-buffer))))
           (file-tag (upcase inc-name))
           )
      (goto-char (point-min))
      (insert (concat "\n#if !defined(" file-tag) ")\n")
      (insert (concat "#define " file-tag "\n"))
      (goto-char (point-max))
      (insert "\n#endif\n"))))

(defun sk-insert-include-guards-worse ()
  "Take the bufer name and insert C/C++ include gaurds."
  (interactive)
  (save-excursion
    (insert (buffer-name))
    (move-beginning-of-line nil)
    (replace-string "." "_")
    (move-beginning-of-line nil)
    (upcase-word 2)
    (move-beginning-of-line nil)
    (kill-line)
    (insert "#if !defined(")
    (yank)
    (insert ")\n#define ")
    (yank)
    (insert "\n")
    (goto-char (point-max))
    (insert "\n#endif\n")))

(defun sk-insert-parens ()
  "Insert left and right parens and backspace one char."
  (interactive)
  (insert "()")
  (backward-char))

(defun sk-wiki-mode ()
  "Set some things up for editing Wiki pages."
  (interactive)
  (filladapt-mode -1)
  (auto-fill-mode -1)
  (if (executable-find "aspell")
      (flyspell-mode 1)))

(defun sk-emacs-uptime ()
  "See how long Emacs has been up."
  (interactive)
  (when (require 'time-date nil t)
    (sk-message "Emacs uptime: %d sec" (time-to-seconds
                                        (time-since sk-emacs-load-start-time)))))

(defun sk-markup-region (markup-tag)
  "Markup a region with some HTML/Wiki MARKUP-TAG."
  (interactive "sTag name: ")
  (save-excursion
    (narrow-to-region (region-beginning) (region-end))
    (goto-char (point-min))
    (insert (concat "<" markup-tag ">"))
    (goto-char (point-max))
    (insert (concat "</" markup-tag ">"))
    (widen)))

(defun sk-build-recent ()
  "Build whatever might my recent project.  In general, change
the (compile) command as needed for the project du jour."
  (interactive)
  (compile "cd c:/cm/xfactor/trunk/Source/App/Sp/Build/Sdk/build/Vs2010/ && \
devenv /debug xfcp.sln /build"))

(defun sk-align-comma-arg-list ()
  "Do a line break and indent for an argument list separated by commas."
  (interactive)
  (search-forward ",")
  (newline-and-indent))

(if (load "gnuserv" t)
    (progn
      (gnuserv-start)
      (defadvice server-edit-files-quickly (before set-gnuserv-frame activate compile)
        "Set gnuserv-frame to current frame"
        (setq gnuserv-frame (selected-frame)))))

(defun sk-add-my-groups ()
  "Set up my Gnus groups."
  (interactive)
  (gnus-group-unsubscribe-group "nnimap+tu2-msg07.raymail.ray.com:INBOX")
  (gnus-group-unsubscribe-group "nnml:Outbox"))

(defun sk-get-all-my-email ()
  "Get all the IMAP email from Gnus."
  (interactive)
  (gnus-summary-rescan-group)
  (gnus-summary-insert-old-articles))

(defun sk-insert-cctor (name)
  "Insert C++ copy ctor and copy assignment op for NAME."
  (interactive "sClass name: ")
  (c-indent-command)
  (insert name "(const " name " &copy);\n")
  (c-indent-command)
  (insert name " &operator=(const " name " &rhs);\n"))

(defun sk-new-python-script ()
  "Create a new Python script."
  (interactive)
  (insert "#!/usr/bin/env python3\n# Sarir Khamsi\n# ")
  (sk-insert-date)
  (insert "\n#\n# $Id") ; split this into two lines so SVN doesn't use $ Id $
  (insert "$\n\ndef main():\n   pass\n\nif __name__ == '__main__':")
  (insert "\n   main()\n")
  (python-mode)
  (set-buffer-file-coding-system 'iso-latin-1-unix)
  (set-file-modes (buffer-file-name) #o755))

(defun sk-new-bash-script ()
  "Insert header stuff for a new bash script."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (insert "#!/usr/bin/env bash\n# Sarir Khamsi\n# ")
    (sk-insert-date)
    (insert "\n#\n# $Id") ; split into two lines so SVN doesn't use $ Id $
    (insert "$\n\n"))
  (set-buffer-file-coding-system 'iso-latin-1-unix)
  (save-buffer)
  (shell-script-mode)
  (set-file-modes (buffer-file-name) #o755))

(defun sk-new-cpp-file ()
  "Insert header stuff for a new C++ file."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (insert "//\n// Sarir Khamsi\n// ")
    (sk-insert-date)
    (insert "\n// $Id") ; split into two lines so SVN doesn't use $ Id $
    (insert "$\n\n"))
  (set-buffer-file-coding-system 'iso-latin-1-unix))

(defun sk-in (name)
  "Insert cout statements around a string NAME."
  (interactive "sString: ")
  (insert (format "std::cout << \"%s\" << std::endl;" name)))

(defun sk-convert-to-ctor-init-list ()
  "Convert a C++ member variable declaration to a ctor init list line.

To use this, copy all member variable declarations into the
constructor's member initialization list area and execute this
command on each line.  At the end of this command, it moves you
to the next line setting it up for a key binding."
  (interactive)
  (save-excursion
    (save-match-data
      (comment-kill 1) ; delete the comment on the line, if there is one
      (forward-line -1)
      ;;      (previous-line)
      (delete-blank-lines)
      (end-of-line)
      (delete-horizontal-space)     ; delete whitespace at end of line
      (backward-delete-char-untabify 1) ; delete the ";"
      (insert "(),")
      (search-backward-regexp "[\t *&]") ; look for whitespace, "&" or "*"
      (let ((beg (+ 1 (point)))) ; set start 1 char forward
        (beginning-of-line)
        (delete-region beg (point)))
      (c-indent-command)))
  (forward-line 1))

(defun sk-duplicate-line ()
  "Duplicate a line.

From http://stackoverflow.com/questions/13140462/tyring-to-create-a-duplicate-line-function-in-elisp"
  (interactive)
  (let* ((pos-end (line-beginning-position 2))
         (line    (buffer-substring (line-beginning-position) pos-end)))
    (goto-char pos-end)
    (unless (bolp) (newline))
    (save-excursion ;; leave point before the duplicate line
      (insert line))))

(defun sk-decl-2-get-set ()
  "Convert a declaration to C++ get/set member functions."
  (interactive)
  (save-excursion
    (save-match-data
      (comment-kill 1)                    ; remove comments, if any
      (previous-line 1)
      (delete-blank-lines)
      (end-of-line)
      (delete-horizontal-space)     ; delete whitespace at end of line
      ;;      (backward-delete-char-untabify 1) ; delete the ";"
      ;;      (search-backward-regexp "[\t *&]") ; look for whitespace, "&" or "*"
      (let ((beg (+ 1 (point)))) ; set start 1 char forward
        (beginning-of-line)
        ;;        (kill-ring-save beg (point))
        (narrow-to-region beg (point))
        (sk-duplicate-line))
      (replace-regexp "\\(.+\\) +\\([a-zA-Z0-9_]+\\);$" "\\1 get_\\2() const \{ return \\2; \}")
      (previous-line 1)
      (beginning-of-line)
      (replace-regexp "^ +\\([a-zA-Z0-9_:&*]+\\) +\\([a-zA-Z0-9_]+\\);$" "void set_\\2(\\1 value) \{ \\2 = value; \}")
      (widen)
      (indent-for-tab-command))))

(defun sk-cap-char (&optional arg)
  "Capitalize the character at point, or downcase char with ARG."
  (interactive "P")
  (save-excursion
    (narrow-to-region (point) (+ 1 (point)))
    (if arg
        (downcase-word 1)
      (upcase-word 1))
    (widen)))

(defun sk-run-current-file ()
  "Execute or compile the current file.
For example, if the current buffer is the file x.pl,
then it'll call perl x.pl in a shell.
The file can be php, perl, python, bash, java.
File suffix is used to determine what program to run.
This function was written by Xah Lee and is taken from
http://xahlee.org/emacs/elisp_run_current_file.html.
Todo: add optional args"
  (interactive)
  ;; get the file name, the program name and run it
  (let (ext-map file-name file-ext prog-name cmd-str)
    (setq ext-map
          '(
            ("php" . "php")
            ("pl" . "perl")
            ("py" . "python")
            ("sh" . "bash")
            ("java" . "javac")
            )                           ; add more as needed
          )
    (setq file-name (buffer-file-name))
    (setq file-ext (file-name-extension file-name))
    (setq prog-name (cdr (assoc file-ext ext-map)))
    (setq cmd-str (concat prog-name " " file-name))
    (shell-command cmd-str)))

(defun sk-add-space-around-equals ()
  "Add a space around equal signs in selected region."
  (interactive)
  (save-excursion
    (save-match-data
      (replace-regexp
       "\\([a-zA-Z0-9_\'\"]+\\)=\\([a-zA-Z0-9_\'\"]+\\)"
       "\\1 = \\2"))))

(defun sk-fix-whitespace-and-indent ()
  "Format code to coding standards.  Delete trailing whitespace, indent, etc."
  (interactive)
  (save-excursion
    (save-match-data
      (untabify (point-min) (point-max))
      (delete-trailing-whitespace)
      (indent-region (point-min) (point-max)))))

(defun sk-remove-space-around-parens ()
  "Remove whitespace around parenthesis."
  (interactive)
  (save-excursion
    (save-match-data
      (goto-char (point-min))
      (while (re-search-forward "\(\\s-+" nil t)
        (replace-match "("))
      (goto-char (point-min))
      (while (re-search-forward "\\s-+\)" nil t)
        (replace-match ")")))))

(defun sk-todo ()
  "Add a new comment that starts with TODO:."
  (interactive)
  (save-excursion
    (comment-dwim nil)
    (delete-horizontal-space)
    (insert " TODO: "))
  (move-end-of-line nil))

(defun sk-ascii-table ()
  "Display basic ASCII table (0 thru 128).
Taken from http://www.emacswiki.org/emacs/AsciiTable by Rick Bielawski."
  (interactive)
  (switch-to-buffer "*ASCII*")
  (erase-buffer)
  (save-excursion (let ((i -1))
                    (insert "ASCII characters 0 thru 127.\n\n")
                    (insert " Hex  Dec  Char|  Hex  Dec  Char|  Hex  Dec  Char|  Hex  Dec  Char\n")
                    (while (< i 31)
                      (insert (format "%4x %4d %4s | %4x %4d %4s | %4x %4d %4s | %4x %4d %4s\n"
                                      (setq i (+ 1  i)) i (single-key-description i)
                                      (setq i (+ 32 i)) i (single-key-description i)
                                      (setq i (+ 32 i)) i (single-key-description i)
                                      (setq i (+ 32 i)) i (single-key-description i)))
                      (setq i (- i 96))))))

(defun sk-remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

;; Common Lisp programming stuff
;; (if (file-exists-p "~/.emacs.d/slime")
;;     (progn
;;       (add-to-list 'load-path "~/.emacs.d/slime") ; your SLIME directory
;;       (setq inferior-lisp-program "c:/usr/cygwin64/bin/clisp") ; your Lisp system
;;       (require 'slime nil t)
;;       (slime-setup)))

;; set up MATLAB mode
(autoload 'matlab-mode "matlab" "Enter MATLAB mode." t)
(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))
(autoload 'matlab-shell "matlab" "Interactive MATLAB mode." t)

;; set up cmake mode
(if (require 'cmake-mode nil t)
    (setq auto-mode-alist
          (append '(("CMakeLists\\.txt\\'" . cmake-mode)
                    ("\\.cmake\\'" . cmake-mode))
                  auto-mode-alist)))

;; load VM, if it exists
(if (file-exists-p "~/.emacs.d/vm")
    (progn
      (add-to-list 'load-path (expand-file-name "~/.emacs.d/vm/lisp"))
      (add-to-list 'Info-default-directory-list
                   (expand-file-name "~/.emacs.d/vm/info"))))
(require 'vm-autoloads nil t)
(if (file-exists-p "~/.vm")
    (load-file "~/.vm"))

;;(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(defun sk-bind-clb ()
  "Bind c-context-line-break to C-j."
  (define-key c-mode-base-map "\C-j" 'c-context-line-break))
(add-hook 'c-initialization-hook 'sk-bind-clb)

(defun sk-transparency (value)
  "Sets the transparency of the frame window. 0=transparent/100=opaque, negative to modify all frames"
  (interactive "nTransparency Value 0 - 100 opaque, negative for all frames: ")
  (if (> value 0)
      (set-frame-parameter nil 'alpha value)
    (setq value (abs value))
    (setq sk-current-frames (frame-list))
    (while sk-current-frames
      (set-frame-parameter (car sk-current-frames) 'alpha value)
      (setq sk-current-frames (cdr sk-current-frames)))))

(defun sk-unfill-paragraph ()
  "Takes a multi-line paragraph and makes it into a single line of text.
Taken from http://www.emacswiki.org/emacs/UnfillParagraph."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(defun sk-unfill-region (beg end)
  "Unfill the region, joining text paragraphs into a single
    logical line.  This is useful, e.g., for use with
    `visual-line-mode'."
  (interactive "*r")
  (let ((fill-column (point-max)))
    (fill-region beg end)))

(defvar sk-toggle-text-mode-filling t
  "Toggle text mode fill stuff.")

(defun sk-toggle-text-mode-stuff (&optional arg)
  "Toggle all the text mode stuff I care about."
  (interactive)
  (if sk-toggle-text-mode-filling
      (progn
        (setq sk-toggle-text-mode-filling (not sk-toggle-text-mode-filling))
        (if (executable-find "aspell")
            (flyspell-mode nil))
        (auto-fill-mode -1)
        (filladapt-mode nil))
    (progn
      (setq sk-toggle-text-mode-filling (not sk-toggle-text-mode-filling))
      (if (executable-find "aspell")
          (flyspell-mode t))
      (auto-fill-mode t)
      (filladapt-mode t))))

(defun sk-toggle-trailing-whitespace-mode ()
  "Toggle trailing whitespace mode."
  (interactive)
  (setq-default show-trailing-whitespace (if (eq show-trailing-whitespace t)
                                             nil
                                           t)))

(defun sk-toggle-line-move-visual ()
  "Toggle behavior of up/down arrow key, by visual line vs logical line. Thanks to Xah Lee for the code"
  (interactive)
  (setq line-move-visual (not line-move-visual)))

(defun sk-doxygen-2-qt-style ()
  "Convert doxymacs comments into Qt-style."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((comment-start (search-forward "/**"))
          (comment-end (search-forward "*/")))
      (goto-char (point-min))
      (replace-regexp "^\\([ ]+\\)\\*/?\\|/\\*\\*" "\\1//!")
      (indent-region comment-start (+ comment-end 20)))))

(defvar sk-toggle-minor-mode-extras t
  "Toggle some less-important modeline things.")

(defun sk-toggle-some-mode-line-crap()
  "Toggle some things in mode line."
  (interactive)
  (if sk-toggle-minor-mode-extras
      (progn
        (column-number-mode -1)
        (line-number-mode -1)
        (display-time-mode 0)
        (setq sk-toggle-minor-mode-extras nil))
    (progn
      (column-number-mode 1)
      (line-number-mode 1)
      (display-time-mode t)
      (setq sk-toggle-minor-mode-extras t))))

(defvar sk-toggle-line-and-column-in-mode-line t
  "Toggle line and column stuff in modeline.")

(defun sk-toggle-line-and-column-mode()
  "Toggle line and column stuff in mode line."
  (interactive)
  (if sk-toggle-line-and-column-in-mode-line
      (progn
        (column-number-mode -1)
        (line-number-mode -1)
        (setq sk-toggle-line-and-column-in-mode-line nil))
    (progn
      (column-number-mode 1)
      (line-number-mode 1)
      (setq sk-toggle-line-and-column-in-mode-line t))))

(defvar sk-toggle-menu-bar nil
  "Toggle the menu bar.")

(defun sk-toggle-menu-bar()
  "Toggle the...menu bar."
  (interactive)
  (if menu-bar-mode
      (menu-bar-mode -99)
    (menu-bar-mode 1)))

(defvar sk-toggle-debug-on-error
  debug-on-error
  "Toggle the 'debug-on-error' variable.")
(defun sk-toggle-debug-on-error ()
  "Toggle the 'debug-on-error' variable."
  (interactive)
  (setq sk-toggle-debug-on-error (not sk-toggle-debug-on-error))
  (setq debug-on-error sk-toggle-debug-on-error))

(require 'remember nil t)

(defun sk-set-rms-proxy (value)
  "Set up a proxy for things like list-packages.

With an argument, clear proxy variables."
  (interactive "p")
  (let ((proxy_string "http://proxy.ext.ray.com:80"))
    (if value
        (setq proxy_string ""))
    (setenv "http_proxy" proxy_string)
    (setenv "https_proxy" proxy_string)
    (setenv "HTTPS_PROXY" proxy_string)
    (setenv "HTTP_PROXY" proxy_string)
    (setenv "ftp_proxy" proxy_string)
    (setenv "FTP_PROXY" proxy_string)))

(defun sk-set-nntp-host ()
  "Set the NNTP host for external news."
  (interactive)
  (setq gnus-select-method '(nntp "news.west.earthlink.net")))

(defun sk-find-non-ascii ()
  "Find any non-ascii characters in the current buffer.

Thanks http://www.emacswiki.org/emacs/FindingNonAsciiCharacters"
  (interactive)
  (occur "[^[:ascii:]]"))

(defun sk-add-windows-emacs-to-path ()
  "Add the path to the Windows Emacs before other stuff."
  (interactive)
  (setenv "PATH" (concat "c:\\usr\\emacs\\bin;" (getenv "PATH")))
  (setq exec-path (append '("c:/usr/emacs/bin") exec-path)))

(if (require 'doxymacs nil t)
    (progn
      (add-hook 'c-mode-common-hook 'doxymacs-mode)
      (defun my-doxymacs-font-lock-hook ()
        (if (or (eq major-mode 'c-mode) (eq major-mode 'c++-mode))
            (doxymacs-font-lock)))
      (add-hook 'font-lock-mode-hook 'my-doxymacs-font-lock-hook)))

;; fancy CMake mode
(if (require 'cmake-mode nil t)
    (setq auto-mode-alist
          (append
           '(("CMakeLists\\.txt\\'" . cmake-mode))
           '(("\\.cmake\\'" . cmake-mode))
           auto-mode-alist)))

;; C# crap
;;(require 'csharp-mode nil t) ; has problems in emacs 24.0.x

(if (require 'xcscope nil t)
    (setq cscope-do-not-update-database t))

;; haskell-mode stuff
(if sk-winnt-p
    (defconst sk-haskell-path "c:/cm/github/haskell-mode" "Haskell path")
  (defconst sk-haskell-path "~/cm/github/haskell-mode" "Haskell path"))
(if (file-exists-p sk-haskell-path)
    (progn
      (add-to-list 'load-path sk-haskell-path)
      (require 'haskell-mode-autoloads nil t)
      (add-to-list 'Info-default-directory-list sk-haskell-path)))

(put 'narrow-to-page 'disabled nil)

(autoload 'php-mode "php-mode" "Major mode for editing php code." t)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))

;; Git support
(if (file-exists-p sk-magit-path)
    (progn
      (add-to-list 'load-path sk-magit-path)
      (if (require 'magit nil t)
          (progn
            (global-set-key [M-f1] (quote magit-status))
            (if (executable-find "aspell")
                (add-hook 'magit-log-edit-mode-hook
                          '(lambda () (flyspell-mode 1))))))))

;; ;; Comment out on 2014-10-20
;; ;; semantic stuff
;; ;; did this 2013-11-06
;; (semantic-mode 1)
;; ;; (global-semantic-highlight-func-mode 1)
;; ;; (global-ede-mode 1)
;; (require 'semantic/analyze nil t)
;; (provide 'semantic-analyze)
;; (provide 'semantic-ctxt)
;; (provide 'semanticdb)
;; (provide 'semanticdb-find)
;; (provide 'semanticdb-mode)
;; (provide 'semantic-load)

;;(global-semantic-idle-summary-mode 1)

(defun sk-switch-to-tmp-buffer-with-date ()
  "Create a tmp buffer, prefixed with current date, and switch to it."
  (interactive)
  (switch-to-buffer (concat (format-time-string "%Y-%m-%d_")
                            (make-temp-name "scratch"))))

(defun sk-switch-to-tmp-buffer ()
  "Create a tmp buffer and switch to it."
  (interactive)
  (switch-to-buffer (make-temp-name "scratch")))

(defun sk-require-flymake ()
  "Startup stuff for flymake."
  (interactive)
  (when (require 'flymake nil t)
    ;; these are optional
    (add-hook 'find-file-hook 'flymake-find-file-hook)
    (global-set-key [M-f3] 'flymake-display-err-menu-for-current-line)
    (global-set-key [M-f4] 'flymake-goto-next-error)))

(defun sk-remove-flymake-hook ()
  "Remove the flymake function from the 'find-file-hook'."
  (interactive)
  (remove-hook 'find-file-hook 'flymake-find-file-hook)
  (remove-hook 'java-mode-hook 'flymake-mode-on))

(defun sk-insert-smiley ()
  "Insert a smiley into the current buffer at point."
  (interactive)
  (insert ":-)"))

(defun sk-insert-filename (&optional BUFFER)
  "Insert the name of the current file into the current buffer."
  (interactive "b")
  (insert (buffer-name (or (get-buffer BUFFER) (current-buffer)))))

(defun sk-cpp2xml ()
  "Convert a line of C++ variable declaration to CMAT XML."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (set-mark-command ())
    (end-of-line)
    (replace-regexp "^ *\\(.*\\) +\\(.*\\);.*$"
                    "<struct_item>\n<item_name>\\2</item_name>\n<type>\\1</type>\n</struct_item>" nil (mark) (point)))
  (next-line 4))

(defun sk-devel-setup ()
  "Place Emacs in a state for development."
  (interactive)
  (when (string-equal (system-name) sk-laptop-hostname)
    (menu-bar-mode -1))
  (make-frame-command)
  (set-frame-position (next-frame) 800 5)
  (sk-transparency -96)
  (other-frame 1) ; go to the other frame to turn off scroll bar
  (toggle-scroll-bar -1))
;;  (scoll-bar-mode -1))

(defun sk-search-google ()
  "Googles a query or region if any.

By http://batsov.com/articles/2011/11/19/why-emacs/"
  (interactive)
  (browse-url
   (concat
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
    (if mark-active
        (buffer-substring (region-beginning) (region-end))
      (read-string "Google: ")))))

;; Move border left or right
;; http://www.emacswiki.org/emacs/GrowShrinkWindows
(defun xor (b1 b2)
  "Exclusive or of its two arguments."
  (or (and b1 b2)
      (and (not b1) (not b2))))

(defun sk-insert-percent-bullet()
  "Insert ' - [ ] ' in the current location at point."
  (interactive)
  (insert " - [ ] "))

(defun move-border-left-or-right (arg dir)
  "General function covering move-border-left and move-border-right. If DIR is
     t, then move left, otherwise move right."
  (interactive)
  (if (null arg) (setq arg 5))
  (let ((left-edge (nth 0 (window-edges))))
    (if (xor (= left-edge 0) dir)
        (shrink-window arg t)
      (enlarge-window arg t))))

(defun move-border-left (arg)
  "If this is a window with its right edge being the edge of the screen, enlarge
     the window horizontally. If this is a window with its left edge being the edge
     of the screen, shrink the window horizontally. Otherwise, default to enlarging
     horizontally.

     Enlarge/Shrink by ARG columns, or 5 if arg is nil."
  (interactive "P")
  (move-border-left-or-right arg t))

(defun move-border-right (arg)
  "If this is a window with its right edge being the edge of the screen, shrink
     the window horizontally. If this is a window with its left edge being the edge
     of the screen, enlarge the window horizontally. Otherwise, default to shrinking
     horizontally.

     Enlarge/Shrink by ARG columns, or 5 if arg is nil."
  (interactive "P")
  (move-border-left-or-right arg nil))

(global-set-key (kbd "M-[") 'move-border-left)
(global-set-key (kbd "M-]") 'move-border-right)

(defvar sk-toggle-summary-flag 1
  "Toggle semantic summary mode stuff.")

(defun sk-toggle-summary ()
  "Just call global-semantic-idle-summary-mode"
  (interactive)
  (if (> sk-toggle-summary-flag 0)
      (setq sk-toggle-summary-flag 0)
    (setq sk-toggle-summary-flag 1))
  (global-semantic-idle-summary-mode sk-toggle-summary-flag)
  (sk-message "Semantic summary mode is %s"
              (if (eq sk-toggle-summary-flag 1) "on" "off")))

(defvar sk-toggle-help-at-pt t "Toggle help at point stuff.")
(defvar sk-help-at-pt-timer-delay 0.1 "The delay time for help-at-pt.")

(defun sk-pwd()
  "Get the current working dir for the file you are in."
  (interactive)
  (file-name-directory (buffer-file-name)))

(defun sk-toggle-help-at-pt ()
  "Toggle help at point."
  (interactive)
  (setq sk-toggle-help-at-pt (not sk-toggle-help-at-pt))
  (sk-message "Help at point is %s" (if sk-toggle-help-at-pt "on" "off"))
  (setq help-at-pt-display-when-idle sk-toggle-help-at-pt)
  (setq help-at-pt-timer-delay sk-help-at-pt-timer-delay)
  (help-at-pt-set-timer))

(defun sk-find-first-non-ascii-char ()
  "Find the first non-ascii character from point onwards."
  (interactive)
  (let (point)
    (save-excursion
      (setq point
            (catch 'non-ascii
              (while (not (eobp))
                (or (eq (char-charset (following-char))
                        'ascii)
                    (throw 'non-ascii (point)))
                (forward-char 1)))))
    (if point
        (goto-char point)
      (sk-message "No non-ascii characters."))))

(defun sk-new-org-file ()
  "Insert stuff for an Org mode file."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (insert "#+TITLE: \n#+AUTHOR: Sarir Khamsi\n#+DATE: ")
    (sk-insert-date)
    (insert "\n#+OPTIONS: ^:nil email:t H:6 ^:{}\n")
    (insert "# Ignore stuff above this line\n\n")
    (goto-char (point-max))
    (insert "\n# Ignore stuff below this line\n#\n# Local variables:\n")
    (insert "# mode: org\n# End:\n")
    (set-buffer-file-coding-system 'iso-latin-1-unix))
  (org-mode))

(defun sk-insert-notes-date ()
  "Insert a dash, date, and colon."
  (interactive)
  (insert "- ")
  (sk-insert-date)
  (move-end-of-line nil)
  (insert ": "))

(defun sk-google ()
  "Google the selected region if any, display a query prompt otherwise."
  (interactive)
  (browse-url
   (concat
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
    (url-hexify-string (if mark-active
                           (buffer-substring (region-beginning) (region-end))
                         (read-string "Google search: "))))))

(defun sk-insert-html-table-attribute ()
  "Insert the HTML attibute string for Org mode tables."
  (interactive)
  (insert "#+ATTR_HTML: :border 2 :rules all :frame border"))

(defun sk-cleanup-and-exit ()
  "Run some cleanup code and exit Emacs."
  (interactive)
  (sk-kill-dired-directory-buffers)
  (save-buffers-kill-terminal))

(defun sk-insert-newlines-to-inline-function ()
  "Add newlines to a C++ inline like: void f() { /* do it */ }."
  (interactive)
  (save-excursion
    (move-beginning-of-line nil)
    (c-indent-line-or-region)
    (search-forward "{")
    (backward-char)
    (newline-and-indent)
    (forward-char)
    (newline-and-indent)
    (move-end-of-line nil)
    (backward-char)
    (newline-and-indent)))

(require 'textlint nil t)

;; org stuff
(setq
 org-src-fontify-natively t
 org-export-allow-bind-keywords t
 org-export-allow-BIND-local t
 org-export-html-postamble nil
 org-src-preserve-indentation t
 )
(org-babel-do-load-languages
 'org-babel-load-languages
 '((makefile . t)))

(defun sk-add-mutiple-functions-2-hook (functions hook)
  "Add multiple FUNCTIONS to hooks."
  (mapc (lambda (function)
          (add-hook hook function)) functions))

;; Add org-mode-only key bindings
(sk-add-mutiple-functions-2-hook (list (lambda ()
                                         (local-set-key
                                          (kbd "C-c C-h")
                                          #'sk-insert-html-table-attribute))
                                       (lambda ()
                                         (local-set-key
                                          (kbd "C-c C--")
                                          #'sk-insert-percent-bullet))
                                       (lambda ()
                                         (local-set-key
                                          (kbd "C-C C-:")
                                          #'sk-insert-notes-date))
                                       (lambda ()
                                         (local-set-key
                                          (kbd "C-c C-h")
                                          #'sk-insert-notes))) 'org-mode-hook)

;;(setq org-beamer-frame-default-options "[allowframebreaks]")
;; allow for export=>beamer by placing

;; #+LaTeX_CLASS: beamer in org files
(unless (boundp 'org-export-latex-classes)
  (setq org-export-latex-classes nil))

(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (sh . t)
   (python . t)
   (R . t)
   (ruby . t)
   (ditaa . t)
   (dot . t)
   (octave . t)
   (sqlite . t)
   (perl . t)
   ))

(add-to-list 'org-export-latex-classes
             ;; beamer class, for presentations
             '("beamer"
               "\\documentclass[11pt]{beamer}\n
      \\mode<{{{beamermode}}}>\n
      \\usetheme{{{{beamertheme}}}}\n
      \\usecolortheme{{{{beamercolortheme}}}}\n
      \\beamertemplateballitem\n
      \\setbeameroption{show notes}
      \\usepackage[T1]{fontenc}\n
      \\usepackage{hyperref}\n
      \\usepackage{color}
      \\usepackage{listings}
      \\lstset{numbers=none,language=[ISO]C++,tabsize=4,
  frame=single,
  basicstyle=\\small,
  showspaces=false,showstringspaces=false,
  showtabs=false,
  keywordstyle=\\color{blue}\\bfseries,
  commentstyle=\\color{red},
  }\n
      \\usepackage{verbatim}\n
      \\institute{{{{beamerinstitute}}}}\n
       \\subject{{{{beamersubject}}}}\n"

               ("\\section{%s}" . "\\section*{%s}")

               ("\\begin{frame}[fragile]\\frametitle{%s}"
                "\\end{frame}"
                "\\begin{frame}[fragile]\\frametitle{%s}"
                "\\end{frame}")))

;; letter class, for formal letters

(add-to-list 'org-export-latex-classes

             '("letter"
               "\\documentclass[11pt]{letter}\n
      \\usepackage[T1]{fontenc}\n
      \\usepackage{color}"

               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;;(require 'quack nil t)

(when (require 'which-func nil t)
  (add-to-list 'which-func-modes 'org-mode)
  ;;      (add-to-list 'which-func-modes 'java-mode)
  (which-func-mode 1))

;; I seem to need this for exporting to LaTeX in my notes
(add-to-list 'org-export-latex-classes
             '("article"
               "\\documentclass{article}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; Emacs GPG
;;(require 'epa-file nil t)

;; (autoload 'jde-mode "jde" "JDE mode" t)

;; (when (file-exists-p "~/.emacs.d/auto-java-complete/")
;;   (add-to-list 'load-path "~/.emacs.d/auto-java-complete/")
;;   (when (require 'ajc-java-complete-config nil t)
;;     (add-hook 'java-mode-hook 'ajc-java-complete-mode)
;;     (add-hook 'find-file-hook 'ajc-4-jsp-find-file-hook)))

;; for editing dog-piss Windows batch files
(require 'batch-mode nil t)

;;(require 'flymake nil t)
(defun sk-flymake-init ()
  "Do flymake stuff in Java mode."
  (list "sk-java-flymake-checks"
        (list (flymake-init-create-temp-buffer-copy
               'flymake-create-temp-with-folder-structure))))
;; (add-to-list 'flymake-allowed-file-name-masks
;;              '("\\.java$" sk-flymake-init flymake-simple-cleanup))

(defun sk-my-java-flymake-init ()
  (list "javac" (list (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-with-folder-structure))))

(defun sk-flymake-init-4-java ()
  "Startup flymake for Java."
  (interactive)
  (when (require 'flymake)
    (set-variable 'flymake-log-level 9)
    (add-hook 'java-mode-hook 'flymake-mode-on)
    (add-to-list 'flymake-allowed-file-name-masks
                 '("\\.java$" sk-my-java-flymake-init flymake-simple-cleanup))))

(defun sk-get-variable-name(s)
  (car (split-string (car (last (split-string s " "))) ";")))

(defun sk-kill-dired-directory-buffers ()
  "From http://www.emacswiki.org/emacs/KillingBuffers#toc3"
  (interactive)
  (mapc (lambda (buffer)
          (when (eq 'dired-mode (buffer-local-value 'major-mode buffer))
            (kill-buffer buffer)))
        (buffer-list)))

(defun sk-fix-opening-curly-brace (&optional arg)
  "If a curly brace is on the same line as a construct, add a newline.

With prefix arg indent the buffer."
  (interactive "P")
  (save-excursion
    (replace-regexp "\) *{[^}0-9-a-zA-Z_ ]" "\)\n{\n" nil
                    (point-min)
                    (point-max))
    (if arg (indent-region (point-min) (point-max)))))

(defun sk-insert-try-catch ()
  "Insert a try/catch block around the region for C++ or Java."
  (interactive)
  (save-excursion
    (narrow-to-region (region-beginning) (region-end))
    (goto-char (region-end))
    (insert "}\ncatch ()\n{\n}\n")
    (goto-char (point-min))
    (insert "try\n{\n")
    (indent-region (point-min) (point-max)
                   (widen))))

(defun sk-set-emacs-path ()
  "Set the path to the Windows GNU Emacs before other stuff."
  (interactive)
  (when sk-winnt-p
    (setq exec-path (append '("c:\\usr\\emacs\\bin") exec-path))
    (setenv "PATH" (concat '("c:\\usr\\emacs\\bin") (getenv "PATH")))
    (setq load-path
          (cons (expand-file-name "c:\\usr\\emacs\\bin") load-path))))

(defun sk-toggle-scroll-bar ()
  "Toggle the scroll-bar."
  (interactive)
  (if scroll-bar-mode
      (set-scroll-bar-mode nil)
    (set-scroll-bar-mode sk-orig-scroll-bar-mode)))

(defun sk-camelcase-word-at-point ()
  "Transform some_other_variable into someOtherVariable."
  (interactive)
  (save-excursion
    (let*
        ((sk-bounds (bounds-of-thing-at-point 'filename))
         (sk-car-bounds (car sk-bounds))
         (sk-cdr-bounds (cdr sk-bounds))
         (sk-orig-var-name (buffer-substring sk-car-bounds sk-cdr-bounds))
         (sk-split-parts (split-string sk-orig-var-name "_")))
      (kill-region sk-car-bounds sk-cdr-bounds)
      (insert (apply #'concat (car sk-split-parts) (mapcar
                                                    (lambda (x) (capitalize x))
                                                    (cdr sk-split-parts)))))))

(when (file-exists-p sk-multiple-cursors-path)
  (add-to-list 'load-path sk-multiple-cursors-path))
;;(when (require 'multiple-cursors nil t)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(require 'dos nil t)

(when (file-exists-p sk-markdown-path)
  (add-to-list 'load-path sk-markdown-path)
  (autoload 'markdown-mode "markdown-mode"
    "Major mode for editing Markdown files" t)
  (add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode)))

(if (file-exists-p "/usr/bin/pandoc")
    (setq markdown-command "/usr/bin/pandoc"))

;; (when (file-exists-p sk-mediawiki-path)
;;   (add-to-list 'load-path sk-mediawiki-path)
;;   (require 'ox-mediawiki nil t))

;; TODO
;; - zlib library not found
;; - Error: (file-error "Cannot open load file" "no such file or
;;   directory" "tex-site")

;;(setq image-library-alist (cons '("png" . "libpng16.dll.a") image-library-alist))

(setq auto-mode-alist
      (cons '("\\.\\(pde\\|ino\\)$" . arduino-mode) auto-mode-alist))
(autoload 'arduino-mode "arduino-mode" "Arduino editing mode." t)

(when (require 'message-outlook nil t)
  (setq mail-user-agent 'message-user-agent)
  (setq compose-mail-user-agent-warnings nil))

(when (and (featurep 'yasnippet) (featurep 'auto-complete))
  (define-key yas-minor-mode-map (kbd "<tab>") nil)
  (define-key yas-minor-mode-map (kbd "TAB") nil)
  (define-key yas-minor-mode-map (kbd "<C-tab>") 'yas-expand))
