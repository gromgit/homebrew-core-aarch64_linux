class BitGit < Formula
  desc "Bit is a modern Git CLI"
  homepage "https://github.com/chriswalz/bit"
  url "https://github.com/chriswalz/bit/archive/v0.9.10.tar.gz"
  sha256 "92f70967f4fc4b95b26bf012d46d71ae9c9a0a46d7324c20d498f1141c1b8225"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5121f15df6d33007aa2276b45056b9edb0c7a3d4df952bb421d16d64deaf1e91" => :catalina
    sha256 "2475aaae517935f8b06a0d4d574d1f6400e3b3bf8721f99b565d18a0c333f700" => :mojave
    sha256 "76a9afc995871f18cf3335c9c685176b522e606312e31c149e8c96d2700cd180" => :high_sierra
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
