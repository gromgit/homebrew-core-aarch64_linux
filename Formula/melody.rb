class Melody < Formula
  desc "Language that compiles to regular expressions"
  homepage "https://yoav-lavi.github.io/melody/book"
  url "https://github.com/yoav-lavi/melody/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "b9c7cacd6389fb32f5b75b5a6d47d171fafdac36fe5f23632ca24e52a052e361"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66a33c5cdf5a2d4d0ed4523db247ae017cc6644e3e36fda9ef38f9b173c2f760"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "861ab424fb5976e38a712ac42e39b616f45b6302192ae99bedf3f6aafcd9c8d2"
    sha256 cellar: :any_skip_relocation, monterey:       "150a6b87389f20a4e78d4211c9b9b88d9189d01b71033f3b10241d0bfd022212"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b48e0e6809aa459d81741faba0f23c94a989d4c5d3cb1b739f07f5faa3e0c04"
    sha256 cellar: :any_skip_relocation, catalina:       "9b749ba32f962ddcd4085e3067aea2428904690b310fa3140d18fbe5e47e25c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2a9f11fed452583c1da9f6bcd1e62874f0cd37a8207520a63d323d0c980abea"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/melody_cli")
  end

  test do
    mdy = "regex.mdy"
    File.write mdy, '"#"; some of <word>;'
    assert_match "#\\w+", shell_output("#{bin}/melody --no-color #{mdy}")
  end
end
