class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated every 50 releases on multiples of 50
  url "https://github.com/vim/vim/archive/v8.2.0550.tar.gz"
  sha256 "7a11d8c7e927e8fdc5182e1b8c6e8657a57e98740f9690d23afddcb3a3081e9b"
  head "https://github.com/vim/vim.git"

  bottle do
    sha256 "9fcbd19d917324411fa224880bcad1a11419b425e8c0f317e19ff8b9b913fd4a" => :catalina
    sha256 "e46a27ae1a2d54c733f2465669aeb70d16502ba95b2c24c869555a56dc53af8d" => :mojave
    sha256 "70eec43a3789bea58cb2a46bb8bdcf2ddc13546cbef16525fd6cfbc5a616b219" => :high_sierra
  end

  depends_on "gettext"
  depends_on "lua"
  depends_on "perl"
  depends_on "python"
  depends_on "ruby"

  uses_from_macos "ncurses"

  conflicts_with "ex-vi",
    :because => "vim and ex-vi both install bin/ex and bin/view"

  conflicts_with "macvim",
    :because => "vim and macvim both install vi* binaries"

  def install
    ENV.prepend_path "PATH", Formula["python"].opt_libexec/"bin"

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
                          "--enable-cscope",
                          "--enable-terminal",
                          "--with-compiledby=Homebrew",
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
