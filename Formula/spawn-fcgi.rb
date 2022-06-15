class SpawnFcgi < Formula
  desc "Spawn fast-CGI processes"
  homepage "https://redmine.lighttpd.net/projects/spawn-fcgi"
  url "https://www.lighttpd.net/download/spawn-fcgi-1.6.4.tar.gz"
  sha256 "ab327462cb99894a3699f874425a421d934f957cb24221f00bb888108d9dd09e"
  license "BSD-3-Clause"

  livecheck do
    url "https://redmine.lighttpd.net/projects/spawn-fcgi/news"
    regex(/href=.*?spawn-fcgi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/spawn-fcgi"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "837bcf63c239f183f5867a77aa313a94c40df61e7ff6be6b8460fbf15f5f8347"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/spawn-fcgi", "--version"
  end
end
