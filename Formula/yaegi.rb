class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.11.tar.gz"
  sha256 "8af771783160f880008f56770abbd7c3021167294239c9acac4626787f26f49a"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f71cd661e29324aab6d2f36844566f429f62b0dafcfccd0a56fa9da1a8f5fef3" => :big_sur
    sha256 "f1005480f2b8d5aa6a77feaf4c7f756767025e0e2bf160babfd6cef9e2da8985" => :arm64_big_sur
    sha256 "0ce7c35dffdb7b44bd217b879782e2d04589655a62a1f4e7b6e43f0c8f35c44a" => :catalina
    sha256 "fca8970d81c16924e98d0519a07221d403f876493c2e3f3224a3df61e4adbae3" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
