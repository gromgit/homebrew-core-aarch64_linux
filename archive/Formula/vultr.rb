class Vultr < Formula
  desc "Command-line tool for Vultr"
  homepage "https://jamesclonk.github.io/vultr"
  url "https://github.com/JamesClonk/vultr/archive/v2.0.3.tar.gz"
  sha256 "6529d521a7fa006808cd07331f31256e91773ec7e1a0c7839cd14884034fb185"
  license "MIT"
  head "https://github.com/JamesClonk/vultr.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/vultr"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b8eeb553edf86930c5ac036fb92a23ac7ac798adcf1d347ac032ca959bb416ab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    system bin/"vultr", "version"
  end
end
