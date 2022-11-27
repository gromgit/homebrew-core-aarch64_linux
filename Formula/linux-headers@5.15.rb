class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.57.tar.gz"
  sha256 "d33d0e62f05d90d579eb0cc51343f48c32eb11e4fef0306c374b908212f51578"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/linux-headers@5.15"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f4a9eca957a99dee7eaac3ea069006de6bb089447728ec952ca0e88a1c40c570"
  end

  depends_on :linux

  def install
    system "make", "headers"

    cd "usr/include" do
      Pathname.glob("**/*.h").each do |header|
        (include/header.dirname).install header
      end
    end
  end

  test do
    assert_match "KERNEL_VERSION", (include/"linux/version.h").read
  end
end
