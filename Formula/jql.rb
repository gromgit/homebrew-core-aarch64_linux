class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v4.0.3.tar.gz"
  sha256 "8cb6e5a9c02c17d17d531771b901995285948882fb161e767e53850c6bc6da36"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "203979bf84bd515088740576c653c9fbbeb9875e15fc4606fc50feb990dde446"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7390f22716b40d558a42188c73e5449dee79200aa949773ed49579e28a9f74f0"
    sha256 cellar: :any_skip_relocation, monterey:       "c81892d0f16ca5d451694fcb7a3bc13421bf10be9fc43a6fd516d8c6fa10c5b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "701f08409638b52d3cac94d9cd042891840d580c80119be078d8ad6f0fd408e3"
    sha256 cellar: :any_skip_relocation, catalina:       "ef8a838e251acf1ecb51dc2e99c009c6090ffdf12f18a55d3b6e779d9d4b545b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33e93a0312904584057ef216ae43ea6fb1f214c3706359633d8f0b2be072e0d8"
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
