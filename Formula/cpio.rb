class Cpio < Formula
  desc "Copies files into or out of a cpio or tar archive"
  homepage "https://www.gnu.org/software/cpio/"
  url "https://ftp.gnu.org/gnu/cpio/cpio-2.13.tar.bz2"
  mirror "https://ftpmirror.gnu.org/cpio/cpio-2.13.tar.bz2"
  sha256 "eab5bdc5ae1df285c59f2a4f140a98fc33678a0bf61bdba67d9436ae26b46f6d"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cpio"
    sha256 aarch64_linux: "481cba8a9581773d0e50b35679e457af6ee971bb8c987d6722b4220f805c573c"
  end

  keg_only :shadowed_by_macos, "macOS provides cpio"

  # Upstream patch for multiply-defined global variable
  # https://git.savannah.gnu.org/cgit/cpio.git/commit/?id=641d3f489cf6238bb916368d4ba0d9325a235afb
  # Review for removal in next release
  patch do
    url "https://git.savannah.gnu.org/cgit/cpio.git/patch/?id=641d3f489cf6238bb916368d4ba0d9325a235afb"
    sha256 "cdc04006fee03b60ab42bccae9a9bf146e3a4655d0e76a7a0a24689176a79ed0"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"

    return if OS.mac?

    # Delete rmt, which causes conflict with `gnu-tar`
    (libexec/"rmt").unlink
    (man8/"rmt.8").unlink
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <string>
    EOS
    system "ls #{testpath} | #{bin}/cpio -ov > #{testpath}/directory.cpio"
    assert_path_exists "#{testpath}/directory.cpio"
  end
end
