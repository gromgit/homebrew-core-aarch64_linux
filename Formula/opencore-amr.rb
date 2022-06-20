class OpencoreAmr < Formula
  desc "Audio codecs extracted from Android open source project"
  homepage "https://opencore-amr.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-0.1.5.tar.gz"
  sha256 "2c006cb9d5f651bfb5e60156dbff6af3c9d35c7bbcc9015308c0aff1e14cd341"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/opencore-amr[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/opencore-amr"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "91734a4774907464eb44df3c07a8f5fd6c5a2629322bbd34df679fb14364a2b1"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
