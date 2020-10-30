class BitGit < Formula
  desc "Bit is a modern Git CLI"
  homepage "https://github.com/chriswalz/bit"
  url "https://github.com/chriswalz/bit/archive/v0.9.1.tar.gz"
  sha256 "8c7c42942a65bea8398562f16342d0a670b084369ccb81ca2bf30833e3609754"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d8d5ce469d71500e41a71203320f54f19ff8dede36a369da3a7b34802c36bf0" => :catalina
    sha256 "e7eee70da0e4644227b175415d75264fbe86109f7f161831aaf1b99217d2a34b" => :mojave
    sha256 "1fb7f8988ec1c6918262b04297779b4655dee27fb0abac1f7b99567dfee9eb2c" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "bit", because: "both install `bit` binaries"

  def install
    system "go", "build", *std_go_args
    bin.install_symlink "bit-git" => "bit"
  end

  test do
    system "git", "init", testpath/"test-repository"

    cd testpath/"test-repository" do
      (testpath/"test-repository/test.txt").write <<~EOS
        Hello Homebrew!
      EOS
      system bin/"bit", "add", "test.txt"

      output = shell_output("#{bin}/bit status").chomp
      assert_equal "new file:   test.txt", output.lines.last.strip
    end
  end
end
