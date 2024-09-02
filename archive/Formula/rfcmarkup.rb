class Rfcmarkup < Formula
  desc "Add HTML markup and links to internet-drafts and RFCs"
  homepage "https://tools.ietf.org/tools/rfcmarkup/"
  url "https://tools.ietf.org/tools/rfcmarkup/rfcmarkup-1.129.tgz"
  sha256 "369d1b1e6ed27930150b7b0e51a5fc4e068a8980c59924abc0ece10758c6cfd7"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(%r{>\s*Version:\s*</i>\s*v?(\d+(?:\.\d+)+)}im)
  end

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  # Requires Python2.
  # https://github.com/Homebrew/homebrew-core/issues/93940
  deprecate! date: "2022-04-23", because: :unsupported

  depends_on :macos # Due to Python 2

  def install
    bin.install "rfcmarkup"
  end

  test do
    system bin/"rfcmarkup", "--help"
  end
end
