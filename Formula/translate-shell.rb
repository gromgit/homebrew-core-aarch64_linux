class TranslateShell < Formula
  desc "Command-line translator using Google Translate and more"
  homepage "https://www.soimort.org/translate-shell"
  head "https://github.com/soimort/translate-shell.git", :branch => "develop"
  revision 1

  stable do
    url "https://github.com/soimort/translate-shell/archive/v0.9.3.2.tar.gz"
    sha256 "4ddf7292802f6d81a8e9c736a3ff854ebcc193866e9774376dc0c2f8d893323a"

    patch do
      url "https://github.com/soimort/translate-shell/commit/c5f0744006e8dff78852cffae64837addff8c26b.diff"
      sha256 "83aaa2b7182ac918bdc662a33cbf6faae12bd2a39e7567d5f4d32a0b3fcd527b"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8e7c236c93707e41c578af8a192bab565ea0500bf72d35298f5d526c89e16aa8" => :el_capitan
    sha256 "4772f5a1ebda38bbfe74c73d444c9ad8a2590e87b5ab29b17e38efc63699700c" => :yosemite
    sha256 "20cd6d1a5afb79a092f7421fd2ef251bbd4a7ed4d82c04ca072cc55ce7a14c69" => :mavericks
  end

  depends_on "fribidi"
  depends_on "gawk"
  depends_on "rlwrap"

  def install
    system "make"
    bin.install "build/trans"
    man1.install "man/trans.1"
  end

  def caveats; <<-EOS.undent
    By default, text-to-speech functionality is provided by OS X's builtin
    `say' command. This functionality may be improved in certain cases by
    installing one of mplayer, mpv, or mpg123, all of which are available
    through `brew install'.
    EOS
  end

  test do
    assert_equal "Hello\n", shell_output("#{bin}/trans -no-init -b -s fr -t en bonjour")
  end
end
