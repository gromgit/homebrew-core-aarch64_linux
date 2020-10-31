class BitGit < Formula
  desc "Bit is a modern Git CLI"
  homepage "https://github.com/chriswalz/bit"
  url "https://github.com/chriswalz/bit/archive/v0.9.2.tar.gz"
  sha256 "ddb4c8fc872ded780cc224df7ee0e15111ef175b8fe4d83c79632bc93b246c5b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d42db6312d212b25f0336bb77766e8d84cccaae41a6bdb7b858a44338777304d" => :catalina
    sha256 "f0fb488d091f67447b465a9cf8df306c328f839f46429368bb6c3937d90a5bf9" => :mojave
    sha256 "d037cdcf40af2dc1be854a4f48b1748f507ec2923c8e46195f5bb17686ea76bc" => :high_sierra
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
