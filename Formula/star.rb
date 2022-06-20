class Star < Formula
  desc "Standard tap archiver"
  homepage "https://cdrtools.sourceforge.io/private/star.html"
  url "https://downloads.sourceforge.net/project/s-tar/star-1.5.3.tar.bz2"
  sha256 "070342833ea83104169bf956aa880bcd088e7af7f5b1f8e3d29853b49b1a4f5b"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/star"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "62ce072a2b1e3a2068c9f632e8924d71a3972dce1f9d6170cc7a5d50d1f1e6ed"
  end

  depends_on "smake" => :build

  def install
    ENV.deparallelize # smake does not like -j

    system "smake", "GMAKE_NOWARN=true", "INS_BASE=#{prefix}", "INS_RBASE=#{prefix}", "install"

    # Remove symlinks that override built-in utilities
    (bin+"gnutar").unlink
    (bin+"tar").unlink
    (man1+"gnutar.1").unlink

    # Remove useless files
    lib.rmtree
    include.rmtree

    # Remove conflicting files
    %w[makefiles makerules].each { |f| (man5/"#{f}.5").unlink }
  end

  test do
    system "#{bin}/star", "--version"
  end
end
