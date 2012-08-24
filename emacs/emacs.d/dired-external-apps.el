;;; dired-external-apps.el ---

;; Copyright 2006 Joseph Brenner
;;
;; Author: doom@kzsu.stanford.edu
;; Version: $Id: dired-external-apps.el,v 1.7 2008/07/09 19:53:16 doom Exp doom $
;; Keywords:
;; X-URL: not distributed yet

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
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

;;  In dired in GNU Emacs, the dired-do-shell-command feature (bound to "!" by
;;  default), is useful for running an external command on the current filename.

;;  This has a bad limitation, however: it doesn't really do
;;  asynchronous launches.  If you remember to append a & (and
;;  remember to include a place holder "*" for the filename) the
;;  command *will* run without hanging up emacs, but you'll find
;;  that it hangs up the "!" command: you won't be able to do
;;  another launch until the first finishes.

;;  (Note that xemacs is better off in this respect: it's dired
;;  has a feature bound to "&" to run fully asynchronous commands.)

;;  So this package addresses that limitation by creating
;;  a sub-shell buffer it uses internally to do application launches
;;  (by default, this is called "*external apps shell*").
;;  This has a few advantages over approaches that create a new shell
;;  for each invocation, not the least of which is that all output
;;  (error messages and so on) are automatically gathered together
;;  into this one buffer.

;;  There's another (lesser) limitation with the "!" command that's
;;  also addressed here: while it has a very good feature that
;;  guesses which command to run based on the file extension,
;;  this feature is less useful if there's no single clear best
;;  guess for a given file extension.

;;  Consider the case of an image extension like "JPG". Commonly,
;;  one might want to view, rotate or crop a jpeg, but each of these
;;  operations is best handled by a different program.  So the
;;  single guess of the "!" command isn't enough: it's better to
;;  have seperate keystroke commands in dired to run the specific
;;  image applications.

;;  There's an additional feature that can be useful (though it's
;;  shut-off by default to minimize obnoxiousness): running a
;;  command on a file can automatically save information about the
;;  file to the kill-ring and to user registers (by default, "n"
;;  for the name and "p" for the path).  This facilitates doing
;;  moves or renames in dired; writing notes about the files; or
;;  running other commands on them manually in a sub-shell window.

;;  Further documentation is included in the doc strings
;;  for the dummy variables dired-external-apps-documentation-*


;;; Code:

(provide 'dired-external-apps)
(eval-when-compile
  (require 'cl))

(require 'shell)


;;;;##########################################################################
;;;;  User Options, Variables
;;;;##########################################################################

(defcustom dired-external-apps-save-to-registers-flag nil
  "Controls whether the dired-external-apps commands will save file name and path to registers.")

(defcustom dired-external-apps-list
  (list "xloadimage"
        "gimp"
        "gthumb"
        "xpdf"
        "emacs"
   )
  "List of external applications to be used from dired.")

(defcustom dired-external-apps-shell-buffer "*external apps shell*"
  "The name of the shell buffer used for launching multiple asynchronous commands.")

(defcustom dired-external-apps-path-register ?p
  "The register used to store the file path by \\[dired-external-apps-file-name-to-ring-and-registers-if-enabled].")

(defcustom dired-external-apps-name-register ?n
  "The register used to store the file name (sans path) by \\[dired-external-apps-file-name-to-ring-and-registers-if-enabled].")


(defvar dired-external-apps-function-prefix
  "dired-external-apps-open-with-"
  "Dynamically created app launcher functions are named with this prefix.")

(defvar dired-external-apps-last-buffer ""
  "The last active buffer before an app was invoked via this package.
This can be used by other packages, such as \"image-dired.el\",
so that after exiting they can reliably display the buffer they
were invoked from.")

(defvar dired-external-apps-last-point nil
  "The last cursor location in the last active buffer.
This can be used by other packages, such as \"image-dired.el\",
so that after exiting they can reliably display the buffer they
were invoked from.")



;; =======
;; user documentation

(defvar dired-external-apps-documentation t
"Documentation for the dired-external-apps package.
This package provides functions to do multiple asynchronous
launches of external applications, and to simplify launching
applications from dired, particularly in the case where there's
no single association between an application and a file extension.

Synopsis of usage:

Put the file dired-external-apps.el in one of your load-path locations,
and add the following to your ~/.emacs:

   (require 'dired-external-apps)

Add any applications/wrapper scripts you might want to use from dired
that aren't already included:

  (setq dired-external-apps-list (cons \"xw3m\" dired-external-apps-list ))
  (setq dired-external-apps-list (cons \"xlynx\" dired-external-apps-list ))
  (dired-external-apps-generate-wrapper-functions-for-apps) ;; reinitialize after changes

To enable the side-effect of saving file information:

  (setq dired-external-apps-save-to-registers-flag t)

Most likely you will also want to add some keybindings,
for example:

  (add-hook 'dired-mode-hook
    '(lambda ()
     (define-key dired-mode-map
       \"o\"
       'dired-external-apps-open-with-gthumb)
     (define-key dired-mode-map
       [return]
       'dired-external-apps-open-with-emacs) ; i.e. inside of emacs in image-mode
     (define-key dired-mode-map
       \"\\C-o\"
       'dired-external-apps-open-with-gthumb)
     (define-key dired-mode-map
       \"\\-\"
       'dired-external-apps-open-with-gimp)
     ))

A brief tutorial:

With the above suggested set-up, working in dired with image
files can be simplified.  Typically, one might want to view,
rotate or crop a jpeg, but each of these operations is probably
best handled by a different program.  Hitting the \"o\" key will
launch gthumb opening the current file, hitting the \"-\" will
launch gimp, and if you hit RETURN the image will be opened
inside of emacs in an image-mode buffer.

\(Note: for improvements in working with image-mode, see the
related package image-mode-dired.el\)

As a side-effect, opening a file with one of these commands also
places the file information in some user registers, and on to the
kill-ring (though only if \\[dired-external-apps-save-to-registers-flag]
has been set).  The register \"n\" will have the file name, the
register \"p\" will have the path to the file, and the kill-ring
will have the file name (sans path) pushed on to it.

This greatly simplifies doing other operations on the file after
viewing the image: for example, if you rename it with \\[dired-do-rename]
(bound by default to \"R\"), you can begin by yanking the current
file name (C-y) to have a starting point to edit.  Other uses
include manual operations in a shell, emailing the file name, or
just making notes about it.  For hints about using emacs registers
with this package see \\[dired-external-apps-documentation-appendix-registers].

All of these external application launches are done in a special
sub-shell named: \{dired-external-apps-shell-buffer}, so if there
seems to be a problem with them, you should look in that buffer
for any relevant error messages.

For additional information on this package, see:
\\[dired-external-apps-documentation-appendix-misc].")

(defvar dired-external-apps-documentation-appendix-registers t
  "Emacs has a series of \"registers\" with single-character
names available for use, primarily by the user.  As a
convenience, some routines here places some information in these
registers for later use (though only if
\\[dired-external-apps-save-to-registers-flag] has been set).
The path of the last file accessed goes in register \"p\", and
the file name goes in \"n\".

By default, the register commands all use the same \"C-x r\"
prefix.  To insert the contents of register \"p\", you would do a
\"C-x r i p\".  You can simplify that operation by re-binding
this to the otherwise underused \"insert\" key with this in your
.emacs file:

   (global-set-key [insert] 'insert-register)

If you dislike the choices of registers \"p\" and \"n\", you can
change them by modifying \\[dired-external-apps-path-register]
and/or \\[dired-external-apps-name-register].  For example, to use
uppercase \"P\" instead of \"p\", add this to your .emacs file:

   (setq dired-external-apps-path-register ?P)

See the emacs manual for more information on using registers:
section 18 on \"Registers\".")


(defvar dired-external-apps-documentation-appendix-misc t
  "This package was developed for GNU Emacs 22 on a GNU/Linux system.
Some testing has been performed on pre-released versions of GNU
Emacs 23 \(cvs emacs as of July 4, 2008\).

Note that the variables beginning with \"dired-external-apps-documentation\"
exist solely to attach user documentation such as this. The values
they're set to is irrelevant.")



;; ========
;; main routine

(defun dired-external-apps-open-file-with (viewer)
  "Opens the current file with the specified viewer.
Saves file path and name to registers 'p' and 'n', and
also pushes the name to the kill-ring.
Changes directory to the location of the file, so that
save-as in the external app will go to the same place.
This works using a shell buffer named \\[dired-external-apps-shell-buffer],
which is where you should look for any error messages.
Telling this to use the viewer 'emacs' will result
in turning handling back over to the running emacs, via
\\[dired-advertised-find-file] (in the case of an image
file, this will typically open the image inside image-mode)."
  (interactive "sOpen file with program: ")
  (let* ( (fullname (dired-get-filename))
          (name     (dired-get-filename "no-dir"))
          (path     (file-name-directory fullname)) ;; alternately, dired-current-directory
          )
    (setq dired-external-apps-last-buffer (current-buffer))
    (setq dired-external-apps-last-point (point))
    (dired-external-apps-file-name-to-ring-and-registers-if-enabled)
    (cond
     ((string-match "emacs" viewer) ;; handle internally by emacs
      (dired-advertised-find-file)
      )
     (t ;; handle with external app
      (progn
        (save-excursion
          (setq cmd1 (concat "cd " (shell-quote-argument path)))
          (setq cmd2 (concat viewer " " (shell-quote-argument name) ))
          (setq cmd (format "%s; %s &" cmd1 cmd2))
          (dired-external-apps-shell-command cmd)
          ))))))

;;===
;; working with the external apps shell buffer

(defun dired-external-apps-shell-create-or-find (buffer)
  "This creates a sub-shell buffer while preserving the existing window layout.
This is very similar to the \\[shell] command from shell.el, but it uses
set-buffer rather than pop-to-buffer.  The BUFFER name is a required argument.

If BUFFER exists but shell process is not running, make new shell.
If BUFFER exists and shell process is running, just switch to BUFFER.
Program used comes from variable `explicit-shell-file-name',
 or (if that is nil) from the ESHELL environment variable,
 or (if that is nil) from `shell-file-name'.

To specify a coding system for converting non-ASCII characters
in the input and output to the shell, use \\[universal-coding-system-argument]
before \\[shell].  You can also specify this with \\[set-buffer-process-coding-system]
in the shell buffer, after you start the shell.
The default comes from `process-coding-system-alist' and
`default-process-coding-system'.

\(Type \\[describe-mode] in the shell buffer for a list of commands.)"
  (interactive "BNew shell buffer name: ")

  (setq buffer (get-buffer-create buffer))
  (set-buffer buffer)

  (unless (comint-check-proc buffer)
    (let* ((prog (or explicit-shell-file-name
		     (getenv "ESHELL") shell-file-name))
           )

           (make-comint-in-buffer "shell" buffer prog)
      (shell-mode))
    (bury-buffer buffer)
    )
  buffer)

(defun dired-external-apps-shell-command (cmd)
  "Run given command in the background in the \\[dired-external-apps-shell-buffer] buffer.
If the supplied CMD string does not end with a \"&\", one will be appended."
  (interactive "sShell command: ")
    (unless (string-match "&[ \t]*$" cmd)
      (setq cmd (concat cmd " &")))
    (save-excursion
      (dired-external-apps-shell-create-or-find dired-external-apps-shell-buffer)
      (insert cmd)
      (condition-case nil
          (comint-send-input)
        (error nil))
      ))


; Note: not in use in this code
(defun dired-external-apps-switch-to-shell ()
  "Switches to the existing \\[dired-external-apps-shell-buffer] buffer or opens a new one."
  (interactive)
    (if (buffer-live-p (get-buffer dired-external-apps-shell-buffer))
          (switch-to-buffer dired-external-apps-shell-buffer)
      (shell dired-external-apps-shell-buffer)
         ))


;; ========
;; snagging file name and path

(defun dired-external-apps-file-name-to-ring-and-registers-if-enabled ()
  "Push current filename (sans path) on kill-ring, save path and name to registers.
The registers \\[dired-external-apps-path-register] and \\[dired-external-apps-name-register]
are used for the path and the name, respectively.
This is just a wrapper around \\[dired-external-apps-file-name-to-ring-and-registers],
which is disabled if \\[dired-external-apps-save-to-registers-flag] is nil."
  (interactive)
  (cond
   ((eq dired-external-apps-save-to-registers-flag t)
    (dired-external-apps-file-name-to-ring-and-registers t) ; filename sans path to kill-ring
    )
   ))

(defun dired-external-apps-file-name-to-ring-and-registers (&optional simple-name-flag)
  "Push current filename onto kill-ring, path to reg p, name to reg n.
By default, pushes the full filename (with path) to the
kill-ring, if a prefix argument is supplied, it pushes the short
form of the filename (sans path) to the kill-ring.
Similarly, when used from code, if the argument SIMPLE-NAME-FLAG
is t, then the file name (sans path) is used, if it is nil (or
absent) the full filename goes to the kill-ring.
Note that this works even if \"dired-external-apps-save-to-registers-flag\"
has been set to nil: this function can be bound to a key which will work
even if this behavior is disabled elsewhere (as it is by default)."
;; Note: the sole purpose of this function is to mess with the
;; users' registers and kill-ring: avoid using this without user approval.
  (interactive "P")
  (unless (string-match "^Dired" mode-name)
    (error "This is not an dired-mode buffer."))
  (let* ( (fullname (dired-get-filename))
          (name     (dired-get-filename "no-dir"))
          (path     (file-name-directory fullname)) ) ;; alternately, dired-current-directory
    (set-register dired-external-apps-path-register path) ;; ?p by default
    (set-register dired-external-apps-name-register name) ;; ?n by default
  (cond
   ((eq simple-name-flag nil)
    (kill-new fullname)
    )
   (t
    (kill-new name)
    ))
    ))


;;===
;; convenience wrappers around dired-external-apps-open-file-with
;; (these are dynamically generated from the dired-external-apps-list list)

(defun dired-external-apps-function-generator (app-name)
  "Function that generates a function to launch an application from dired.
The names for the generated function begins with
\"dired-external-apps-function-prefix\" and ends with the given APP-NAME."
  (interactive "sApplication name: ")
  (let ( ( code
        `(defun ,(intern (concat dired-external-apps-function-prefix app-name)) ()
           ,(format "In dired, opens the current file with %s" app-name)
           ;; TODO add a note there: 'See dired-external-apps-function-generator'
           (interactive)
           (dired-external-apps-open-file-with ,app-name)
           ) )
        )
    (eval code)
  ))

(defun dired-external-apps-generate-wrapper-functions-for-apps ()
  "Generates functions of the form \"dired-external-apps-open-with-APP\".
Each APP is from the list \"dired-external-apps-list\". "
  (interactive)
   (dolist (app-name dired-external-apps-list)
                        (dired-external-apps-function-generator app-name)
                        )
   )

;=======
; initialization

(dired-external-apps-generate-wrapper-functions-for-apps)

;;; dired-external-apps.el ends here



