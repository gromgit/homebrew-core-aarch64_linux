class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/refs/tags/v2.34.0.tar.gz"
  sha256 "3d7067e71500e95d69eac86a271a6b6fc3f2f2817ba0e9a589524bf3e73e007c"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/direnv-2.34.0"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "3814daba7eb0467687bbb42bff6f718bb64ee073bcba5830c8036116f8b7382d"
  end

  depends_on "go" => :build
  depends_on "bash"

  def install
    system "make", "install", "PREFIX=#{prefix}", "BASH_PATH=#{Formula["bash"].opt_bin}/bash"
  end

  test do
    system bin/"direnv", "status"
  end
end
