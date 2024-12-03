;;; symbol-overlay-mc.el --- Symbol overlay extensions for multiple cursors  -*- lexical-binding: t -*-

;; Copyright (C) 2024 Alvaro Ramirez

;; Author: Alvaro Ramirez https://lmno.lol/alvaro
;; URL: https://github.com/xenodium/symbol-overlay-mc
;; Version: 0.1.1
;; Package-Requires: ((emacs "28.1") (multiple-cursors "1.4.0") (symbol-overlay "4.1"))

;; This package is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This package is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Invoke `symbol-overlay-mc-mark-all' to place cursors on each symbol overlay.

;;; Code:

(require 'multiple-cursors-core)
(require 'seq)
(require 'symbol-overlay)

;;;###autoload
(defun symbol-overlay-mc-mark-all ()
  "Mark all symbol overlays using multiple cursors."
  (interactive)
  (when-let* ((overlays (symbol-overlay-get-list 0))
              (point (point))
              (point-overlay (seq-find
                              (lambda (overlay)
                                (and (<= (overlay-start overlay) point)
                                     (<= point (overlay-end overlay))))
                              overlays))
              (offset (- point (overlay-start point-overlay))))
    (setq deactivate-mark t)
    (mapc (lambda (overlay)
            (unless (eq overlay point-overlay)
              (mc/save-excursion
               (goto-char (+ (overlay-start overlay) offset))
               (mc/create-fake-cursor-at-point))))
          overlays)
    (mc/maybe-multiple-cursors-mode)))

(add-to-list 'mc--default-cmds-to-run-once 'symbol-overlay-mc-mark-all t)

(provide 'symbol-overlay-mc)

;;; symbol-overlay-mc.el ends here
