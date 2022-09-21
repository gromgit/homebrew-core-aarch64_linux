class Mobiledevice < Formula
  desc "CLI for Apple's Private (Closed) Mobile Device Framework"
  homepage "https://github.com/imkira/mobiledevice"
  url "https://github.com/imkira/mobiledevice/archive/v2.0.0.tar.gz"
  sha256 "07b167f6103175c5eba726fd590266bf6461b18244d34ef6d05a51fc4871e424"
  license "MIT"

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  depends_on :macos

  # This is a simple change that permits building on newer versions of macOS.
  # Should be included in the next stable release.
  patch do
    url "https://github.com/imkira/mobiledevice/commit/0472188d875382c5535916bf4469a2de7696fd39.patch?full_index=1"
    sha256 "76094a3e39e287c88bb60c829d2e9ab8801f8638c116d95a16333198b236147b"
  end

  def install
    (buildpath/"symlink_framework.sh").chmod 0555
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/mobiledevice", "list_devices"
  end
end
