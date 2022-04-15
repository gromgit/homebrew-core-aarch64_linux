class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v4.0.1.tar.gz"
  sha256 "07e8dadd8ebc2e2f491deb89c6c86a8b670519f1b023f63fb78f58a61d2d322d"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08403ec4850fc7625e187817e3724b677285d29c61ccaff6e8117913830a20cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b7f64f72c4ed49582a076a996f434583dd67e919230ae5d74e8fa14daedff3d"
    sha256 cellar: :any_skip_relocation, monterey:       "a1483e05ebbbc2211c53942719ad3e66bce2854a6aa6095803d898a671e6059f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a39108710af7ecdc1e87ef1f420b65834115d9bd7d385673333bab71ed9c15f"
    sha256 cellar: :any_skip_relocation, catalina:       "62c4b58b4e1f54c28d1fa9cd0f3a0884db5f22e1872a91c0fc1a3a77ba232327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "392b05c658f153f0b81ccfba30cf39e5eceeef79f22aa665a723868ce8ca6ca9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}/jql --raw-output '\"cats\".[2:1].[0].\"third\"' example.json")
    assert_equal "Misty\n", output
  end
end
