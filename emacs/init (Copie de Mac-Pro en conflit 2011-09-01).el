;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; require
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'simple-journal)
(require 'pager)
;;(require 'darkroom-mode)
;; (require 'zoom-frm)
;;(require 'org)
;;(require 'org-install)
;; Load weblogger
(require 'weblogger)
(add-hook 'write-file-hooks 'time-stamp)
(load-file "~/Dropbox/perso/scripts/emacs/emacs.d/weblogger.el")
(global-set-key "\C-cbs" 'weblogger-start-entry)
;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; org mode
;;
;;;;;;;;;;;;;;;;;;;;;;;;

;;(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;;(define-key global-map "\C-cl" 'org-store-link)
;;(define-key global-map "\C-ca" 'org-agenda)
;;(setq org-log-done t)


;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Markdown
;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Markdown mode
(autoload 'markdown-mode "markdown-mode.el"
   "Major mode for editing Markdown files" t)
(setq auto-mode-alist
   (cons '("\\.markdown" . markdown-mode) auto-mode-alist))
   
   
   
   (setq auto-mode-alist
      (append '(
                ("\\.blog$" . markdown-mode)
                ("\\.markdown$" . markdown-mode)
                ("\\.md$" . markdown-mode)
                ("\\.gclient$" . python-mode)
                ) auto-mode-alist))


;;;;;;;;;;;;;;;;;;;
;; 
;; settings
;;
;;;;;;;;;;;;;;;;;;;


(require 'pager)
     (global-set-key "\C-v"	   'pager-page-down)
     (global-set-key [next] 	   'pager-page-down)
     (global-set-key "\ev"	   'pager-page-up)
     (global-set-key [prior]	   'pager-page-up)
     (global-set-key '[M-up]    'pager-row-up)
     (global-set-key '[M-kp-8]  'pager-row-up)
     (global-set-key '[M-down]  'pager-row-down)
     (global-set-key '[M-kp-2]  'pager-row-down)

(setq template-home-directory "~/Dropbox/perso/scripts/emacs/templates")

(defun goinit () 
  (interactive) 
  (find-file "~/Dropbox/perso/scripts/emacs/init.el"))

(defun goj () 
  (interactive) 
  (find-file "~/Documents/perso/Archives/2011-journal.markdown"))

;; Informations qui peuvent être utiles à Emacs pour remplir certains champs
;; et configurer correctement certains modes.
(setq user-full-name "David Bosman")
(setq user-mail-address "david@davidbosman.fr")

;; Sauvegarde d'une session à l'autre de l'historique des commandes et des
;; fichiers ouverts
(savehist-mode 1)


;; DON'T ADD LINES at the end of buffer when trying to scroll past end
;;(setq next-line-add-newlines nil)

;;
;; shift + click select region

;;(define-key global-map (kbd "<S-down-mouse-1>") 'ignore) ; turn off font dialog
;;(define-key global-map (kbd "<S-mouse-1>") 'mouse-set-point)
;;(put 'mouse-set-point 'CUA 'move)

;;
;; default folder is in my Dropbox:
;;
(setq default-directory "~/Documents/perso/Archives/" )

;;
;; don't clutter folders with backups. Group them in a hidden folder in ~.
;;
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.saves"))    ; don't litter my fs tree
       version-control t     ; use versioned backups
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups


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
(defun make-auto-save-file-name ()
  "Return file name to use for auto-saves of current buffer.."
  (if buffer-file-name
      (if (file-exists-p "~/.autosaves/") 
          (concat (expand-file-name "~/.autosaves/") "#"
                  (replace-regexp-in-string "/" "!" buffer-file-name)
                  "#") 
         (concat
          (file-name-directory buffer-file-name)
          "#"
          (file-name-nondirectory buffer-file-name)
          "#"))
    (expand-file-name
     (concat "#%" (buffer-name) "#"))))


;;
;; do not change original file creation date:
;;
(setq backup-by-copying t)

;; remember recent files
;; Get list with C-x C-row
;;
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 30)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)


;;
;; Make all "yes or no" prompts show "y or n" instead
;;
(fset 'yes-or-no-p 'y-or-n-p)

;; Selon les règles typographiques françaises, le point final d'une
;; phrase n'est suivi que d'un seul espace (contre deux dans la
;; tradition anglo-saxonne). Il est utile qu'Emacs le sache pour
;; formater correctement les textes.
(setq sentence-end-double-space nil)
  
;;(set-language-environment "UTF-8")

;; no splash screen
(setq inhibit-startup-message t)
(setq auto-revert-mode t)
;;(setq scroll-bar-mode -1)
(setq ring-bell-function 'ignore)
(blink-cursor-mode (- (*) (*) (*)))
;;(blink-cursor-mode 0)
(tool-bar-mode 0)
(menu-bar-mode 1)
(toggle-scroll-bar -1) 

;;(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
;;(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;;(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

(mouse-avoidance-mode 'animate)

;;
;; Soft line break LOVE
;; source: http://penguinpetes.com/b2evo/index.php?title=howto_make_emacs_use_soft_word_wrap_like&more=1&c=1&tb=1&pb=1.
;;
;
;;(autoload 'longlines-mode "longlines.el" "Minor mode for editing long lines." t)
;;(add-hook 'text-mode-hook 'longlines-mode)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(setq-default fill-column 70)
;;
;;define Markdown as default mode for unknown files
(setq default-major-mode 'markdown-mode)

;; Activate soft line wrap (see longlines) whe in Markdown   
(add-hook 'markdown-mode-common-hook 'longlines-minor-mode t)   


;;
;; minubuffer display time
;;

;;(setq display-time-day-and-date t
;;                display-time-24hr-format t)
;;             (display-time)

;; Afficher l'heure dans la barre d'état (format 24 heures)
(display-time)
(setq display-time-24hr-format 1)

;; change complete-tag to this since M-TAB bound to Mac Change
;; Application
;;
(global-set-key (kbd "M-<return>") 'complete-tag)
     
;; Color theme
;;
;;(require 'color-theme)
;;(setq color-theme-is-global t)
;;(color-theme-subtle-hacker)


;; some standard keyboard shortcuts 
;; and less standards one:
;;
(global-set-key (kbd "M-j") 'previous-buffer)
(global-set-key (kbd "M-k") 'next-buffer)
(global-set-key (kbd "M-n") "~")
(global-set-key [f2] 'split-window-horizontally) 
(global-set-key [f1] 'delete-other-windows) 
(global-set-key [(control z)] `undo)
(global-set-key [(meta v)] `yank)
(global-set-key [(meta c)] `kill)
(global-set-key [(control o)] 'find-file)
(global-set-key [(control n)] 'find-file-other-frame)
(global-set-key [(control s)] 'save-buffer)
(global-set-key [(meta s)] 'write-file)
;;(global-set-key [(kbd "C-c c")] `yank)
;;(global-set-key (kbd "C-z") 'undo)
;;(global-set-key (kbd "M-i") 'previous-line) ; was tab-to-tab-stop
;;(global-set-key (kbd "M-j") 'backward-char) ; was indent-new-comment-line
;;(global-set-key (kbd "M-k") 'next-line) ; was kill-sentence
;;(global-set-key (kbd "M-l") 'forward-char)  ; was downcase-word
;;(global-set-key (kbd "C-c v") 'yank) ; paste.
;;(global-set-key (kbd "M-SPC") 'set-mark-command) ; was just-one-space
;;(global-set-key (kbd "C-c w") 'text-mode); soft line wrap as an editor see bottom
(global-set-key [f1] 'text-mode); soft line wrap as an editor see bottom

;; visual line mode : do not cut words
;;
;;(add-hook 'text-mode-hook 'turn-on-visual-line-mode)


;; Simple titlebar with only the filename 
;;
(setq frame-title-format '("" "%b"))

(setq x-select-enable-clipboard t)

;; Remember position in files between sessions 
;;
(require 'saveplace)
(setq-default save-place t)

;; highlight the current line:
;;
;;(global-hl-line-mode 1)
;; To customize the background color
;;(set-face-background 'hl-line "#93c3ce")


;; when you mark a region, you can delete it or replace it as in other Windows programs: 
;; simply hit delete or type whatever you want or yank
(delete-selection-mode 1)


;; L'outil de correction orthographique « ispell » doit utiliser le
;; thésaurus français.
(require 'ispell)
(setq ispell-dictionary "francais")


;; Prise en charge de la molette de la souris.
;; Utilisée seule, la rotation de la molette provoque un défilement de
;; 5 lignes par cran. Combinée à la touche Shift, le défilement est
;; réduit à une ligne. Combinée à la touche Control, le défilement
;; s'effectue page (1 hauteur de fenêtre) par page.
(require 'mwheel)
(mouse-wheel-mode 1)

;; Lorsqu'il reformate un paragraphe, Emacs doit respecter les règles de
;; typographie française et ne pas sauter à la ligne avant un signe de
;; ponctuation double ou des guillemets ouvrants.
(setq fill-nobreak-predicate '(fill-french-nobreak-p))

;; Selon les règles typographiques françaises, le point final d'une phrase
;; n'est suivi que d'un seul espace (contre deux dans la tradition
;; anglo-saxonne). Il est utile qu'Emacs le sache pour formater correctement
;; les textes.
(setq sentence-end-double-space nil)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; functions
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;


;;
;; 2 or 3 splits ?
;; source:
;;
(defun my-big-screen ()
  "Set up frame for external screen, with three windows."
  (interactive)
  (my-initialize-frame 3))

(defun my-split ()
  "Set up frame for laptop screen, with two windows."
  (interactive)
  (my-initialize-frame 2))

(defun my-initialize-frame (columns)
  "Set current frame to fullscreen and split it into COLUMNS
vertical windows."
  (set-frame-parameter nil :fullscreen t)
  (delete-other-windows)
  (dotimes (not-used (1- columns))
    (split-window-horizontally))
  (balance-windows))

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
;; Zoom text as in a browser
;; source: http://emacs-fu.blogspot.com/2008/12/zooming-inout.html
;;
(defun djcb-zoom (n)
  "with positive N, increase the font size, otherwise decrease it"
  (set-face-attribute 'default (selected-frame) :height 
    (+ (face-attribute 'default :height) (* (if (> n 0) 1 -1) 10)))) 
(global-set-key (kbd "C-+")      '(lambda nil (interactive) (djcb-zoom 1)))
(global-set-key [C-kp-add]       '(lambda nil (interactive) (djcb-zoom 1)))
(global-set-key (kbd "C--")      '(lambda nil (interactive) (djcb-zoom -1)))
(global-set-key [C-kp-subtract]  '(lambda nil (interactive) (djcb-zoom -1)))    
    
;; 
;; (Can not make it work On OS X)
;; Fullscreen mode, nothing but the text
;; source: http://mikerowecode.com/2009/05/emacs-full-screen.html:
;;
(defun toggle-fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen (if (frame-parameter nil 'fullscreen)
                                           nil
                                           'fullboth)))
;;Keyboard shortcut:
(global-set-key [(M-return)] 'toggle-fullscreen)

;; C-x 4 f find file in other window
;;(find-file "~/Dropbox/perso/Archives/.emptyfile.txt")
;;((set-window-buffer new-win buffer)
;;(find-file "~/Dropbox/perso/Archives/2011-journal.markdown"))

;; insert date
;;
(defun insert-date (prefix)
  "Insert the current date. With prefix-argument, use ISO format. With
   two prefix arguments, write out the day and month name."
  (interactive "P")
  (let ((format (cond
                 ((not prefix) "%A, %B %d, %Y")
                 ((equal prefix '(4)) "%m-%d-%Y")
                 ((equal prefix '(16)) "%m.%d.%Y"))))
    (insert (format-time-string format))))

;; Insertion de date au format AAAA-MM-JJ
(defun insert-iso-date-string ()
  "Insert a nicely formated date string."
  (interactive)
  (insert (format-time-string "%Y-%m-%d")))
;; La séquence « C-c d » insère la date
(global-set-key [(control c) (d)] 'insert-iso-date-string)


;; Insertion de date en clair JJ Mois AAAA
(defun insert-text-date-string ()
  "Insert a nicely formated date string."
  (interactive)
  (insert (format-time-string "%d %B %Y")))
;; La séquence « C-c S-d » insère la date
(global-set-key [(control c) (shift d)] 'insert-text-date-string)


;; Insertion d'horodate au format AAAA-MM-JJ HH:NN:SS
(defun insert-iso-time-string ()
  "Insert a nicely formated timestamp string."
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M:%S")))
;; La séquence « C-c t » insère l'horodate
(global-set-key [(control c) (t)] 'insert-iso-time-string)


;; Insertion d'horodate au format AAAA-MM-JJ HH:NN:SS
(defun insert-text-time-string ()
  "Insert a nicely formated timestamp string."
  (interactive)
  (insert (format-time-string "%d %B %Y à %H:%M:%S")))
;; La séquence « C-c S-t » insère l'horodate
(global-set-key [(control c) (shift t)] 'insert-text-time-string)

;;;;;;;;;;;;;;;;;;;;;;;
;;
;; templates
;;
;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;
;;
;; simple journal
;;
;;;;;;;;;;;;;;;;;;;;;;;

(defun insert-day ()
  (interactive)
  (insert (format-time-string "%Y-%m%d @ ")))
(defun insert-time ()
  (interactive)
  (insert (format-time-string "%H:%M")))
(defun journal () 
  (interactive) 
  (find-file "~/Dropbox/perso/Archives/2011-journal.markdown")
  (end-of-buffer)
  (insert "\n")
  (insert "### ")
  (insert-day)
;;  (insert "\n\n")
;;  (insert "#### ")
  (insert-time) 
  (insert "  \n") 
)


(defun markdown-insert-time ()
  (interactive)
  (insert (format-time-string "### %H:%M\n")))

;;(global-set-key '[M-it]    'insert-time)
;;(define-key global-map '[M-x mit] 'markdown-insert-time)
(global-set-key (kbd "C-S-t") 'markdown-insert-time) 


;; convert multilines § in a single line
;; http://people.gnome.org/~federico/news-2011-05.html#11
(defun unfill-paragraph ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(defun unfill-region ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-region (region-beginning) (region-end) nil)))

(define-key global-map "\M-Q" 'unfill-paragraph)
(define-key global-map "\C-\M-q" 'unfill-region)
