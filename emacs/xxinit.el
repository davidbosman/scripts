;; disable annoying backups and autosaves
(setq backup-inhibited t)
(setq auto-save-default nil)

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

;; ============== Markdown ==============

;;define Markdown as default mode for unknown files
(setq default-major-mode 'markdown-mode)

;; ============= Windows ==============

;; Activate soft line wrap (see longlines) whe in Markdown   
(add-hook 'markdown-mode-common-hook 'longlines-minor-mode t)   

;; ============== default font ==============

(set-frame-font "Ubuntu-14")
(set-frame-font "Courier 10 Pitch-14")

;; narrower window, better line wrapping for prose
(defun write-words ()
  (interactive)
  (set-frame-width nil 90)
  (global-visual-line-mode t)
  (setq mode-line-format nil)
  (show-paren-mode nil))

;; widescreen, no line-wrap
(defun write-code ()
  (interactive)
  ;;(set-frame-width nil 320)
  (set-frame-height nil 95)
  (global-visual-line-mode 0)
  (show-paren-mode)
  (setq mode-line-format
    (list "-"
      'mode-line-mule-info
      'mode-line-modified
      'mode-line-frame-identification
      'mode-line-buffer-identification
      "   "
      'mode-line-position
      '(vc-mode vc-mode)
      "   "
      'mode-line-modes
      '(which-func-mode ("" which-func-format))
      '(global-mode-string (global-mode-string))
      )))

(global-set-key (read-kbd-macro "C-x w") 'write-words)
(global-set-key (read-kbd-macro "C-x c") 'write-code)

;; ============== Mouse ==================
;; Prise en charge de la molette de la souris.
;; Utilisée seule, la rotation de la molette provoque un défilement de
;; 5 lignes par cran. Combinée à la touche Shift, le défilement est
;; réduit à une ligne. Combinée à la touche Control, le défilement
;; s'effectue page (1 hauteur de fenêtre) par page.
(require 'mwheel)
(mouse-wheel-mode 1)

;; ============= TRASH ==========
; deleting files goes to OS's trash folder
(setq delete-by-moving-to-trash t) ; “t” for true, “nil” for false

;; ============ WORD COUNT ===========

(setq load-path (cons (expand-file-name "~/elisp") load-path))
 (autoload 'word-count-mode "word-count"
          "Minor mode to count words." t nil)
 (global-set-key (quote [f6]) 'word-count-mode)
