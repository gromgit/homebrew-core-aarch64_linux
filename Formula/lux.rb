class Lux < Formula
  desc "Fast and simple video downloader"
  homepage "https://github.com/iawia002/lux"
  url "https://github.com/iawia002/lux/archive/v0.15.0.tar.gz"
  sha256 "41e45542587caa27bf8180e66c72c6c77e83d00f8dcba2e952c5a9b04d382c6c"
  license "MIT"
  head "https://github.com/iawia002/lux.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/lux"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d9a4086b18d80f8f0eeeaae53ca82dcad26955dabe6b52d71f39c0b9a8780236"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"lux", "-i", "https://github.githubassets.com/images/modules/site/icons/footer/github-logo.svg"
  end
end
