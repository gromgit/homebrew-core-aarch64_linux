class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.17.7.tar.gz"
  sha256 "bbd7d644f5012b17a2aadcd0169a942ffc800b2d40a748dbb567135d73402a21"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "264c96f3bc23512222ebddbcaba7dc560b2e4806fc904a0bd56da022af1759cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d507e00a1f58e9570f58c15c9df6e1381b3c10c53e7f86eb4a172775ce29a570"
    sha256 cellar: :any_skip_relocation, monterey:       "9713169b96e38b43593fba06af7f3471080b5df395d769ba9869b038c473e488"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a0e40fb3d57141a4705b985213822571f400d5af3ff81f009f187fc8061a859"
    sha256 cellar: :any_skip_relocation, catalina:       "735d6e05ed21716c50530290e5a41f3179ce156ea19fb15abc1a92c1ade603a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5579bf3026d940f963b533407ad5b99c26bd74e160ab67d64d156d19d8eb6b91"
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
