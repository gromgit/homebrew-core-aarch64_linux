class Grep < Formula
  desc "GNU grep, egrep and fgrep"
  homepage "https://www.gnu.org/software/grep/"
  url "https://ftp.gnu.org/gnu/grep/grep-3.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/grep/grep-3.7.tar.xz"
  sha256 "5c10da312460aec721984d5d83246d24520ec438dd48d7ab5a05dbc0d6d6823c"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/grep"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "66b0f85f6968764c762a25a1b564bccab7e73b4821203ff83da4c60abb3819f9"
  end

  depends_on "pkg-config" => :build
  depends_on "pcre"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-nls
      --prefix=#{prefix}
      --infodir=#{info}
      --mandir=#{man}
      --with-packager=Homebrew
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make"
    system "make", "install"

    if OS.mac?
      %w[grep egrep fgrep].each do |prog|
        (libexec/"gnubin").install_symlink bin/"g#{prog}" => prog
        (libexec/"gnuman/man1").install_symlink man1/"g#{prog}.1" => "#{prog}.1"
      end
    end

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        All commands have been installed with the prefix "g".
        If you need to use these commands with their normal names, you
        can add a "gnubin" directory to your PATH from your bashrc like:
          PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    text_file = testpath/"file.txt"
    text_file.write "This line should be matched"

    if OS.mac?
      grepped = shell_output("#{bin}/ggrep match #{text_file}")
      assert_match "should be matched", grepped

      grepped = shell_output("#{opt_libexec}/gnubin/grep match #{text_file}")
    else
      grepped = shell_output("#{bin}/grep match #{text_file}")
    end
    assert_match "should be matched", grepped
  end
end
