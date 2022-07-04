class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/2.5.0.tar.gz"
  sha256 "50274a09c760303bc88c0ead319eda4bc6f317764a1cade1ea86e9ff17d7c0b1"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7ac6d14a657437ba2ec4c35afdf2dd71f125368536eacafdb8526ff1821abb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67cc762b1c4d54e8dbaf51cca664e863dd6558ce08d691fde42f01b1349681c7"
    sha256 cellar: :any_skip_relocation, monterey:       "f59a0c6767ee63bdf693dfc3d9292e93da59a90cae011a7b6723e367d0ea48af"
    sha256 cellar: :any_skip_relocation, big_sur:        "31ea4ab668442ef725c0b0fe72ba63a16cd56da7e583a0d4b519c73fe82036aa"
    sha256 cellar: :any_skip_relocation, catalina:       "6ae5c241584508eef5539efb88978ca3ace30b078e84564e95e062a66203ee86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73e0ef5a3fad690383b51327a24bf68b393e9d8a0639c035fafa1755743da3d2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/editorconfig-checker/main.go"
  end

  test do
    (testpath/"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin/"editorconfig-checker", testpath/"version.txt"
    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end
