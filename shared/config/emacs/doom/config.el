;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-molokai)
;; (setq doom-molokai-brighter-comments t)
(setq doom-molokai-brighter-modeline t)
;; (set-background-color "#1C1E1F")


;;; make vertico file names stand out when doing a project search
(custom-set-faces!
  '(vertico-group-title :inherit org-clock-overlay))


;; doom-acario-dark
;; doom-monokai-classic
;; doom-dracula

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/.org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Items from personal.el which I will eventually move back there
(global-set-key (kbd "C-M-j") 'consult-imenu)
;;(global-set-key (kbd "C-M-J") 'consult-imenu-multi)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; windmove
(global-set-key (kbd "M-<left>") 'windmove-left)
(global-set-key (kbd "M-<right>") 'windmove-right)
(global-set-key (kbd "M-<up>") 'windmove-up)
(global-set-key (kbd "M-<down>") 'windmove-down)

;; to work with tmux
(global-set-key (kbd "ESC <left>") 'windmove-left)
(global-set-key (kbd "ESC <right>") 'windmove-right)
(global-set-key (kbd "ESC <up>") 'windmove-up)
(global-set-key (kbd "ESC <down>") 'windmove-down)

;; remove C-z to minimize cause it is annoying
(global-set-key (kbd "C-Z") nil)
(global-set-key (kbd "C-M-z") 'suspend-frame)

;; align according to regexp
(global-set-key (kbd "C-x a r") 'align-regexp)
(global-set-key (kbd "C-x O") 'previous-multiframe-window)


;; Yasnippets
(global-set-key (kbd "C-M-y") 'yas/expand)
(setq yas-snippet-dirs (append yas-snippet-dirs
                               '("~/.config/doom/snippets")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; jump to any spot using avy, but allow yourself to press enter

;; (require 'avy)
;; ;;;###autoload
;; (defun avy-goto-string-par (str &optional arg beg end)
;;   "Jump to the currently visible CHAR1 followed by CHAR2.
;; The window scope is determined by `avy-all-windows'.
;; When ARG is non-nil, do the opposite of `avy-all-windows'.
;; BEG and END narrow the scope where candidates are searched."
;;   (interactive (list (read-string "string: " nil nil nil t)
;;                      current-prefix-arg
;;                      nil nil))
;;   (when (eq str ?)
;;     (setq str ?\n))
;;   (avy-with avy-goto-string-par
;;     (avy-jump
;;      (regexp-quote str)
;;      :window-flip arg
;;      :beg beg
;;      :end end)))

(global-unset-key (kbd "M-j"))
(global-set-key (kbd "M-j") 'avy-goto-char-timer)

(setq tab-always-indent t)

(custom-set-variables
  '(avy-timeout-seconds 10.0)
 )

;; line wrap indicators
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
(global-visual-line-mode 1)
(setq word-wrap nil)

;; more obvious paren
(setq show-paren-delay 0)
(after! paren
  (set-face-background 'show-paren-match "gray42"))

(defadvice show-paren-function (after my-echo-paren-matching-line activate)
  "If a matching paren is off-screen, echo the matching line."
  (when (and (> (point) 1) (char-equal (char-syntax (char-before (point))) ?\)))
    (let ((matching-text (blink-matching-open)))
      (when matching-text
        (message matching-text)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mode line
;; (setq doom-modeline-icon t)
;; (setq doom-modeline-icon nil)
;; (setq doom-modeline-unicode-fallback t)
;; (setq doom-modeline-buffer-file-name-style 'auto)
;; (setq doom-modeline-minor-modes nil)
;;(require 'powerline)
;;(powerline-default-theme)
;;
(use-package diminish
  :ensure t)

(use-package spaceline
  :ensure t)

(use-package spaceline-config
  :ensure spaceline
  :config
  (spaceline-helm-mode 1)
  (spaceline-emacs-theme)
  (spaceline-toggle-org-clock-on)
  (spaceline-toggle-minor-modes-off)
  (spaceline-toggle-version-control-off)
  (custom-set-faces
   '(spaceline-highlight-face
     ((t (:background "SteelBlue1" ; "DarkGoldenrod2"
          :foreground "#3E3D31"
          :inherit 'mode-line)))
     "Default highlight face for spaceline."
     :group 'spaceline)))


;;;; Mouse scrolling in terminal emacs
(unless (display-graphic-p)
  ;; activate mouse-based scrolling
  (xterm-mouse-mode 1)
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line)
  )

;; leader key
(global-unset-key (kbd "M-m"))
(setq doom-leader-alt-key "M-m")
(setq doom-localleader-alt-key "M-m l")

;; move cursor by camelCase
(global-subword-mode 1) ; 1 for on, 0 for off

;; load paths
;;(add-to-list 'load-path "~/.emacs.d/personal")
(add-to-list 'load-path "~/")

(require '.me)

(defvar me-emacs-dir "~/.config/doom/personal")
(load (concat (file-name-as-directory me-emacs-dir) "myFuns.el"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Org-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org
  :mode (("\\.org$" . org-mode))
  :ensure org-plus-contrib
  :config
  (load (concat (file-name-as-directory me-emacs-dir) "org-config.el")))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; basic configs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq-default fill-column 85)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Doom overrides
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; don't continue comments on newline
(setq +default-want-RET-continue-comments nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; fringe
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq-default fringe-indicator-alist '((truncation left-arrow right-arrow)
                                       (continuation left-curly-arrow right-curly-arrow)
                                       (overlay-arrow . right-triangle)
                                       (up . up-arrow)
                                       (down . down-arrow)
                                       (top top-left-angle top-right-angle)
                                       (bottom bottom-left-angle bottom-right-angle top-right-angle top-left-angle)
                                       (top-bottom left-bracket right-bracket top-right-angle top-left-angle)
                                       (empty-line . empty-line)
                                       (unknown . question-mark)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; copy paste with mac clipboard
(when (eq system-type 'darwin)
  (use-package pbcopy
    :ensure t
    :config
    (turn-on-pbcopy))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; clipetty
(use-package clipetty
  :ensure t
  :hook (after-init . global-clipetty-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; save session every hour
;; (run-at-time 3600 t #'doom-save-session)

;; runs after 5 min of idle time. But block the annoying string output that causes
;; the minibuffer to expand
(defun doom-save-session-no-message ()
  (let ((fname (concat (doom-session-file) "-timer")))
    (let ((inhibit-message t)) (doom-save-session fname))
    (message (concat "autosaved workspace to " fname))))

(run-with-idle-timer 300 t #'doom-save-session-no-message)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Done
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (message "All done, %s%s" (user-login-name) ".")
