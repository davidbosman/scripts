<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<!-- Created by htmlize-0.60 in css mode. -->
<html>
  <head>
    <title>iimage.el</title>
    <style type="text/css">
    <!--
      BODY {
        color: #000000;
        background-color: #ffffff;
      } /* default */
      span.warning {
        color: #ff0000;
        background-color: #ffffff;
        font-weight: bold;
      } /* font-lock-warning-face */
      span.type {
        color: #228b22;
        background-color: #ffffff;
      } /* font-lock-type-face */
      span.function-name {
        color: #0000ff;
        background-color: #ffffff;
      } /* font-lock-function-name-face */
      span.string {
        color: #bc8f8f;
        background-color: #ffffff;
      } /* font-lock-string-face */
      span.variable-name {
        color: #b8860b;
        background-color: #ffffff;
      } /* font-lock-variable-name-face */
      span.keyword {
        color: #a020f0;
        background-color: #ffffff;
      } /* font-lock-keyword-face */
      span.constant {
        color: #5f9ea0;
        background-color: #ffffff;
      } /* font-lock-constant-face */
      span.comment {
        color: #b22222;
        background-color: #ffffff;
      } /* font-lock-comment-face */
    -->
    </style>
  </head>
  <body>
    <pre>
<span class="comment">;;; iimage.el --- Inline image minor mode.
</span>
<span class="comment">;; Copyright (C) 2004 Free Software Foundation
</span>
<span class="comment">;; Author: KOSEKI Yoshinori &lt;kose@meadowy.org&gt;
;; Maintainer: KOSEKI Yoshinori &lt;kose@meadowy.org&gt;
;; Keywords: multimedia
</span>
<span class="comment">;; This file is part of GNU Emacs.
</span>
<span class="comment">;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
</span>
<span class="comment">;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
</span>
<span class="comment">;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.
</span>
<span class="comment">;;; Commentary:
</span>
<span class="comment">;; Iimage is a minor mode that displays images, when image-filename
;; exists in the buffer.
;; http://www.netlaputa.ne.jp/~kose/Emacs/iimage.html
;;
;; Add to your `</span><span class="constant">~/.emacs</span><span class="comment">':
;; (autoload 'iimage-mode &quot;iimage&quot; &quot;Support Inline image minor mode.&quot; t)
;; (autoload 'turn-on-iimage-mode &quot;iimage&quot; &quot;Turn on Inline image minor mode.&quot; t)
;;
;; ** Display images in *Info* buffer.
;;
;; (add-hook 'info-mode-hook 'turn-on-iimage-mode)
;;
;; .texinfo:   @file{file://foo.png}
;; .info:      `</span><span class="constant">file://foo.png</span><span class="comment">'
;;
;; ** Display images in Wiki buffer.
;;
;; (add-hook 'wiki-mode-hook 'turn-on-iimage-mode)
;;
;; wiki-file:   [[foo.png]]
</span>
<span class="comment">;;; Code:
</span>
(<span class="keyword">eval-when-compile</span>
  (<span class="keyword">require</span> '<span class="constant">image-file</span>))

(<span class="keyword">defconst</span> <span class="variable-name">iimage-version</span> <span class="string">&quot;1.1&quot;</span>)
(<span class="keyword">defvar</span> <span class="variable-name">iimage-mode</span> nil)
(<span class="keyword">defvar</span> <span class="variable-name">iimage-mode-map</span> nil)

<span class="comment">;; Set up key map.
</span>(<span class="keyword">unless</span> iimage-mode-map
  (setq iimage-mode-map (make-sparse-keymap))
  (define-key iimage-mode-map <span class="string">&quot;\C-l&quot;</span> 'iimage-recenter))

(<span class="keyword">defun</span> <span class="function-name">iimage-recenter</span> (<span class="type">&amp;optional</span> arg)
<span class="string">&quot;Re-draw images and recenter.&quot;</span>
  (interactive <span class="string">&quot;P&quot;</span>)
  (iimage-mode-buffer 0)
  (iimage-mode-buffer 1)
  (recenter arg))

(<span class="keyword">defvar</span> <span class="variable-name">iimage-mode-image-filename-regex</span>
  (concat <span class="string">&quot;[-+./_0-9a-zA-Z]+\\.&quot;</span>
	  (regexp-opt (nconc (mapcar #'upcase
				     image-file-name-extensions)
			     image-file-name-extensions)
		      t)))

(<span class="keyword">defvar</span> <span class="variable-name">iimage-mode-image-regex-alist</span>
  `((,(concat <span class="string">&quot;\\(`?file://\\|\\[\\[\\|&lt;\\|`\\)?&quot;</span>
	      <span class="string">&quot;\\(&quot;</span> iimage-mode-image-filename-regex <span class="string">&quot;\\)&quot;</span>
	      <span class="string">&quot;\\(\\]\\]\\|&gt;\\|'\\)?&quot;</span>) . 2))
<span class="string">&quot;*Alist of filename REGEXP vs NUM.
Each element looks like (REGEXP . NUM).
NUM specifies which parenthesized expression in the regexp.

image filename regex exsamples:
    file://foo.png
    `</span><span class="constant">file://foo.png</span><span class="string">'
    \\[\\[</span><span class="constant">foo.gif</span><span class="string">]]
    &lt;foo.png&gt;
     foo.JPG
&quot;</span>)

(<span class="keyword">defvar</span> <span class="variable-name">iimage-mode-image-search-path</span> nil
<span class="string">&quot;*List of directories to search for image files for iimage-mode.&quot;</span>)

<span class="comment">;;;###</span><span class="warning">autoload</span><span class="comment">
</span>(<span class="keyword">defun</span> <span class="function-name">turn-on-iimage-mode</span> ()
<span class="string">&quot;Unconditionally turn on iimage mode.&quot;</span>
  (interactive)
  (iimage-mode 1))

(<span class="keyword">defun</span> <span class="function-name">turn-off-iimage-mode</span> ()
<span class="string">&quot;Unconditionally turn off iimage mode.&quot;</span>
  (interactive)
  (iimage-mode 0))

<span class="comment">;; Emacs21.3 or earlier does not heve locate-file.
</span>(<span class="keyword">if</span> (fboundp 'locate-file)
    (<span class="keyword">defalias</span> '<span class="function-name">iimage-locate-file</span> 'locate-file)
  (<span class="keyword">defun</span> <span class="function-name">iimage-locate-file</span> (filename path)
    (locate-library filename t path)))

(<span class="keyword">defun</span> <span class="function-name">iimage-mode-buffer</span> (arg)
<span class="string">&quot;Display/Undisplay Images.
With numeric ARG, display the images if and only if ARG is positive.&quot;</span>
  (interactive)
  (<span class="keyword">let</span> ((ing (<span class="keyword">if</span> (numberp arg)
		 (&gt; arg 0)
	       iimage-mode))
	(modp (buffer-modified-p (current-buffer)))
	file buffer-read-only)
    (<span class="keyword">save-excursion</span>
      (goto-char (point-min))
      (<span class="keyword">dolist</span> (pair iimage-mode-image-regex-alist)
	(<span class="keyword">while</span> (re-search-forward (car pair) nil t)
	  (<span class="keyword">if</span> (and (setq file (match-string (cdr pair)))
		   (setq file (iimage-locate-file file
				   (cons default-directory
					 iimage-mode-image-search-path))))
	      (<span class="keyword">if</span> ing
		  (add-text-properties (match-beginning 0) (match-end 0)
				       (list 'display (create-image file)))
		(remove-text-properties (match-beginning 0) (match-end 0)
					'(display)))))))
    (set-buffer-modified-p modp)))

<span class="comment">;;;###</span><span class="warning">autoload</span><span class="comment">
</span>(<span class="keyword">define-minor-mode</span> <span class="function-name">iimage-mode</span>
  <span class="string">&quot;Toggle inline image minor mode.&quot;</span>
  nil <span class="string">&quot; iImg&quot;</span> iimage-mode-map
  (run-hooks 'iimage-mode-hook)
  (iimage-mode-buffer iimage-mode))

(<span class="keyword">provide</span> '<span class="constant">iimage</span>)

<span class="comment">;;; arch-tag: f6f8e29a-08f6-4a12-9496-51e67441ce65
;;; iimage.el ends here
</span></pre>
  </body>
</html>
