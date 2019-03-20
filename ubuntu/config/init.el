;;; Manage/control package systems
(require 'package)
(setq package-archives
  '(("gnu" . "http://elpa.gnu.org/packages/")
    ("melpa" . "http://melpa.org/packages/")
    ("org" . "http://orgmode.org/elpa/")))
(package-initialize)
(setq package-archives
  '(("gnu" . "https://elpa.gnu.org/packages/")
     ("melpa" . "https://melpa.org/packages/")
     ("org" . "http://orgmode.org/elpa/")))
(package-initialize)

(defun require-package (package &optional min-version no-refresh)
  "Install given PACKAGE, optionally requiring MIN-VERSION.
If NO-REFRESH is non-nil, the available package lists will not be
re-downloaded in order to locate PACKAGE."
  (if (package-installed-p package min-version)
    t
    (if (or (assoc package package-archive-contents) no-refresh)
      (if (boundp 'package-selected-packages)
        ;; Record this as a package the user installed explicitly
        (package-install package nil)
        (package-install package))
      (progn
        (package-refresh-contents)
        (require-package package min-version t)))))

(defun maybe-require-package (package &optional min-version no-refresh)
  "Try to install PACKAGE, and return non-nil if successful.
  In the event of failure, return nil and print a warning message.
  Optionally require MIN-VERSION.  If NO-REFRESH is non-nil, the
  available package lists will not be re-downloaded in order to
  locate PACKAGE."
  (condition-case err
    (require-package package min-version no-refresh)
    (error
      (message "Couldn't install optional package `%s': %S" package err)
      nil)))

;;; Add path for customized config .el files
;; (add-to-list 'load-path "~/.emacs.d/site-lisp")
(add-to-list 'load-path "~/.emacs.d/lisp/")

;;; TO-DO: The following is for 'flymake-proc-legacy-flymake' and
;;; needs to be fixed later
;;; Disable warnings
;; (remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake)
(setq warning-minimum-level :error)

;;; Train white spaces
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq whitespace-space-regexp "\\(\u3000+\\)")
(setq whitespace-action '(auto-cleanup))
;; (global-whitespace-mode 1)

;;; Customize variables/faces
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (markdown-mode yaml-mode magit-lfs dockerfile-mode flycheck flymake-shell flymake-json flymake-css ein emacs-setup request web-mode w3m py-autopep8 markdown-preview-mode magit jedi flymake-python-pyflakes autopair auto-complete-auctex auctex anything)))
 '(safe-local-variable-values (quote ((code . utf-8))))
 '(send-mail-function (quote mailclient-send-it)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flymake-errline ((((class color)) (:foreground "#b03060" :weight bold))) t)
 '(flymake-warnline ((((class color)) (:foreground "#afaf5f" :weight bold))) t)
 '(markdown-header-delimiter-face ((t (:inherit org-mode-line-clock))))
 '(markdown-pre-face ((t (:inherit org-formula))))
 '(show-paren-match ((((class color) (background light)) (:background "#b03060")))))

;;; Set encoding
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;;; Disable/Enable backup
(setq make-backup-files nil)
;; (setq backup-directory-alist `(("." . "~/.emacs.d/.backup")))
;;; Disable/Enable auto save
(setq auto-save-default nil)
;; (setq auto-save-file-name-transforms
;;   `((".*" "~/.emacs.d/.auto-save" t)))
;;; Store backup/auto-saved files in /tmp
(setq backup-directory-alist
  `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
  `((".*" ,temporary-file-directory t)))
;;; Show line number
(line-number-mode t)
;; (require 'linum)
;; (global-linum-mode 1)
;; (setq linum-format "%4d ")
;;; Show column number
(column-number-mode t)
;;; Scroll one line at a time
(setq scroll-conservatively 1)
;;; Show file size
(size-indication-mode t)
;;; Show date and time
(setq display-time-24hr-format t)
(display-time-mode t)

;;; Show pairs (), {}, []
(show-paren-mode t)
;; (show-paren-mode 1)
(setq show-paren-style 'parenthesis)
(setq show-paren-delay 0)
(setq show-paren-style 'single)

;;; Enable auto-completion
(add-to-list 'load-path "~/.emacs.d/site-lisp/anything-config/")

(require 'anything)
;; (require 'anything-config)
(require 'anything-match-plugin)
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

;;; Set default spell checker
(setq-default ispell-program-name "aspell")

;;; C
;; Set default C indentation
; (setq-default c-basic-offset 4)
(defun my-c-mode-hook ()
  (c-set-style "linux")
  ; (c-set-style "bsd")
  (setq tab-width 4)
  (setq c-basic-offset tab-width))
(add-hook 'c-mode-hook 'my-c-mode-hook)
(setq-default indent-tabs-mode nil)
(setq indent-line-function 'indent-relative-maybe)

;;; Python
;; Set default Python indentation
;; python-mode
; (setq-default c-basic-offset 4)
(setq-default python-indent-guess-indent-offset nil)
(autoload 'python-mode "python-mode" "Python Mode" t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
;; Use IPython as the default Python shell
;; (setq ipython-command ".pyenv/shims/ipython")
;; (require 'ipython)
;; (setq python-shell-interpreter "ipython"
;;   python-shell-interpreter-args "-i")
;; jedi
(require 'epc)
(require 'python)
;; (setenv "PYTHONPATH" "/Users/msato/.pyenv/versions/py36/lib/python3.6/site-packages")
(require 'jedi)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)
; (define-key python-mode-map "\C-ct" 'jedi:goto-definition)
; (define-key python-mode-map "\C-cb" 'jedi:goto-definition-pop-marker)
; (define-key python-mode-map "\C-cr" 'helm-jedi-related-names)
;; pyflakes
(flymake-mode t)
(require 'flymake-python-pyflakes)
(add-hook 'python-mode-hook 'flymake-python-pyflakes-load)
(add-hook 'find-file-hook 'flymake-find-file-hook)
(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "~/.pyenv/shims/pyflakes" (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pyflakes-init)))
; show message on mini-buffer
(defun flymake-show-help ()
  (when (get-char-property (point) 'flymake-overlay)
    (let ((help (get-char-property (point) 'help-echo)))
      (if help (message "%s" help)))))
(add-hook 'post-command-hook 'flymake-show-help)
;; auto-pep8
(require 'py-autopep8)
(setq py-autopep8-options '("--max-line-length=79"))
(setq flycheck-flake8-maximum-line-length 79)
(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)
;; autopair
(autoload 'autopair-global-mode "autopair" nil t)
(autopair-global-mode)
(add-hook 'python-mode-hook
  #'(lambda ()
      (push '(?' . ?')
        (getf autopair-extra-pairs :code))
      (setq autopair-handle-action-fns
        (list #'autopair-default-handle-action
        #'autopair-python-triple-quote-action))))

;;; JavaScript
(defun js-mode-hook ()
  "Hooks for js mode."
  (setq indent-tabs-mode nil))
(add-hook 'js-mode-hook 'js-mode-hook)

;;; Web
;; flymake
(delete '("\\.html?\\'" flymake-xml-init) flymake-allowed-file-name-masks)
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.css?\\'" . web-mode))
(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-attr-indent-offset 2)
  (setq web-mode-html-offset 2)
  (setq web-mode-css-offset 2)
  (setq web-mode-script-offset 2)
  (setq web-mode-php-offset 2)
  (setq web-mode-java-offset 2)
  (setq web-mode-asp-offset 2)
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 2)
  (setq tab-width 2)
  (setq web-mode-enable-css-colorization t)
  (setq web-mode-extra-auto-pairs
      '(("erb"  . (("beg" "end")))
        ("php"  . (("beg" "end")
                   ("beg" "end")))
       ))
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-enable-current-column-highlight t)
  (setq web-mode-ac-sources-alist
       '(("css" . (ac-source-css-property))
              ("html" . (ac-source-words-in-buffer ac-source-abbrev))))
)
(add-hook 'web-mode-hook  'my-web-mode-hook)

;;; PHP
(autoload 'php-mode "php-mode" "Major mode for editing PHP code." t)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))
;; Set default PHP indentation
(defun php-indent-hook ()
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 4)
  ;; (c-set-offset 'case-label '+)
  (c-set-offset 'arglist-intro '+)
  (c-set-offset 'arglist-close 0))
(add-hook 'php-mode-hook 'php-indent-hook)
;; Auto-complete for PHP
(defun php-completion-hook ()
  (when (require 'php-completion nil t)
   (php-completion-mode t)
   (define-key php-mode-map (kbd "C-o") 'phpcmp-complete)
   (when (require 'auto-complete nil t)
     (make-variable-buffer-local 'ac-sources)
     (add-to-list 'ac-sources 'ac-source-php-completion)
     (auto-complete-mode t))))
(add-hook 'php-mode-hook 'php-completion-hook)

;;; Markdown
(autoload 'markdown-mode "markdown-mode" "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;;; Git
;; (require 'magit)
;; (setq magit-view-git-manual-method 'man)

;;; Docker
(require 'dockerfile-mode)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

;;; YAML
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.ya?ml$" . yaml-mode))
(define-key yaml-mode-map "\C-m" 'newline-and-indent)

;;;IPython Notebook
;; (require 'ein)
;; (require 'ein-loaddefs)
;; (require 'ein-notebook)
;; (require 'ein-subpackages)
;; (add-hook 'ein:connect-mode-hook 'ein:jedi-setup)

(put 'set-goal-column 'disabled nil)