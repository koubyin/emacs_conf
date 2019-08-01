;=========================================================================
; 日本語環境設定
;=========================================================================
;; 日本語環境
(set-language-environment 'Japanese)
;; デフォルトの文字コードをutf-8に
(prefer-coding-system 'utf-8)
(setq default-input-method "MacOSX")

;=========================================================================
; フォント設定
;=========================================================================
(create-fontset-from-ascii-font
 "Menlo-14:weight=normal:slant=normal"
 nil
 "menlokakugo")
 
(set-fontset-font
 "fontset-menlokakugo"
 'unicode
 (font-spec :family "Hiragino Kaku Gothic ProN")
 nil
 'append)
 
(add-to-list 'default-frame-alist '(font . "fontset-menlokakugo"))
(setq face-font-rescale-alist '(("Hiragino.*" . 1.2)))

;=========================================================================
; パス設定
;=========================================================================
;; emacsにパスを通す
(dolist (dir (list
              "/sbin"
              "/usr/sbin"
              "/bin"
              "/usr/bin"
              "/usr/local/bin"
              (expand-file-name "~/bin")
              (expand-file-name "~/.emacs.d/bin")
              ))
;; PATH と exec-path に同じ物を追加します
(when (and (file-exists-p dir) (not (member dir exec-path)))
  (setenv "PATH" (concat dir ":" (getenv "PATH")))
  (setq exec-path (append (list dir) exec-path))))

;=========================================================================
; load-path
;=========================================================================
;; load-path を追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
;(add-to-load-path "elisp" "conf" "public_repos")
(add-to-load-path "site-lisp" "elpa")


;=========================================================================
; グローバルキーマップ
;=========================================================================
;; '¥' を入力したら '\' となるように
(define-key global-map [?¥] [?\\])

(global-set-key "\C-cg" 'goto-line)
(global-set-key [C-tab] 'other-window)
(defun reload-dotemacs()
  (interactive)
  (load-library "~/.emacs.d/init.el")
)
(global-set-key "\C-c\C-r" 'reload-dotemacs)
(defun other-window-backward ()
  "Select the previous window."
  (interactive)
  (other-window -1)) 
(global-set-key "\C-co" 'other-window-backward)
(global-set-key "\C-c>" 'comment-region)
(global-set-key "\C-c<" 'uncomment-region)

;; 現在の行の上に空行挿入
(global-set-key "\C-l" "\C-a\C-j\C-p")
;; 現在の行の下に空行挿入
(global-set-key "\C-o" "\C-e\C-j")
(global-set-key (kbd "C-m") 'newline-and-indent)
;; C-hをバックスペースに
(global-set-key "\C-h" 'delete-backward-char)
;; "C-t" でウィンドウを切り替える。初期値はtranspose-chars
(define-key global-map (kbd "C-t") 'other-window)

;; Control + すべてのキー　を無視する
;(mac-add-ignore-shortcut '(control))

;; 行数表示
;(global-linum-mode t)

;; スタートアップページを表示しない
(setq inhibit-startup-message t)

;; バックアップファイルを作らない
;(setq backup-inhibited t)

;; Macのキーバインドを使う。optionをメタキーにする。
;(mac-key-mode 1)
;(setq mac-option-modifier 'meta)

;; Command-Key and Option-Key
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

;; タブキー
;(setq default-tab-width 4)
(setq tab-width 4)
(setq indent-line-function 'indent-relative-maybe)

;; シフト + 矢印で範囲選択
;(setq pc-select-selection-keys-only t)
;(pc-selection-mode 1)

;; mark時に反転をOFF
(setq-default transient-mark-mode nil)

;==========================================================================================
; package list設定
;==========================================================================================
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

;package.elでインストールされたパッケージリストの保存先をcustom.elへ(init.elに追記させない)				       
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;==========================================================================
; color-theme
;==========================================================================
(cond
 (window-system
  ;(require 'color-theme)
  ;(color-theme-initialize)
  ;(color-theme-gnome2)
  (load-theme 'gnome2 t t)
  (enable-theme 'gnome2)
  )
 )

;==========================================================================
; auto-complete
;==========================================================================
(when (require 'auto-complete-config nil t)
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default)
  (setq ac-use-menu-map t)
  (setq ac-ignore-case nil)
  )

;==========================================================================
; python-mode
;==========================================================================
(require 'python-mode)
(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist (cons '("python" . python-mode)
                                   interpreter-mode-alist))
(autoload 'python-mode "python-mode" "Python editing mode." t)

(add-hook 'python-mode-hook
	  '(lambda()
	     (define-key python-mode-map "\C-c>" 'comment-region)
	     (define-key python-mode-map "\C-c<" 'uncomment-region)
	     ))

;==========================================================================
; octave-mode
;==========================================================================
(setq auto-mode-alist
    (cons '("\\.m$" . octave-mode)auto-mode-alist))

;==========================================================================
; Helm
;==========================================================================
(require 'helm-config)
