class Ddcctl < Formula
  desc "DDC monitor controls (brightness) for Mac OSX command-line"
  homepage "https://github.com/kfix/ddcctl"
  url "https://github.com/kfix/ddcctl/archive/refs/tags/v0.tar.gz"
  sha256 "8440f494b3c354d356213698dd113003245acdf667ed3902b0d173070a1a9d1f"
  license "GPL-3.0-only"

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  depends_on :macos

  # Apply 2 upstream commits to fix build failures with Xcode 13.
  # Remove with next release.
  patch do
    url "https://github.com/kfix/ddcctl/commit/d3ab6ecfd649fa8c335cd45d632cfc8ee2069174.patch?full_index=1"
    sha256 "59fbd6f9e0aefdc65de967c350b9ab353001972bbc1b8fbe1bffb458e81a2700"
  end

  patch do
    url "https://github.com/kfix/ddcctl/commit/8395b07150508305ff92ead307f1563163212383.patch?full_index=1"
    sha256 "11646455bcb08fd3d8daad4e311df39a26936c4bc5da9180474eed33ccc52256"
  end

  def install
    bin.mkpath
    system "make", "install", "INSTALL_DIR=#{bin}"
  end

  test do
    output = shell_output("#{bin}/ddcctl -d 100 -b 100", 1)
    assert_match(/found \d external display/, output)
  end
end
