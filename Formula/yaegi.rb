class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.10.tar.gz"
  sha256 "3a8c29a540a17c1ba0047e7df2b69c94fd7b598cd86ebb788ddb043f6108516e"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c884eb2f618ba7d0f1c6ae64fe916f76655ea778b904d04df50fc855185ea4a9" => :big_sur
    sha256 "c9138557697a22c6ec8e3918c3a6b0a66030c6b3ea1844662ff79bbcace829e8" => :arm64_big_sur
    sha256 "d612314de86ba9d2c65d2cf49750b54f6cc7df00cb1d83c8b945a91b27ccb36e" => :catalina
    sha256 "f557d9594b25bdeafa313ee9882bc0485ee54855609109832a61ac4ee10ac8cb" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
