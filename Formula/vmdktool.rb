class Vmdktool < Formula
  desc "Converts raw filesystems to VMDK files and vice versa"
  homepage "https://manned.org/vmdktool"
  url "https://people.freebsd.org/~brian/vmdktool/vmdktool-1.4.tar.gz"
  sha256 "981eb43d3db172144f2344886040424ef525e15c85f84023a7502b238aa7b89c"
  license "BSD-2-Clause"

  livecheck do
    url "https://people.freebsd.org/~brian/vmdktool/"
    regex(/href=.*?vmdktool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/vmdktool"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "95fbd8556cec01ce3731ec47c66a3e325c8c2611194366faf79f8965b53590cb"
  end

  uses_from_macos "zlib"

  def install
    system "make", "CFLAGS='-D_GNU_SOURCE -g -O -pipe'"

    # The vmdktool Makefile isn't as well-behaved as we'd like:
    # 1) It defaults to man page installation in $PREFIX/man instead of
    #    $PREFIX/share/man, and doesn't recognize '$MANDIR' as a way to
    #    override this default.
    # 2) It doesn't do 'install -d' to create directories before installing
    #    to them.
    # The maintainer (Brian Somers, brian@awfulhak.org) has been notified
    # of these issues as of 2017-01-25 but no fix is yet forthcoming.
    # There is no public issue tracker for vmdktool that we know of.
    # In the meantime, we can work around these issues as follows:
    bin.mkpath
    man8.mkpath
    inreplace "Makefile", "man/man8", "share/man/man8"

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Create a blank disk image in raw format
    system "dd", "if=/dev/zero", "of=blank.raw", "bs=512", "count=20480"
    # Use vmdktool to convert to streamOptimized VMDK file
    system "#{bin}/vmdktool", "-v", "blank.vmdk", "blank.raw"
    # Inspect the VMDK with vmdktool
    output = shell_output("#{bin}/vmdktool -i blank.vmdk")
    assert_match "RDONLY 20480 SPARSE", output
    assert_match "streamOptimized", output
  end
end
