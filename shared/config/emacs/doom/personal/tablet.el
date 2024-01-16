;;; tablet.el --- Allows the usage of a tablet to insert images into org-mode

;; Copyright (C) 2016 pareshmg
;;
;;;; Author: Paresh Malalur <paresh.mg@gmail.com>
;; Keywords: tablet
;; Created: 28 Oct 2014
;; Version: 1.0
;; Package-Requires: ((emacs "24"))
;; URL:

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Usage
;; -----
;; run and enjoy using
;; M-x tablet-create-default-image-and-org-link RET

;;
;; Customization
;; -------------
;;
;; Open the customization group buffer:
;; M-x customize-group RET tablet RET
;;
;; There you can change the app that is used to edit the images


;;; Code:


(defgroup tablet nil
  "Tablet customizations."
  :group 'multimedia
  :prefix 'tablet-)

(setq tablet-image-ctr 1)

(defcustom tablet-editing-app
  "/Applications/SketchBook.app"
  "Program to use to edit image."
  :type 'file)

(defun tablet-insert-new-image (w h c shouldOpen)
  ;; check the directory
  (if (not (file-exists-p (concat (buffer-name) "_files")))
      (progn
        (message (concat "make-directory: " (concat (buffer-name) "_files")))
        (make-directory (concat (buffer-name) "_files"))))
  ;; get the next image name
  (setq tablet-image-ctr (tablet-get-next-index tablet-image-ctr))
  (let ((fname (tablet-generate-file-name-with-index tablet-image-ctr)))
    (message (concat "opening " fname))
    (tablet-create-empty-image w h c fname)
    (if shouldOpen (tablet-open-new-file fname))
    (list (concat default-directory fname) tablet-image-ctr)))




(defun tablet-org-image-link (fname desc)
  (format "#+CAPTION: %s\n#+LABEL: fig:%s\n[[file:%s]]" desc desc fname))



(defun tablet-create-empty-image (w h c fname)
  (call-process "convert"
                 nil
                 nil
                 nil
                 "-size"
                 (concat (number-to-string w) "x" (number-to-string h))
                 c ;"xc:transparent"
                 (concat "PNG32:" fname)))

(defun tablet-get-next-index (ind)
  (catch 'break
    (loop do
          (let ((fname1 (tablet-generate-file-name-with-index ind)))
            (message fname1)
            (if (not (file-exists-p fname1))
                (throw 'break ind)))
          (setq ind (+ 1 ind))
          while t)
    ))

(defun tablet-generate-file-name-with-index (ind)
  (concat (buffer-name) "_files/" "IMG_" (format "%04d" ind) ".png"))

(defun tablet-open-new-file (fname)
  (start-process "open"
                (get-buffer-create "*Messages*")
                "open"
                "-a"
                tablet-editing-app
                fname))


(defun tablet-create-image-and-org-link (w h c)
  (interactive)
  (let* ((nxtImg (tablet-insert-new-image w h c 1))
         (defaultLabel (format "Image%d" (cadr nxtImg)))
         (actualLabel (read-string (format "Label [%s]:" defaultLabel))))
    (if (string= "" actualLabel)
        (setq actualLabel defaultLabel))
    (insert (tablet-org-image-link (tablet-generate-file-name-with-index (cadr nxtImg)) actualLabel))))




(defun tablet-create-white-page-and-org-link ()
  (interactive)
  (tablet-create-image-and-org-link 840 1188 "xc:white"))

(defun tablet-create-transparent-page-and-org-link ()
  (interactive)
  (tablet-create-image-and-org-link 840 1188 "xc:transparent"))

(defun tablet-create-white-image-and-org-link ()
  (interactive)
  (tablet-create-image-and-org-link 800 600 "xc:white"))

(defun tablet-create-transparent-image-and-org-link ()
  (interactive)
  (tablet-create-image-and-org-link 800 600 "xc:transparent"))



(defun tablet-create-default-page-and-org-link ()
  (interactive)
  (tablet-create-white-page-and-org-link))


(defun tablet-create-default-image-and-org-link ()
  (interactive)
  (tablet-create-transparent-image-and-org-link))


(defun tablet-trim-images ()
  (interactive)
  (let ((ind 1))
    (catch 'break
      (loop do
            (let ((fname1 (tablet-generate-file-name-with-index ind)))
              (if (not (file-exists-p fname1))
                  (throw 'break nil))
              (message (concat "Trimming " fname1))
              (tablet-trim-image fname1))
            (setq ind (+ 1 ind))
            while t)
    )))

(defun tablet-trim-image (fname)
  (call-process "convert"
                 nil
                 nil
                 nil
                 "-trim"
                 fname
                 fname))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Trivial mode (open with external program)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun define-trivial-mode-tablet ()
  (interactive)
  (toggle-read-only t)
  (start-process "open" nil "open" "-a" tablet-editing-app (buffer-file-name))
  (kill-buffer (current-buffer)))


(add-to-list 'auto-mode-alist (cons "\\.png$" 'define-trivial-mode-tablet))

(defun define-trivial-mode-sp-func (mode-prefix command)
  (lambda (fname)
    (apply #'start-process (append (mode-prefix nil) command (list fname)))))

;; (define-trivial-mode "open" "\\.pdf$" (list "open"))
;; (define-trivial-mode "open" "\\.png$" (list "open" "-a" "/Applications/Seashore.app"))

(provide 'tablet)

;;; tablet.el ends here
