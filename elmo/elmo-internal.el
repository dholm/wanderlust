;;; elmo-internal.el -- Internal Interface for ELMO.

;; Copyright (C) 1998,1999,2000 Yuuichi Teranishi <teranisi@gohome.org>

;; Author: Yuuichi Teranishi <teranisi@gohome.org>
;; Keywords: mail, net news

;; This file is part of ELMO (Elisp Library for Message Orchestration).

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.
;;

;;; Commentary:
;; 

;;; Code:
;; 
(require 'elmo)

;;; ELMO internal folder
(luna-define-class elmo-internal-folder (elmo-folder) ())

(luna-define-method elmo-folder-initialize ((folder
					     elmo-internal-folder)
					    name)
  (elmo-internal-folder-initialize folder name))

(defvar elmo-internal-folder-list '(mark cache))

(defun elmo-internal-folder-initialize (folder name)
  (let ((fsyms elmo-internal-folder-list)
	fname class sym)
    (if (progn (while fsyms
		 (setq fname (symbol-name (car fsyms)))
		 (when (string-match (concat "^" fname) name)
		   (require (intern (concat "elmo-" fname)))
		   (setq class (intern (concat "elmo-" fname "-folder"))
			 sym (intern fname)
			 fsyms nil))
		 (setq fsyms (cdr fsyms)))
	       class)
	(elmo-folder-initialize
	 (luna-make-entity
	  class
	  :type sym
	  :prefix (elmo-folder-prefix-internal folder)
	  :name (elmo-folder-name-internal folder)
	  :persistent (elmo-folder-persistent-internal folder))
	 name)
      folder)))

(luna-define-method elmo-folder-list-subfolders ((folder elmo-internal-folder)
						 &optional one-level)
  (mapcar
   (lambda (x)
     (list (concat (elmo-folder-prefix-internal folder)
		   (symbol-name x))))
   elmo-internal-folder-list))

(require 'product)
(product-provide (provide 'elmo-internal) (require 'elmo-version))

;;; elmo-internal.el ends here
