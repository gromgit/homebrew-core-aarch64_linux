class BitGit < Formula
  desc "Bit is a modern Git CLI"
  homepage "https://github.com/chriswalz/bit"
  url "https://github.com/chriswalz/bit/archive/v0.9.1.tar.gz"
  sha256 "8c7c42942a65bea8398562f16342d0a670b084369ccb81ca2bf30833e3609754"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6cafe748e647aeaf41c2d4a3191726bc2bd23b891c18f86a2b625e5da81b4be9" => :catalina
    sha256 "a7a2220f9f0fd3929db87df0ed480b80414ee530dc6253330e2d04788b529a65" => :mojave
    sha256 "e572c0defed08460d80427b828a626816dcbd475a4bb76cd1ba41b77c1f99728" => :high_sierra
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
