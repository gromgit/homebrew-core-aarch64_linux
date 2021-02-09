class Quex < Formula
  desc "Generate lexical analyzers"
  homepage "https://quex.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/quex/quex-0.71.0.zip"
  sha256 "2e8df936f1daea1367f58aabea92e05136f439eea3cd6cbea96c6af1969e4901"
  license "MIT"
  head "https://svn.code.sf.net/p/quex/code/trunk"

  livecheck do
    url :stable
    regex(%r{url=.*?/quex[._-]v?(\d+(?:\.\d+)+)\.[tz]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "f3d39a7468e8c529ce1c0d6ab5b2d028f50771304993e9f2e996490f846c4b6c"
    sha256 cellar: :any_skip_relocation, mojave:      "f3d39a7468e8c529ce1c0d6ab5b2d028f50771304993e9f2e996490f846c4b6c"
    sha256 cellar: :any_skip_relocation, high_sierra: "f3d39a7468e8c529ce1c0d6ab5b2d028f50771304993e9f2e996490f846c4b6c"
  end

  # https://sourceforge.net/p/quex/bugs/310/
  depends_on "python@3.7"

  def install
    # Backport one change from https://sourceforge.net/p/quex/git/ci/28c8343c6fe054e5e1a085daebcca43715bc6108/#diff-7
    # to allow running under Python 3.7
    inreplace "quex/input/code/base.py", "_pattern_type", "Pattern"
    libexec.install "quex", "quex-exe.py"
    doc.install "README", "demo"

    # Use a shim script to set QUEX_PATH on the user's behalf
    (bin/"quex").write <<~EOS
      #!/bin/bash
      QUEX_PATH="#{libexec}" "#{Formula["python@3.7"].opt_bin}/python3" "#{libexec}/quex-exe.py" "$@"
    EOS

    if build.head?
      man1.install "doc/manpage/quex.1"
    else
      man1.install "manpage/quex.1"
    end
  end

  test do
    system bin/"quex", "-i", doc/"demo/C/01-Trivial/easy.qx", "-o", "tiny_lexer"
    assert_predicate testpath/"tiny_lexer", :exist?
  end
end
