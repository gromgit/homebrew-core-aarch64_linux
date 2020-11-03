class BitGit < Formula
  desc "Bit is a modern Git CLI"
  homepage "https://github.com/chriswalz/bit"
  url "https://github.com/chriswalz/bit/archive/v0.9.11.tar.gz"
  sha256 "a6d7f31d92007725b18f6203c7b9c8f9eaaa49e22f807ad683473d7388350681"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d38f9022625d729269783b71023682d63a54ef9d9bb002cc4983fc54846d7966" => :catalina
    sha256 "ccbf37c211bc5d8157aca19b3ca1eb531b388e273cdddeaed03d6ca1b5335a40" => :mojave
    sha256 "8581dec729c74b74fa91884349df091269501524ddcd93a446ead3177995977d" => :high_sierra
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
