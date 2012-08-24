;;(require 'darkroom-mode)
;; (require 'zoom-frm)
;;(require 'org)
;;(require 'org-install)
;; Load weblogger

;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; org mode
;;
;;;;;;;;;;;;;;;;;;;;;;;;

;;(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;;(define-key global-map "\C-cl" 'org-store-link)
;;(define-key global-map "\C-ca" 'org-agenda)
;;(setq org-log-done t)

;;(set-foreground-color "black")
;;(set-window-margins nil 20 100)
;;(setq left-fringe-width 45)

;; (require 'pager)
;;      (global-set-key "\C-v"	   'pager-page-down)
;;      (global-set-key [next] 	   'pager-page-down)
;;      (global-set-key "\ev"	   'pager-page-up)
;;      (global-set-key [prior]	   'pager-page-up)
;;      (global-set-key '[M-up]    'pager-row-up)
;;      (global-set-key '[M-kp-8]  'pager-row-up)
;;      (global-set-key '[M-down]  'pager-row-down)
;;      (global-set-key '[M-kp-2]  'pager-row-down)



;; DON'T ADD LINES at the end of buffer when trying to scroll past end
;;(setq next-line-add-newlines nil)

;;
;; shift + click select region

;;(define-key global-map (kbd "<S-down-mouse-1>") 'ignore) ; turn off font dialog
;;(define-key global-map (kbd "<S-mouse-1>") 'mouse-set-point)
;;(put 'mouse-set-point 'CUA 'move)


;;
;; don't clutter folders with backups. Group them in a hidden folder in ~/
;;
;; (setq
;;    backup-by-copying t      ; don't clobber symlinks
;;    backup-directory-alist
;;     '(("." . "~/.saves"))    ; don't litter my fs tree
;;        version-control t     ; use versioned backups
;;    delete-old-versions t
;;    kept-new-versions 6
;;    kept-old-versions 2
;;    version-control t)       ; use versioned backups
  
;;(set-language-environment "UTF-8")
;;(setq scroll-bar-mode -1)
;;(blink-cursor-mode 0)



;;(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
;;(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;;(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;;
;; minubuffer display time
;;

;;(setq display-time-day-and-date t
;;                display-time-24hr-format t)
;;             (display-time)

     
;; Color theme
;;
;;(require 'color-theme)
;;(setq color-theme-is-global t)
;;(color-theme-subtle-hacker)

;; visual line mode : do not cut words
;;
;;(add-hook 'text-mode-hook 'turn-on-visual-line-mode)



;;
;; 2 or 3 splits ?
;; source:
;;
;;(defun my-big-screen ()
;;  "Set up frame for external screen, with three windows."
;;  (interactive)
;;  (my-initialize-frame 3))

;;(defun my-split ()
;;  "Set up frame for laptop screen, with two windows."
;;  (interactive)
;;  (my-initialize-frame 2))

;;(defun my-initialize-frame (columns)
;;  "Set current frame to fullscreen and split it into COLUMNS
;;vertical windows."
;;  (set-frame-parameter nil :fullscreen t)
;;  (delete-other-windows)
;;  (dotimes (not-used (1- columns))
  ;;  (split-window-horizontally))
;;  (balance-windows))

;;(defun now-focus! ()
;;  "Open the current buffer in a frame without any bling."
;;  (interactive)
  ;; to restore:
  ;; (setq mode-line-format (default-value 'mode-line-format))
  ;;(let ((frame (nowfocus-make-minimal-frame)))
  ;;  (select-frame frame)
  ;;  (setq mode-line-format nil)
    ;; for Windows, untested
  ;;  (when (fboundp 'w32-send-sys-command)
  ;;    (w32-send-sys-command 61488 frame))))

;;(defun nowfocus-make-minimal-frame ()
;;  (make-frame '((minibuffer . nil)
;;		(vertical-scroll-bars . nil)
;;		(left-fringe . 0)
;;		(right-fringe . 0)
;;		(border-width . 0)
;;		(internal-border-width . 64) ; whitespace!
;;		(cursor-type . box)
;;		(menu-bar-lines . 0)
;;		(tool-bar-lines . 0)
;;		(fullscreen . fullboth)
;;		(unsplittable . t))))

;;
;; auto launch split screen  
;;
;;(run-with-idle-timer 0.1 nil 'my-split)



    
;; 
;; (Can not make it work On OS X)
;; Fullscreen mode, nothing but the text
;; source: http://mikerowecode.com/2009/05/emacs-full-screen.html:
;;
;;(defun toggle-fullscreen ()
;;  (interactive)
;;  (set-frame-parameter nil 'fullscreen (if (frame-parameter nil 'fullscreen)
;;                                           nil
;;                                           'fullboth)))
;;Keyboard shortcut:
;;(global-set-key [(M-return)] 'toggle-fullscreen)




;; C-x 4 f find file in other window
;;(find-file "~/Dropbox/perso/Archives/.emptyfile.txt")
;;((set-window-buffer new-win buffer)
;;(find-file "~/Dropbox/perso/Archives/2011-journal.markdown"))




;; redefining the make-backup-file-name function in order to get
;; backup files in ~/.backups/ rather than scattered around all over
;; the filesystem. Note that you must have a directory ~/.backups/
;; made.  This function looks first to see if that folder exists.  If
;; it does not the standard backup copy is made.
;; source: http://www-users.math.umd.edu/~halbert/getcontent.cgi?code+emacs
;;(defun make-backup-file-name (file-name)
;;  "Create the non-numeric backup file name for `file-name'."
;;  (require 'dired)
;;  (if (file-exists-p "~/.saves")
;;      (concat (expand-file-name "~/.saves/")
;;              (dired-replace-in-string "/" "!" file-name))
;;    (concat file-name "~")))

;; redefining the make-auto-save-file-name function in order to get
;; autosave files sent to a single directory.  Note that this function
;; looks first to determine if you have a ~/.autosaves/ directory.  If
;; you do not it proceeds with the standard auto-save procedure.
;; source: http://www-users.math.umd.edu/~halbert/getcontent.cgi?code+emacs
;; (defun make-auto-save-file-name ()
;;   "Return file name to use for auto-saves of current buffer.."
;;   (if buffer-file-name
;;       (if (file-exists-p "~/.autosaves/") 
;;           (concat (expand-file-name "~/.autosaves/") "#"
;;                   (replace-regexp-in-string "/" "!" buffer-file-name)
;;                   "#") 
;;          (concat
;;           (file-name-directory buffer-file-name)
;;           "#"
;;           (file-name-nondirectory buffer-file-name)
;;           "#"))
;;     (expand-file-name
;;      (concat "#%" (buffer-name) "#"))))

