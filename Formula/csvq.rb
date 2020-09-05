class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.13.6.tar.gz"
  sha256 "cd8dfb172a448191ad97896e5f962c8e06c3617a6d2d7e89e71914aa414f157a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f12b5af1956393fe1c7eb3c8a66af0395a57ca1fabce3fa46ec9abbc42d4c98f" => :catalina
    sha256 "515f33d52a7f0aadd4fe25263cd1f9b48d93a2cfcd56642437b478e12d806568" => :mojave
    sha256 "098d117004b545984482edb34ecc8961dd7d230afa950306669197d668d23182" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/csvq", "--version"

    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
    EOS
    expected = <<~EOS
      a,b
      1,2
    EOS
    result = shell_output("#{bin}/csvq --format csv 'SELECT a, b FROM `test.csv`'")
    assert_equal expected, result
  end
end
