class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated every 25 releases on multiples of 25
  url "https://github.com/vim/vim/archive/v8.2.2975.tar.gz"
  sha256 "646c7f8346b3bcd4268f2c7cd03a529a23a47eaadbc800da9490b707b5710c0b"
  license "Vim"
  head "https://github.com/vim/vim.git"

  bottle do
    sha256 arm64_big_sur: "1312e876ed6e94d1fc59a4e2a0f1b8b890c1a0afb8410e9c1cee8f9534b528f2"
    sha256 big_sur:       "3a150b8e276558176cb980c50231ad7d7f0ea832b6278a341341af461e77fcc6"
    sha256 catalina:      "658ba615539468033852788e1503137e63ae9003f6e732355cf1a3dfc99b1e55"
    sha256 mojave:        "2dc9a51148274ca02e9fd9c3cec1b598d27710db47105249d776c8855ebd0511"
  end

  depends_on "gettext"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.9"
  depends_on "ruby"

  conflicts_with "ex-vi",
    because: "vim and ex-vi both install bin/ex and bin/view"

  conflicts_with "macvim",
    because: "vim and macvim both install vi* binaries"

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"

    # https://github.com/Homebrew/homebrew-core/pull/1046
    ENV.delete("SDKROOT")

    # vim doesn't require any Python package, unset PYTHONPATH.
    ENV.delete("PYTHONPATH")

    # We specify HOMEBREW_PREFIX as the prefix to make vim look in the
    # the right place (HOMEBREW_PREFIX/share/vim/{vimrc,vimfiles}) for
    # system vimscript files. We specify the normal installation prefix
    # when calling "make install".
    # Homebrew will use the first suitable Perl & Ruby in your PATH if you
    # build from source. Please don't attempt to hardcode either.
    system "./configure", "--prefix=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}",
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          "--with-compiledby=Homebrew",
                          "--enable-cscope",
                          "--enable-terminal",
                          "--enable-perlinterp",
                          "--enable-rubyinterp",
                          "--enable-python3interp",
                          "--enable-gui=no",
                          "--without-x",
                          "--enable-luainterp",
                          "--with-lua-prefix=#{Formula["lua"].opt_prefix}"
    system "make"
    # Parallel install could miss some symlinks
    # https://github.com/vim/vim/issues/1031
    ENV.deparallelize
    # If stripping the binaries is enabled, vim will segfault with
    # statically-linked interpreters like ruby
    # https://github.com/vim/vim/issues/114
    system "make", "install", "prefix=#{prefix}", "STRIP=#{which "true"}"
    bin.install_symlink "vim" => "vi"
  end

  test do
    (testpath/"commands.vim").write <<~EOS
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    EOS
    system bin/"vim", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", File.read("test.txt").chomp
    assert_match "+gettext", shell_output("#{bin}/vim --version")
  end
end
