class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.5.8.tar.gz"
  sha256 "90d87503265c12f8583f5c6bc19c83eba7a2e15219a6339d5041628aa48c4705"
  license "MIT"
  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7fdbc66f3eff034c2c652d427952002f8c842f29aa1c7d44170d66e4866bdb6" => :catalina
    sha256 "85e61dc800cba2795fef1a8c9f77cc384f7ec7be6ae22819f74c747b2f9b4db5" => :mojave
    sha256 "a8e5c5b29e4650a17a2ac48ff6b25563176f66eaf0a2a0d557b72ba0899ddee1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    system "go", "build", *std_go_args, "cmd/peco/peco.go"
  end

  test do
    system "#{bin}/peco", "--version"
  end
end
