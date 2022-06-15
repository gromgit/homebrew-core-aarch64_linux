class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v8.2.0.tar.gz"
  sha256 "75efd9e583836f3e6cc6d793df1501462fdceeb3460d5a2dbba99993997383b9"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/n"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f69ed17898d4d01ece9542405042904ad0985bb36cd175e19c015e92d3d59e47"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
