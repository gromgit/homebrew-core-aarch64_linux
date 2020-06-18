class Gluon < Formula
  desc "Static, type inferred and embeddable language written in Rust"
  homepage "https://gluon-lang.org"
  url "https://github.com/gluon-lang/gluon/archive/v0.15.0.tar.gz"
  sha256 "39d3615cb3109c1d6745199c078a8db17f9dcbe370297d6bb8fe71b6c65d80ee"
  head "https://github.com/gluon-lang/gluon.git"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "repl"
  end

  test do
    (testpath/"test.glu").write <<~EOS
      let io = import! std.io
      io.print "Hello world!\\n"
    EOS
    assert_equal "Hello world!\n", shell_output("#{bin}/gluon test.glu")
  end
end
