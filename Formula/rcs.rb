class Rcs < Formula
  desc "GNU revision control system"
  homepage "https://www.gnu.org/software/rcs/"
  url "https://ftp.gnu.org/gnu/rcs/rcs-5.10.1.tar.lz"
  mirror "https://ftpmirror.gnu.org/rcs/rcs-5.10.1.tar.lz"
  sha256 "43ddfe10724a8b85e2468f6403b6000737186f01e60e0bd62fde69d842234cc5"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rcs"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "801cc07ac264b1e519a04a1b6e5ee6f6e9ea648adf6d8e8932c6873e1e36c2a4"
  end

  uses_from_macos "ed" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"merge", "--version"
  end
end
