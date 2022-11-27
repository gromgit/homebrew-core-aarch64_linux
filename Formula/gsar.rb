class Gsar < Formula
  desc "General Search And Replace on files"
  homepage "http://tjaberg.com/"
  url "http://tjaberg.com/gsar151.zip"
  version "1.51"
  sha256 "72908ae302d2293de5218fd4da0b98afa2ce8890a622e709360576e93f5e8cc8"
  license "GPL-2.0-only"

  # gsar archive file names don't include a version string with dots (e.g., 123
  # instead of 1.23), so we identify versions from the text of the "Changes"
  # section.
  livecheck do
    url :homepage
    regex(/gsar v?(\d+(?:\.\d+)+) released/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gsar"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5d3926b8cceb53adc75fd08386165aa81919cd0106bd2f2830abf50e28723e28"
  end

  def install
    system "make"
    bin.install "gsar"
  end

  test do
    assert_match "1 occurrence changed",
      shell_output("#{bin}/gsar -sCourier -rMonaco #{test_fixtures("test.ps")} new.ps")
  end
end
