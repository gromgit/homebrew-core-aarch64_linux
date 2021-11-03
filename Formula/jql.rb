class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v3.0.3.tar.gz"
  sha256 "cd4073fa6491df0da653de2b67e37322612e56e6dd456bb97bb29fda2bd434a2"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0dfad6abd3a49e0be680d95d4a9e9e5ea65c860eb8af3e77e734b2137ddffe67"
    sha256 cellar: :any_skip_relocation, big_sur:       "a30d25f7ce6f8586698b444c90227d2920d4ff8506d35e4b558a8253e2e97eec"
    sha256 cellar: :any_skip_relocation, catalina:      "7dcba21e7a58542c4aa81632d8d4442810e139f5eeb30862f72e756822a55916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bec3a508a20a7d7124dfbdadcdadbb8a29eddcca7b1686874853c24d046db1b"
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
