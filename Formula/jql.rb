class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v4.0.0.tar.gz"
  sha256 "c4774f377e93ecd3992c4d2cd9fc41fc4ce903c6a300ba3b8cc8372c51e8fa06"
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
