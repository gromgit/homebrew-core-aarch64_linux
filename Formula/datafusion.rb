class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/12.0.0.tar.gz"
  sha256 "a376bec1e8e4e6a39dafbb400a5f58fee81a82e9f85063d424039a4c6a497c0c"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f6cdde4ebb85a208c570c04f3cd09345f8b2cd22df16c6eba3dba81ffad872a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87a0da36c0793e42e0f0ee76a6d26cb3f37c400b6bb38b63d8fa5c6427ef2fcb"
    sha256 cellar: :any_skip_relocation, monterey:       "0b548e62cfbed62b79948f231c1ee4a4b284caa76ada521d99981283f7d52f19"
    sha256 cellar: :any_skip_relocation, big_sur:        "71c90b641121e2444400f33914e42a36e4243af0235e986fb1f0217159918580"
    sha256 cellar: :any_skip_relocation, catalina:       "b2c1f7b6dd2406f206935d85a7d4cfda62969ee00163072c3618baf24cc3f494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8507a2b794180fefd6b3284130aada79cd0e85a5a6dff119eb49c2ecb4faedc"
  end

  depends_on "rust" => :build
  # building ballista requires installing rustfmt
  depends_on "rustfmt" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
