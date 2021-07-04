class LinuxHeaders < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.4.80.tar.gz"
  sha256 "291d844619b5e7c43bd5aa0b2c286274fc5ffe31494ba475f167a21157e88186"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a726f1ea608c17987bb444c0d42add7d1a225ad16897b21cf33ae599926b933e"
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
