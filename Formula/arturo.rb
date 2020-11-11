class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "http://arturo-lang.io"
  url "https://github.com/arturo-lang/arturo/archive/v0.9.5.tar.gz"
  sha256 "fcf8064d4ae49fee0eeca6fd55a9ba30abefd9111c3102c6d682f56993694fc1"
  license "MIT"

  bottle do
    cellar :any
    sha256 "7157d2a231c708add52c19de3b3b5aa9aa938a399c5637a92ec1afd9a76a0c64" => :catalina
    sha256 "64166ff338c9fde490fd67a587e922627e8edbb0ef24b35ebe5323f628f40afb" => :mojave
    sha256 "662a58f2465df1f8074ca8d60d8c03665d0800bc36f906d3dfb6ec17faa1c591" => :high_sierra
  end

  depends_on "nim" => :build
  depends_on "gmp"
  depends_on "mysql"

  def install
    system "./build.sh"
    bin.install "bin/arturo"
  end

  test do
    (testpath/"hello.art").write <<~EOS
      print "hello"
    EOS
    assert_equal "hello", shell_output("#{bin}/arturo #{testpath}/hello.art").chomp
  end
end
