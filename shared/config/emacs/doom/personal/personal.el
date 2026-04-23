;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; DO NOT USE THIS FILE. Use ../config.el instead
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; -*-Emacs-Lisp-*-
;; ;; This file is designed to be re-evaled; use the variable first-time
;; ;; to avoid any problems with this.
;; ;; (defvar first-time t
;; ;;   "Flag signifying this is the first time that .emacs has been evaled")

;; ;; ;; Supress the GNU startup message
;; ;; (setq inhibit-startup-message t)

;; (package-initialize)
;; (setq package-enable-at-startup nil)

;; (require 'use-package)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; paths
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq exec-path-from-shell-check-startup-files nil)

;; (let ((path (shell-command-to-string ". ~/.zshrc; echo -n $PATH")))
;;   (setenv "PATH" path)
;;   (setq exec-path
;;         (append
;;          (split-string-and-unquote path ":")
;;          exec-path)))

;; ;;; emacs exec path
;; (add-to-list 'load-path "~/.config/doom/personal")

;; ;; ;; Require Common Lisp. (cl in <=24.2, cl-lib in >=24.3.)
;; ;; (if (require 'cl-lib nil t)
;; ;;   (progn
;; ;;     (defalias 'cl-block-wrapper 'identity)
;; ;;     (defalias 'member* 'cl-member)
;; ;;     (defalias 'adjoin 'cl-adjoin))
;; ;;   ;; Else we're on an older version so require cl.
;; ;;   (require 'cl))


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; Benchmark startup time load
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; (require 'benchmark-init)
;; ;; (benchmark-init/activate)



;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; ;;; Prelude
;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; (load-file "~/.emacs.d/init.el")
;; ;; (setq prelude-guru nil)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; basic configs
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (setq-default fill-column 85)
;; (require 'me)

;; ;; (setq bell-volume nil)
;; ;; (setq visible-bell nil)
;; ;; (setq sound-alist nil)
;; ;; (setq ring-bell-function 'ignore)
;; ;; (setq visible-bell 'top-bottom)
;; (setq ring-bell-function 'ignore)


;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; ;;; windows mode
;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (load-theme 'monokai t)
;; ;; (if (display-graphic-p)
;; ;;     (progn
;; ;;       (scroll-bar-mode -1)
;; ;;       (desktop-save-mode 1)
;; ;;       (require 'windows)
;; ;;       (win:startup-with-window)
;; ;;       (define-key ctl-x-map "C" 'see-you-again))
;; ;;   (progn
;; ;;     (when (eq system-type 'darwin)
;; ;;       (require 'mouse)
;; ;;       (xterm-mouse-mode t)
;; ;;       (defun track-mouse (e))
;; ;;       (setq mouse-sel-mode t))
;; ;;     (global-hl-line-mode 0)
;; ;;     (desktop-save-mode 0)))

;; (defun scroll-up-1-lines ()
;;   "Scroll up 1 lines"
;;   (interactive)
;;   (scroll-up 1))

;; (defun scroll-down-1-lines ()
;;   "Scroll down 1 lines"
;;   (interactive)
;;   (scroll-down 1))

;; (global-set-key (kbd "<mouse-4>") 'scroll-down-line) ;
;; (global-set-key (kbd "<mouse-5>") 'scroll-up-line) ;



;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; configs
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; ;; Command is meta in OS X.
;; (setq ns-command-modifier 'hyper)
;; (setq ns-option-modifier 'meta) ; sets the Option key as Hyper
;; (setq ns-function-modifier 'super) ; sets the Option key as Super

;; (setq mac-command-modifier 'hyper) ; sets the Command key as Meta
;; (setq mac-option-modifier 'meta) ; sets the Option key as Hyper

;; (setq mac-pass-command-to-system nil)

;; ;;
;; ;;(spacemacs/toggle-camel-case-motion-globally-on)

;; (global-unset-key (kbd "<magnify-up>"))
;; (global-unset-key (kbd "<magnify-down>"))



;; ;; ;; line numbers in margin
;; ;; ;;(global-linum-mode 1)


;; (global-set-key "\M-g" 'goto-line)
;; (global-set-key (kbd "H-<backspace>") 'backward-kill-word)
;; (global-set-key (kbd "M-X") 'helm-M-x)
;; (global-set-key (kbd "C-M-j") 'helm-semantic-or-imenu)
;; (global-set-key (kbd "M-SPC") 'just-one-space)


;; (global-set-key (kbd "H-h f") 'helm-find-files)
;; (global-set-key (kbd "H-h o") 'helm-occur)
;; (global-set-key (kbd "H-h j") 'helm-imenu-in-all-buffers)
;; (global-set-key (kbd "H-h r") 'helm-resume)
;; (global-set-key (kbd "H-h M-x") 'helm-M-x)
;; (global-set-key (kbd "C-S-d") 'c-hungry-delete-forward)

;; ;;; evil numbers
;; (require 'evil-numbers)
;; (global-set-key (kbd "C-c n +") 'evil-numbers/inc-at-pt)
;; (global-set-key (kbd "C-c n -") 'evil-numbers/dec-at-pt)


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; windmove
;; (global-set-key (kbd "M-<left>") 'windmove-left)
;; (global-set-key (kbd "M-<right>") 'windmove-right)
;; (global-set-key (kbd "M-<up>") 'windmove-up)
;; (global-set-key (kbd "M-<down>") 'windmove-down)

;; ;; to work with tmux
;; (global-set-key (kbd "ESC <left>") 'windmove-left)
;; (global-set-key (kbd "ESC <right>") 'windmove-right)
;; (global-set-key (kbd "ESC <up>") 'windmove-up)
;; (global-set-key (kbd "ESC <down>") 'windmove-down)


;; ;; ;; Function keys
;; ;; (global-set-key [f1] 'manual-entry)
;; ;; (global-set-key [f2] 'info)
;; ;; (global-set-key [f3] 'repeat-complex-command)
;; ;; (global-set-key [f4] 'advertised-undo)
;; ;; (global-set-key [f5] 'eval-current-buffer)
;; ;; (global-set-key [f6] 'buffer-menu)
;; ;; (global-set-key [f7] 'other-window)
;; ;; ;(global-set-key [f8] 'find-file)
;; ;; (global-set-key [f9] 'save-buffer)
;; ;; (global-set-key [f10] 'next-error)
;; ;; (global-set-key [f11] 'compile)
;; ;; (global-set-key [f12] 'grep)
;; ;; (global-set-key [C-f1] 'compile)
;; ;; (global-set-key [C-f2] 'grep)
;; ;; (global-set-key [C-f3] 'next-error)
;; ;; (global-set-key [C-f4] 'previous-error)
;; ;; (global-set-key [C-f5] 'display-faces)
;; ;; (global-set-key [C-f8] 'dired)
;; ;; (global-set-key [C-f10] 'kill-compilation)
;; ;; (global-set-key [C-M-tab] 'indent-all)

;; ;; ;; Keypad bindings
;; ;; (global-set-key [up] "\C-p")
;; ;; (global-set-key [down] "\C-n")
;; ;; (global-set-key [left] "\C-b")
;; ;; (global-set-key [right] "\C-f")
;; ;; (global-set-key [home] "\C-a")
;; ;; (global-set-key [end] "\C-e")
;; ;; (global-set-key [prior] "\M-v")
;; ;; (global-set-key [next] "\C-v")
;; ;; (global-set-key [C-up] "\M-\C-b")
;; ;; (global-set-key [C-down] "\M-\C-f")
;; ;; (global-set-key [C-left] "\M-b")
;; ;; (global-set-key [C-right] "\M-f")
;; ;; (global-set-key [C-home] "\M-<")
;; ;; (global-set-key [C-end] "\M->")
;; ;; (global-set-key [C-prior] "\M-<")
;; ;; (global-set-key [C-next] "\M->")




;; ;; ;; Mouse
;; ;; (global-set-key [mouse-3] 'imenu)

;; ;; ;; Misc
;; ;; (global-set-key [C-tab] "\C-q\t")   ; Control tab quotes a tab.
;; ;; (setq backup-by-copying-when-mismatch t)

;; ;; ;; Treat 'y' or <CR> as yes, 'n' as no.
;; ;; (fset 'yes-or-no-p 'y-or-n-p)
;; ;; (define-key query-replace-map [return] 'act)
;; ;; (define-key query-replace-map [?\C-m] 'act)

;; ;;; spacemacs overrides
;; (define-key evil-emacs-state-map (kbd "C-z") nil)

;; ;; remove C-z to minimize cause it is annoying
;; (global-set-key "\C-Z" nil)
;; (global-set-key (kbd "C-M-z") 'suspend-frame)

;; ;; ;; align according to regexp
;; (global-set-key (kbd "C-x a r") 'align-regexp)
;; (global-set-key (kbd "C-x O") 'previous-multiframe-window)



;; ;; ;; Get backspace key to work properly on many machines.
;; ;; (setq term-setup-hook
;; ;;       '(lambda()
;; ;;          (setq keyboard-translate-table "\C-@\C-a\C-b\C-c\C-d\C-e\C-f\C-g")
;; ;;          (global-set-key "\M-h" 'help-for-help)))




;; ;; ;; ========== Place Backup Files in Specific Directory ==========
;; ;;  ;; Enable backup files.
;; ;;  (setq make-backup-files t)
;; ;; ;; Enable versioning with default values (keep five last versions, I think!)
;; ;;  (setq version-control t)
;; ;; ;; Save all backup file in this directory.
;; ;; (if (eq system-type "darwin")
;; ;;     (setq backup-directory-alist (quote ((".*" . "/Volumes/Ramdisk/.emacs_backups/"))))
;; ;;   (setq backup-directory-alist (quote ((".*" . "/tmp/.emacs_backups/")))))

;; ;; ;;(setq tramp-backup-directory-alist backup-directory-alist)
;; ;; ;;(add-to-list 'backup-directory-alist
;; ;; ;;             (cons tramp-file-name-regexp nil))


;; ;; (autoload 'epa-setup "epa-setup")
;; ;; ;;(epa-file-enable)
;; ;; (setq epg-gpg-program "/usr/local/bin/gpg")
;; ;; (setenv "GPG_AGENT_INFO" nil)
;; ;; ;;(setq epa-file-cache-passphrase-for-symmetric-encryption f)





;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; ;;; Yasnippets
;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (with-eval-after-load 'yasnippet
;;   (global-set-key (kbd "C-M-y") 'yas/expand))


;; ;; http://emacs.stackexchange.com/questions/10431/get-company-to-show-suggestions-for-yasnippet-names
;; ;; Add yasnippet support for all company backends
;; ;; https://github.com/syl20bnr/spacemacs/pull/179
;; ;; (require 'company)
;; ;; (defvar company-mode/enable-yas t
;; ;;   "Enable yasnippet for all backends.")

;; ;; (defun company-mode/backend-with-yas (backend)
;; ;;   (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
;; ;;       backend
;; ;;     (append (if (consp backend) backend (list backend))
;; ;;             '(:with company-yasnippet))))

;; ;; (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))

;; ;; ;; helm-company choose from company completions with C-:
;; ;; (with-eval-after-load 'company
;; ;;   (define-key company-mode-map (kbd "C-:") 'helm-company)
;; ;;   (define-key company-active-map (kbd "C-:") 'helm-company))
;; ;; ;; (require 'auto-complete-yasnippet)



;; ;; ;; (add-hook 'post-command-hook 'djcb-set-cursor-according-to-mode)


;; ;; (define-minor-mode sensitive-mode
;; ;;   "For sensitive files like password lists.
;; ;; It disables backup creation and auto saving.

;; ;; With no argument, this command toggles the mode.
;; ;; Non-null prefix argument turns on the mode.
;; ;; Null prefix argument turns off the mode."
;; ;;   ;; The initial value.
;; ;;   nil
;; ;;   ;; The indicator for the mode line.
;; ;;   " Sensitive"
;; ;;   ;; The minor mode bindings.
;; ;;   nil
;; ;;   (if (symbol-value sensitive-mode)
;; ;;       (progn
;; ;;  ;; disable backups
;; ;;  (set (make-local-variable 'backup-inhibited) t)
;; ;;  ;; disable auto-save
;; ;;  (if auto-save-default
;; ;;      (auto-save-mode -1)))
;; ;;     ;resort to default value of backup-inhibited
;; ;;     (kill-local-variable 'backup-inhibited)
;; ;;     ;resort to default auto save setting
;; ;;     (if auto-save-default
;; ;;  (auto-save-mode 1))))

;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; ;;; Spelling configuration
;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq ispell-program-name "aspell")

;; ;; (setq ispell-program-name "aspell"
;; ;;       ispell-dictionary "english"
;; ;;       ispell-dictionary-alist
;; ;;       (let ((default '("[A-Za-z]" "[^A-Za-z]" "[']" nil
;; ;;                        ("-B" "-d" "english" "--dict-dir"
;; ;;                         "/Library/Application Support/cocoAspell/aspell6-en-6.0-0")
;; ;;                        nil iso-8859-1)))
;; ;;         `((nil ,@default)
;; ;;           ("english" ,@default))))



;; ;;                                         ;(setq ispell-extra-args '("--sug-mode=normal"))
;; ;; (setq ispell-list-command "list")



;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; ;;; Autocomplete
;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (with-eval-after-load 'company
;;   (define-key company-active-map (kbd "C-f") nil))

;; ;; (when (require 'auto-complete nil t)
;; ;;   (require 'auto-complete-config)
;; ;;   (ac-config-default)

;; ;;   ;;(require 'auto-complete-yasnippet)
;; ;;   ;;(require 'auto-complete-python)
;; ;;   ;;(require 'auto-complete-css)
;; ;;   ;;(require 'auto-complete-cpp)
;; ;;   ;;(require 'auto-complete-emacs-lisp)
;; ;;   ;;(require 'auto-complete-semantic)
;; ;;   ;;(require 'auto-complete-gtags)
;; ;;   (setq ac-delay 0.1) ;; eclipse uses 500ms
;; ;;   (global-auto-complete-mode t)
;; ;;   (setq ac-auto-start 1)
;; ;;   (setq ac-dwim t)
;; ;;   (set-default 'ac-sources
;; ;;                '(
;; ;;                  ac-source-filename
;; ;;                  ;;ac-source-yasnippet
;; ;;                  ac-source-gtags
;; ;;                  ac-source-abbrev
;; ;;                  ac-source-words-in-same-mode-buffers
;; ;;                  ;ac-source-files-in-current-dir
;; ;;                  ;ac-source-symbols)
;; ;;                ))

;; ;;   ;; Ignore case if completion target string doesn't include upper characters
;; ;;   ;;other options: 'smart or t
;; ;;   (setq ac-ignore-case nil)
;; ;;   (setq ac-use-menu-map t)
;; ;;   ;; Default settings
;; ;;   (define-key ac-menu-map "\C-n" 'ac-next)
;; ;;   (define-key ac-menu-map "\C-p" 'ac-previous)
;; ;;   (global-set-key (kbd "H-/") 'auto-complete)
;; ;;   (define-key ac-completing-map (kbd "H-/") 'ac-complete)
;; ;;   ;; 20 lines
;; ;;   (setq ac-menu-height 4)
;; ;;   ;; Examples
;; ;;   ;;(set-face-background 'ac-candidate-face "gray28")
;; ;;   (set-face-background 'ac-candidate-face "black")
;; ;;   (set-face-foreground 'ac-candidate-face "DeepSkyBlue")
;; ;;   (set-face-background 'ac-selection-face "gray15")
;; ;;   (set-face-foreground 'ac-selection-face "SeaGreen2")
;; ;;   )


;; ;;(package-initialize)
;; ;;(smartparens-global-mode t)


;; ;; (custom-set-faces
;; ;;  '(sp-pair-overlay-face ((t (:inherit nil
;; ;;                              :background nil
;; ;;                              :foreground nil)))))




;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; ;; Tramp
;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; (setq tramp-default-method "ssh")
;; ;; (setq tramp-chunksize 500)
;; ;; (setq tramp-auto-save-directory "/tmp/.emacs_backups/tramp-autosave")
;; ;; (setq tramp-default-method "ssh")
;; ;; (put 'temporary-file-directory 'standard-value '((file-name-as-directory "/tmp")))


;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; ;; Whizzy tex : automatic tex preview
;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; (autoload 'whizzytex-mode
;; ;;   "~/.emacs.d/elisp/whizzytex/whizzytex"
;; ;;   "WhizzyTeX, a minor-mode WYSIWIG environment for LaTeX" t)
;; ;; (setq-default whizzy-viewers '(("-pdf" "emacs")) ) ;;(("-dvi" "xdvi")("-ps" "emacs")("-pdf" "emacs" ) ))


;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; ;;; ECB
;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; (add-to-list 'load-path "~/.emacs.d/elpa/ecb")
;; ;; (setq stack-trace-on-error t)
;; ;; (require 'ecb-autoloads)

;; ;; (defun create-tags (dir-name)
;; ;;   "Create tags file."
;; ;;   (interactive "DDirectory: ")
;; ;;   (eshell-command
;; ;;    (format "find %s -type f -name \"*.[ch]\" | etags -" dir-name)))


;; ;; start the emacs server so emacsclient can attach to it
;; ;(server-start)


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; ido mode
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; ;; ido mode extra config
;; ;; (setq ido-file-extensions-order '(".hs" ".py" ".lhs" ".org" ".tex" ".txt" ".xml" ".el" ))

;; ;; (setq ido-enable-flex-matching t)
;; ;; (setq ido-everywhere t)
;; ;; (ido-mode 1)

;; ;; ;; (autoload 'tar-mode "tar-mode" "Tar Mode" t)

;; ;; (Show-paren-mode t)


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; Jira
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; (setq jiralib-url "https://cmtelematics.atlassian.net")
;; ;; you need make sure whether the "/jira" at the end is
;; ;; necessary or not, see discussion at the end of this page

;; ;; (require 'org-jira)
;; ;; jiralib is not explicitly required, since org-jira will load it.

;; ;;; .emacs ends here

;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; ;;; Highlight TODO: FIXME: BUG: and other keywords
;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; (add-hook 'prog-mode-hook
;; ;;           (lambda ()
;; ;;             (font-lock-add-keywords nil
;; ;;                                     '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1
;; ;;                                        font-lock-warning-face prepend)))))



;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; Autosave directory
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq
;;  backup-by-copying t      ; don't clobber symlinks
;;  backup-directory-alist
;;  '(("." . "~/.emacs_backups"))    ; don't litter my fs tree
;;  delete-old-versions t
;;  kept-new-versions 6
;;  kept-old-versions 2
;;  version-control t)       ; use versioned backups
;; (setq tramp-auto-save-directory "~/.emacs_backups/tramp-autosave")


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; spacemacs stuff
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq dotspacemacs-helm-resize t)
;; (setq helm-autoresize-min-height 3)
;; (setq helm-buffer-max-length nil)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; Operating system open comands
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (defvar os-open-dir-command
;;      (cond ((eq system-type 'gnu/linux) "dolphin ")
;;            ((eq system-type 'windows-nt) "start ")
;;            (t "open "))
;;      "OS specific command to open a file/folder in the window manager.")

;; (defvar os-open-pdf-command
;;      (cond ((eq system-type 'gnu/linux) "okular ")
;;            (t "open "))
;;      "OS specific command to open a PDF file.")

;; (defun os-open-directory (dir)
;;  (shell-command (concat os-open-dir-command dir)))

;; (defun os-open-pdf (file)
;;    (shell-command (concat os-open-pdf-command file)))

;; (defun open-current-directory ()
;;  (interactive)
;;  (os-open-directory "."))


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; fringe color
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (set-face-attribute 'fringe nil
;;                     :foreground (face-foreground 'window-divider-last-pixel))



;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; Load other custom functions
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (load (concat (file-name-as-directory (concat emacs-dir "personal")) "myFuns.el"))
;; ;;(with-eval-after-load 'org
;; ;;  (load (concat (file-name-as-directory (concat emacs-dir "personal")) "org-config.el")))

;; (require 'org)
;; (load (concat (file-name-as-directory (concat emacs-dir "personal")) "org-config.el"))

;; ;; (require 'tablet)


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; auto-completion
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; C-f to complete is annoying. disable that and replace with C-m

;; (require 'company)

;; (let ((map company-active-map))
;;   (define-key map (kbd "C-f") nil)
;;   (define-key map (kbd "C-m") 'company-complete-selection))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; file modes
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (add-to-list 'auto-mode-alist '("\\.cu\\'" . c++-mode))
;; (add-to-list 'auto-mode-alist '("\\.[jt]s[x]?\\'" . jtsx-tsx-mode)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; Temporary fix for helm wrong argument error
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; (with-eval-after-load "persp-mode"

;; ;;   (defun persp-remove-killed-buffers ()
;; ;;     (interactive)
;; ;;     (mapc #'(lambda (p)
;; ;;               (when p
;; ;;                 (setf (persp-buffers p)
;; ;;                       (delete-if-not #'buffer-live-p
;; ;;                                      (persp-buffers p)))))
;; ;;           (persp-persps)))
;; ;; )


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; hungry delete

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; dark bar
;; (add-to-list 'default-frame-alist
;;              '(ns-transparent-titlebar . t))
;; (add-to-list 'default-frame-alist
;;              '(ns-appearance . dark)) ;; or dark - depending on your theme

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; python mode : lsp
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; (use-package lsp-mode
;; ;;   :ensure t
;; ;;   :config

;; ;;   ;; make sure we have lsp-imenu everywhere we have LSP
;; ;;   (add-hook 'lsp-after-open-hook 'lsp-enable-imenu)
;; ;;   ;; get lsp-python-enable defined
;; ;;   ;; NB: use either projectile-project-root or ffip-get-project-root-directory
;; ;;   ;;     or any other function that can be used to find the root directory of a project
;; ;;   (lsp-define-stdio-client lsp-python "python"
;; ;;                            #'projectile-project-root
;; ;;                            '("pyls"))

;; ;;   ;; make sure this is activated when python-mode is activated
;; ;;   ;; lsp-python-enable is created by macro above
;; ;;   (add-hook 'python-mode-hook
;; ;;             (lambda ()
;; ;;               (lsp-python-enable)))

;; ;;   ;; lsp extras
;; ;;   (use-package lsp-ui
;; ;;     :ensure t
;; ;;     :config
;; ;;     (setq lsp-ui-sideline-ignore-duplicate t)
;; ;;     (add-hook 'lsp-mode-hook 'lsp-ui-mode))

;; ;;   (use-package company-lsp
;; ;;     :config
;; ;;     (push 'company-lsp company-backends))

;; ;;   ;; NB: only required if you prefer flake8 instead of the default
;; ;;   ;; send pyls config via lsp-after-initialize-hook -- harmless for
;; ;;   ;; other servers due to pyls key, but would prefer only sending this
;; ;;   ;; when pyls gets initialised (:initialize function in
;; ;;   ;; lsp-define-stdio-client is invoked too early (before server
;; ;;   ;; start)) -- cpbotha
;; ;;   (defun lsp-set-cfg ()
;; ;;     (let ((lsp-cfg `(:pyls (:configurationSources ("flake8")))))
;; ;;       ;; TODO: check lsp--cur-workspace here to decide per server / project
;; ;;       (lsp--set-configuration lsp-cfg)))

;; ;;   (add-hook 'lsp-after-initialize-hook 'lsp-set-cfg))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; python anaconda mode issue
;; ;; (with-eval-after-load 'anaconda-mode
;; ;;   (remove-hook 'anaconda-mode-response-read-fail-hook
;; ;;                                 'anaconda-mode-show-unreadable-response))




;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; jump to any spot using avy, but allow yourself to press enter

;; ;; (require 'avy)
;; ;; ;;;###autoload
;; ;; (defun avy-goto-string-par (str &optional arg beg end)
;; ;;   "Jump to the currently visible CHAR1 followed by CHAR2.
;; ;; The window scope is determined by `avy-all-windows'.
;; ;; When ARG is non-nil, do the opposite of `avy-all-windows'.
;; ;; BEG and END narrow the scope where candidates are searched."
;; ;;   (interactive (list (read-string "string: " nil nil nil t)
;; ;;                      current-prefix-arg
;; ;;                      nil nil))
;; ;;   (when (eq str ?)
;; ;;     (setq str ?\n))
;; ;;   (avy-with avy-goto-string-par
;; ;;     (avy-jump
;; ;;      (regexp-quote str)
;; ;;      :window-flip arg
;; ;;      :beg beg
;; ;;      :end end)))

;; (global-unset-key (kbd "M-j"))
;; (global-set-key (kbd "M-j") 'avy-goto-char-timer)
;; (setq avy-all-windows t)



;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; TSX (jtsx)
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (use-package jtsx
;;   :ensure t
;;   :mode (("\\.jsx?\\'" . jtsx-jsx-mode)
;;          ("\\.tsx\\'" . jtsx-tsx-mode)
;;          ("\\.ts\\'" . jtsx-typescript-mode))
;;   :commands jtsx-install-treesit-language
;;   :hook ((jtsx-jsx-mode . hs-minor-mode)
;;          (jtsx-tsx-mode . hs-minor-mode)
;;          (jtsx-typescript-mode . hs-minor-mode))
;;   ;;:custom
;;   ;; Optional customizations
;;   ;; (js-indent-level 2)
;;   ;; (typescript-ts-mode-indent-offset 2)
;;   ;; (jtsx-switch-indent-offset 0)
;;   ;; (jtsx-indent-statement-block-regarding-standalone-parent nil)
;;   ;; (jtsx-jsx-element-move-allow-step-out t)
;;   ;; (jtsx-enable-jsx-electric-closing-element t)
;;   ;; (jtsx-enable-electric-open-newline-between-jsx-element-tags t)
;;   ;; (jtsx-enable-jsx-element-tags-auto-sync nil)
;;   ;; (jtsx-enable-all-syntax-highlighting-features t)
;;   :config
;;   (defun jtsx-bind-keys-to-mode-map (mode-map)
;;     "Bind keys to MODE-MAP."
;;     (define-key mode-map (kbd "C-c C-j") 'jtsx-jump-jsx-element-tag-dwim)
;;     (define-key mode-map (kbd "C-c j o") 'jtsx-jump-jsx-opening-tag)
;;     (define-key mode-map (kbd "C-c j c") 'jtsx-jump-jsx-closing-tag)
;;     (define-key mode-map (kbd "C-c j r") 'jtsx-rename-jsx-element)
;;     (define-key mode-map (kbd "C-c <down>") 'jtsx-move-jsx-element-tag-forward)
;;     (define-key mode-map (kbd "C-c <up>") 'jtsx-move-jsx-element-tag-backward)
;;     (define-key mode-map (kbd "C-c C-<down>") 'jtsx-move-jsx-element-forward)
;;     (define-key mode-map (kbd "C-c C-<up>") 'jtsx-move-jsx-element-backward)
;;     (define-key mode-map (kbd "C-c C-S-<down>") 'jtsx-move-jsx-element-step-in-forward)
;;     (define-key mode-map (kbd "C-c C-S-<up>") 'jtsx-move-jsx-element-step-in-backward)
;;     (define-key mode-map (kbd "C-c j w") 'jtsx-wrap-in-jsx-element)
;;     (define-key mode-map (kbd "C-c j u") 'jtsx-unwrap-jsx)
;;     (define-key mode-map (kbd "C-c j d n") 'jtsx-delete-jsx-node)
;;     (define-key mode-map (kbd "C-c j d a") 'jtsx-delete-jsx-attribute)
;;     (define-key mode-map (kbd "C-c j t") 'jtsx-toggle-jsx-attributes-orientation)
;;     (define-key mode-map (kbd "C-c j h") 'jtsx-rearrange-jsx-attributes-horizontally)
;;     (define-key mode-map (kbd "C-c j v") 'jtsx-rearrange-jsx-attributes-vertically))

;;   (defun jtsx-bind-keys-to-jtsx-jsx-mode-map ()
;;       (jtsx-bind-keys-to-mode-map jtsx-jsx-mode-map))

;;   (defun jtsx-bind-keys-to-jtsx-tsx-mode-map ()
;;       (jtsx-bind-keys-to-mode-map jtsx-tsx-mode-map))

;;   (add-hook 'jtsx-jsx-mode-hook 'jtsx-bind-keys-to-jtsx-jsx-mode-map)
;;   (add-hook 'jtsx-tsx-mode-hook 'jtsx-bind-keys-to-jtsx-tsx-mode-map))


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; magit clean merged branches
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (defun my-magit/delete-merged-branches ()
;;   (interactive)
;;   (magit-fetch-all-prune)
;;   (let* ((default-branch
;;            (read-string "Default branch: " (magit-get-current-branch)))
;;          (merged-branches
;;           (magit-git-lines "branch"
;;                            "--format" "%(refname:short)"
;;                            "--merged"
;;                            default-branch))
;;          (branches-to-delete
;;           (remove default-branch merged-branches)))
;;     (if branches-to-delete
;;         (if (yes-or-no-p (concat "Delete branches? ["
;;                                  (mapconcat 'identity branches-to-delete ", ") "]"))
;;             (magit-branch-delete branches-to-delete))
;;       (message "Nothing to delete"))))


;; (transient-append-suffix 'magit-branch "C"
;;     '("K" "delete all merged" my-magit/delete-merged-branches))



;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; ruff formatting
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (use-package reformatter
;;   :hook
;;   (python-mode . ruff-format-on-save-mode)
;;   (python-ts-mode . ruff-format-on-save-mode)
;;   :config
;;   (reformatter-define ruff-format
;;     :program "ruff"
;;     :args `("format" "--stdin-filename" ,buffer-file-name "-")))

;; ;; (reformatter-define ruff-format
;; ;;   :program "ruff"
;; ;;   :args '("format" "-")
;; ;;   :lighter " ruff")


;; (setq forge-status-buffer-default-topic-filters
;;       '((:status . "open")))


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; Done
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; (message "All done, %s%s" (user-login-name) ".")
