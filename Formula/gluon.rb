class Gluon < Formula
  desc "Static, type inferred and embeddable language written in Rust"
  homepage "https://gluon-lang.org"
  url "https://github.com/gluon-lang/gluon/archive/v0.15.1.tar.gz"
  sha256 "9e05b157337804a4cf111ee8a1854250970c460e9a32d3b662fc90ebf5b91638"
  head "https://github.com/gluon-lang/gluon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fee66ca58bc00cf86c28c7ca5e64308ea467e782ee1de93f41234303d09a23a5" => :catalina
    sha256 "b368877402d60253ce153628d9f39e57793bf65cb41f6fcdbdcae00d5e0253af" => :mojave
    sha256 "ee786f9331bd41e85d763d59b6a97ff8198919ced0e72fa0ebeaf951bccd3bbb" => :high_sierra
  end

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
