class Mon < Formula
  desc "Monitor hosts/services/whatever and alert about problems"
  homepage "https://github.com/visionmedia/mon"
  url "https://github.com/visionmedia/mon/archive/1.2.3.tar.gz"
  sha256 "978711a1d37ede3fc5a05c778a2365ee234b196a44b6c0c69078a6c459e686ac"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/mon"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "2b076887f150c56162ed79377aee941d77a8372a4f5328c127e7dcd4f2cf1b37"
  end

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"mon", "-V"
  end
end
