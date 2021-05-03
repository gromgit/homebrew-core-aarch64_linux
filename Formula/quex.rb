class Quex < Formula
  desc "Generate lexical analyzers"
  homepage "https://quex.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/quex/quex-0.71.2.zip"
  sha256 "0453227304a37497e247e11b41a1a8eb04bcd0af06a3f9d627d706b175a8a965"
  license "MIT"
  head "https://svn.code.sf.net/p/quex/code/trunk"

  livecheck do
    url :stable
    regex(%r{url=.*?/quex[._-]v?(\d+(?:\.\d+)+)\.[tz]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "dc866a83867dca24a0126b57d9dfb5b1613d491e6eac63d4f22d7ca2f92368db"
    sha256 cellar: :any_skip_relocation, catalina: "7a0be7cfed70b009c5e04fef0db429d7e677c74d24659cc3fe33aec1e278f7a0"
    sha256 cellar: :any_skip_relocation, mojave:   "42e34011b0350928c50d20a4bc12a813e8cdd7934e9879484df46af8de6cfff0"
  end

  depends_on "python@3.9"

  def install
    libexec.install "quex", "quex-exe.py"
    doc.install "README", "demo"

    # Use a shim script to set QUEX_PATH on the user's behalf
    (bin/"quex").write <<~EOS
      #!/bin/bash
      QUEX_PATH="#{libexec}" "#{Formula["python@3.9"].opt_bin}/python3" "#{libexec}/quex-exe.py" "$@"
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
