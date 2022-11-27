class RushParallel < Formula
  desc "Cross-platform command-line tool for executing jobs in parallel"
  homepage "https://github.com/shenwei356/rush"
  url "https://github.com/shenwei356/rush/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "8046a0ac9ed10d2adff250ab5b95a95c895cae3b43d2a25bd95979f319146cb9"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rush-parallel"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e6c97a38eecbc9a138d6c0ff5e9ad5707fe728785fd09f7bbaa324e4013fc5d4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"rush")
  end

  test do
    assert_equal <<~EOS, pipe_output("#{bin}/rush -k 'echo 0{}'", (1..4).to_a.join("\n"))
      01
      02
      03
      04
    EOS
  end
end
