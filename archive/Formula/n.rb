class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v9.0.0.tar.gz"
  sha256 "37a987230d1ed0392a83f9c02c1e535a524977c00c64a4adb771ab60237be1c6"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/n"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "fa979454a3c6965732a20b0ab4166a9789edce29093d686907a0b52898f174bf"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
