class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.31.0.tar.gz"
  sha256 "f82694202f584d281a166bd5b7e877565f96a94807af96325c8f43643d76cb44"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/direnv"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d468a7ae58143667ac4a2cbf1b4ff33ef9bbd032979d1b9c981c8087ade94c31"
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
