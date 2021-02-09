require "language/node"

class WriteGood < Formula
  desc "Naive linter for English prose"
  homepage "https://github.com/btford/write-good"
  url "https://registry.npmjs.org/write-good/-/write-good-1.0.6.tgz"
  sha256 "cc63cf27c95db982aabcc9cd2fa59e55382589f6e75ee17f26ebea941f715351"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6c57f2c41a2e7f4cc3c69d33c91926a00b96f37a9f52dabcc5b626553ba05b7f"
    sha256 cellar: :any_skip_relocation, big_sur:       "0cbfb814e0720e423f18144adfd984c696929581a7f7ceb84365875c089a2c17"
    sha256 cellar: :any_skip_relocation, catalina:      "2cb74d1eff7e1d6bdd6d3113f7fd8ce12c59039fd41ac2be234af2acced3c75a"
    sha256 cellar: :any_skip_relocation, mojave:        "58dfaf0d8c714ba8bc4adec2b73668698d9b55f81daa066b6e120af1826420a2"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.txt").write "So the cat was stolen."
    assert_match "passive voice", shell_output("#{bin}/write-good test.txt", 2)
  end
end
