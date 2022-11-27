class LinuxHeadersAT44 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.4.80.tar.gz"
  sha256 "291d844619b5e7c43bd5aa0b2c286274fc5ffe31494ba475f167a21157e88186"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/linux-headers@4.4"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8f75ecfa1adb846f0fe370b5d77a53a70649fa1b4ad512d9f21244162fd244a8"
  end

  depends_on :linux

  def install
    system "make", "headers_install", "INSTALL_HDR_PATH=#{prefix}"
    rm Dir[prefix/"**/{.install,..install.cmd}"]
  end

  test do
    assert_match "KERNEL_VERSION", File.read(include/"linux/version.h")
  end
end
