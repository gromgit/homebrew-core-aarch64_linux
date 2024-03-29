class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.8.7.tar.gz"
  sha256 "0a4c7f8051d8351508510148e01c965a10490d97362b9c14407d0d19d7fd7778"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ghorg"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e022788dc73d227c03164b355b1900b5d18b2a17b60b81d0e9086321e7e5c095"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
