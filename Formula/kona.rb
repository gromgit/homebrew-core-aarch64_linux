class Kona < Formula
  desc "Open-source implementation of the K programming language"
  homepage "https://github.com/kevinlawler/kona"
  url "https://github.com/kevinlawler/kona/archive/Win64-20211225.tar.gz"
  sha256 "cd5dcc03394af275f0416b3cb2914574bf51ec60d1c857020fbd34b5427c5faf"
  license "ISC"
  head "https://github.com/kevinlawler/kona.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Win(?:64)?[._-])?v?(\d+(?:\.\d+)*)[^"' >]*["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/kona"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f589e4f5656e792f6ff39e041507960938c5c40b450c7863288582ac47d74475"
  end

  def install
    system "make"
    bin.install "k"
  end

  test do
    assert_match "Hello, world!", pipe_output("#{bin}/k", '`0: "Hello, world!"')
  end
end
