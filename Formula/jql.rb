class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v4.0.1.tar.gz"
  sha256 "07e8dadd8ebc2e2f491deb89c6c86a8b670519f1b023f63fb78f58a61d2d322d"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9764d02a5bd7520a141b4c9949d21794467179eda908d2067f4a395b8635cf9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05a8441819f79d6a26fe2f170f54e04090c3b3bcb7e40d163a037a94f67aa4c1"
    sha256 cellar: :any_skip_relocation, monterey:       "2a9b50a6cccc82e13eb0095e01d3de0589baab98fe56723c66bcc88dfe967f03"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fa7d5865731f225f039feaaf6a65055c94e2036f819f54ac73ceaae87a17819"
    sha256 cellar: :any_skip_relocation, catalina:       "884164a7edc0ffea490650796adadb17c3ffe9a4a91493d9aef597574ae49027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "012137f169b9884688a57f27c2a46f9b7b237f49959082e7c40d296037ca8d43"
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
