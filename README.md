dotemacs
========

my Emacs configuration

========

很多包需要在 melpa 下载， 使用 emacs24 会比较方便。

使用的包在需要的时候，如果没有安装，会自动在 melpa 下载。

使用方法:

    下载 dotemacs : git clone https://github.com/smallzhan/dotemacs.git 
    ln -s <path/to/dotemacs> ~/myEmacs; ln -s <path/to/dotemacs/config/init.el> ~/.emacs
    emacs

========
已知问题：
 org-8 第一次从 melpa 安装的时候会有些函数有问题，据说是 melpa 的问题，没求证，也不知道怎么从源头解决。
 解决方法很简单，将 elpa/org-xxxx 里面的所有的 elc 文件全部删除就可以了，等所有的包载入正常之后再去将 org byte-compie 一下即可。
