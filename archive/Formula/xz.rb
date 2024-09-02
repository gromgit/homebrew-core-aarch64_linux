# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/legacy-homebrew/pull/21419
class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  # The archive.org mirror below needs to be manually created at `archive.org`.
  url "https://downloads.sourceforge.net/project/lzmautils/xz-5.4.0.tar.gz"
  mirror "https://tukaani.org/xz/xz-5.4.0.tar.gz"
  mirror "https://archive.org/download/xz-5.4.0/xz-5.4.0.tar.gz"
  mirror "http://archive.org/download/xz-5.4.0/xz-5.4.0.tar.gz"
  sha256 "7471ef5991f690268a8f2be019acec2e0564b7b233ca40035f339fe9a07f830b"
  license all_of: [
    :public_domain,
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
  ]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/xz"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "cf3b1390d88e1d0d4abfd59b099dec54c7bea0e74127fbdd9a3afc19209fbf49"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.xz
    system bin/"xz", path
    refute_predicate path, :exist?

    # decompress: data.txt.xz -> data.txt
    system bin/"xz", "-d", "#{path}.xz"
    assert_equal original_contents, path.read
  end
end
