class Dnstracer < Formula
  desc "Trace a chain of DNS servers to the source"
  homepage "https://www.mavetju.org/unix/dnstracer.php"
  url "https://www.mavetju.org/download/dnstracer-1.9.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/d/dnstracer/dnstracer_1.9.orig.tar.gz"
  sha256 "2ebc08af9693ba2d9fa0628416f2d8319ca1627e41d64553875d605b352afe9c"
  license "BSD-2-Clause"

  # It's necessary to check the `/unix/general.php` page, instead of
  # `/download/`, until a real 1.10 version exists. The file name for version
  # 1.1 on the `/download/` page is given as 1.10 and this is erroneously
  # treated as newer than 1.9.
  livecheck do
    url "https://www.mavetju.org/unix/general.php"
    regex(/href=.*?dnstracer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/dnstracer"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "dacd9ae8e56f37e366a209a5747bc4a32712523f7878d9c41287621811965ae0"
  end

  def install
    ENV.append "LDFLAGS", "-lresolv"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"dnstracer", "-4", "brew.sh"
  end
end
