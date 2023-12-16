;;; Title: myFuns.el
;;; Description: This file defines all my functions
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Definitions of functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; (require 'compile)
;; (require '.me)

;; (defun my-recompile (&optional edit-command)
;;   "Re-compile the program including the current buffer.
;; If this is run in a Compilation mode buffer, re-use the arguments from the
;; original use.  Otherwise, recompile using `compile-command'.
;; If the optional argument `edit-command' is non-nil, the command can be edited."
;;   (interactive "P")
;;   (save-some-buffers (not compilation-ask-about-save) nil)
;;   (let ((default-directory (or compilation-directory default-directory)))
;;     (when edit-command
;;       (setcar compilation-arguments
;;               (compilation-read-command (car compilation-arguments))))
;;     (apply 'compilation-start (or compilation-arguments
;;                                   `(,(eval compile-command) t)))))


;; Complement to next-error
(defun previous-error (n)
  "Visit previous compilation error message and corresponding source code."
  (interactive "p")
  (next-error (- n)))


;; Complete stuff with the tab key
;; (defun indent-or-complete ()
;;   "Complete if point is at end of a word, otherwise indent line."
;;   (interactive)
;;   (if (looking-at "\\>")
;;       (dabbrev-expand nil)
;;     (indent-for-tab-command)
;;     ))
;; Add the above function to the c-mode and map it to the TAB key
;; (add-hook 'c-mode-common-hook
;;   (function (lambda ()
;;   (local-set-key (kbd "<tab>") 'indent-or-complete))))

;; Insert date
(defun insert-date ()
  "Insert the date."
  (interactive)
  (insert (format-time-string "%B %e, %Y")))

;; Go to the matching parenthesis if there is one
(defun go-to-matching-paren ()
  "Move cursor to the matching parenthesis."
  (interactive)
  (cond ((looking-at "[[({]") (forward-sexp 1) (backward-char 1))
        ((looking-at "[])}]") (forward-char 1) (backward-sexp 1))
        (t (ding) (message "Unbalanced parenthesis"))))

;; Show the matching parenthesis momentarily
(defun show-matching-paren ()
  "Move cursor momentarily to the matching parenthesis."
  (interactive)
  (save-excursion
    (cond ((looking-at "[[({]") (forward-sexp 1) (backward-char 1) (sit-for 1))
          ((looking-at "[])}]") (forward-char 1) (backward-sexp 1) (sit-for 1))
          (t (ding) (message "Unbalanced parenthesis")))))


(define-key global-map "\C-\M-g" 'go-to-matching-paren)

;; Bind <Ctrl-C s> to - a brief show of the matching parenthesis.
                                        ;(define-key global-map "\C-cs" 'show-matching-paren)

;; (define-key isearch-mode-map '[backspace] 'isearch-delete-char)

(defun indent-all ()
  "Indent entire buffer"
  (interactive)
  (indent-region (point-min) (point-max) nil))

;; Replace all those horrible ^M's that come
(defun my_replace_ms ()
  "Replace all the
"
  (interactive)
  (replace-string "
" "" nil (point-min) (point-max)))


;; unix2dos functionality
(defun dosify ()
  "convert this from unix to dos style"
  (interactive)
  (goto-char (point-min))
  (while (search-forward "\n" nil t) (replace-match "\r\n")))

(defun unixify ()
  "Convert to unix linefeeds only."
  (interactive)
  '(untabify (point-min) (point-max))
  (set-buffer-file-coding-system (quote undecided-unix) nil))

;; (global-set-key "\M-\C-m" 'unixify)





;; Word Count
(defun word-count nil "Count words in buffer" (interactive)
       (shell-command-on-region (mark) (point) "wc -w"))

(defun char-count nil "Count words in buffer" (interactive)
       (shell-command-on-region (mark) (point) "wc -c"))

(defun line-count nil "Count words in buffer" (interactive)
       (shell-command-on-region (mark) (point) "wc -l"))



(defun jta-reformat-xml ()
  "Reformats xml to make it readable (respects current selection)."
  (interactive)
  (save-excursion
    (let ((beg (point-min))
          (end (point-max)))
      (if (and mark-active transient-mark-mode)
          (progn
            (setq beg (min (point) (mark)))
            (setq end (max (point) (mark))))
        (widen))
      (setq end (copy-marker end t))
      (goto-char beg)
      (while (re-search-forward ">\\s-*<" end t)
        (replace-match ">\n<" t t))
      (goto-char beg)
      (indent-region beg end nil))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; print to pdf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun print-to-pdf ()
  (interactive)
  (ps-spool-buffer-with-faces)
  (switch-to-buffer "*PostScript*")
  (write-file "/tmp/tmp.ps")
  (kill-buffer "tmp.ps")
  (setq cmd (concat "ps2pdf14 /tmp/tmp.ps " (buffer-name) ".pdf"))
  (shell-command cmd)
  (shell-command "rm /tmp/tmp.ps")
  (message (concat "Saved to:  " (buffer-name) ".pdf"))
  )

(defun print-to-pdf-nocolor ()
  (interactive)
  (ps-spool-buffer)
  (switch-to-buffer "*PostScript*")
  (write-file "/tmp/tmp.ps")
  (kill-buffer "tmp.ps")
  (setq cmd (concat "ps2pdf14 /tmp/tmp.ps " (buffer-name) ".pdf"))
  (shell-command cmd)
  (shell-command "rm /tmp/tmp.ps")
  (message (concat "Saved to:  " (buffer-name) ".pdf"))


  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; unwrap lines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun unwrap-line ()
  "Remove all newlines until we get to two consecutive ones.
    Or until we reach the end of the buffer.
    Great for unwrapping quotes before sending them on IRC."
  (interactive)
  (let ((start (point))
        (end (copy-marker (or (search-forward "\n\n" nil t)
                              (point-max))))
        (fill-column (point-max)))
    (fill-region start end)
    (goto-char end)
    (newline)
    (goto-char start)))

;;; myFuns.el ends here


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; open ssh version

(defun open-in-tml ()
  (interactive)
  (start-process "eOpenSSH" nil "~/bin/eOpenSSH.sh" (buffer-file-name))
  (suspend-frame))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; auctex dnd mode

(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

(defcustom AUCTeX-dnd-format "\\includegraphics[width=\\textwidth]{%s}"
  "What to insert, when a file is dropped on Emacs window. %s is
replaced by the actual file name. If the filename is located
under the directory of .tex document, only the part of the name
relative to that directory in used."
  :type 'string
  :group 'AUCTeX)


;; Modified version
(defun AUCTeX-dnd-includegraphics (uri action)
  "Insert the text defined by `AUCTeX-dnd-format' when a file is
dropped on Emacs window."
  (let ((cdir (concat default-directory "/figs"))
        (file (dnd-get-local-file-name uri t)))
    (when (and file (file-regular-p file))
      (if (string-match cdir file)
          (insert (format AUCTeX-dnd-format (file-name-nondirectory file)))
        (let ((newfname (concat (string-trim (shell-command-to-string (concat "md5 -q " file))) "." (file-name-extension file))))
            (string-trim (shell-command-to-string (concat "mkdir -p " cdir)))
            (string-trim (shell-command-to-string (concat "cp -f " file " " cdir "/" newfname)))
            (insert (format AUCTeX-dnd-format newfname))
            )
          )

      )
    )
  )


(defcustom AUCTeX-dnd-protocol-alist
  '(("^file:///" . AUCTeX-dnd-includegraphics)
    ("^file://"  . dnd-open-file)
    ("^file:"    . AUCTeX-dnd-includegraphics))
  "The functions to call when a drop in `mml-mode' is made.
See `dnd-protocol-alist' for more information.  When nil, behave
as in other buffers."
  :type '(choice (repeat (cons (regexp) (function)))
                 (const :tag "Behave as in other buffers" nil))
  :version "22.1" ;; Gnus 5.10.9
  :group 'AUCTeX)


(define-minor-mode AUCTeX-dnd-mode
  "Minor mode to inser some text (\includegraphics by default)
when a file is dopped on Emacs window."
  :lighter " DND"
  (when (boundp 'dnd-protocol-alist)
    (if AUCTeX-dnd-mode
        (set (make-local-variable 'dnd-protocol-alist)
             (append AUCTeX-dnd-protocol-alist dnd-protocol-alist))
      (kill-local-variable 'dnd-protocol-alist))))

(add-hook 'LaTeX-mode-hook 'AUCTeX-dnd-mode)
