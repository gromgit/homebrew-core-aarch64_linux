class FuzzyFind < Formula
  desc "Fuzzy filename finder matching across directories as well as files"
  homepage "https://github.com/silentbicycle/ff"
  url "https://github.com/silentbicycle/ff/archive/v0.6-flag-features.tar.gz"
  version "0.6.0"
  sha256 "104300ba16af18d60ef3c11d70d2ec2a95ddf38632d08e4f99644050db6035cb"
  head "https://github.com/silentbicycle/ff.git", branch: "master"

  # This regex intentionally allows anything to come after the numeric version
  # (instead of using $ at the end like we normally do). These tags have a
  # format like `0.6-flag-features` or `v0.5-first-form`, where the trailing
  # text seems to be a release name. This regex may become a problem in the
  # future if we encounter releases like `1.2-alpha1` `1.2-rc1`, etc.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/fuzzy-find"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a8df6f940b27ededd392caff8007d160fa95701adb596e53415cf9f6b2efa91e"
  end

  def install
    system "make"
    bin.install "ff"
    man1.install "ff.1"
    elisp.install "fuzzy-find.el"
  end

  test do
    system bin/"ff", "-t"
  end
end
