class CdDiscid < Formula
  desc "Read CD and get CDDB discid information"
  homepage "https://linukz.org/cd-discid.shtml"
  license "GPL-2.0"
  revision 2
  head "https://github.com/taem/cd-discid.git", branch: "master"

  stable do
    url "https://linukz.org/download/cd-discid-1.4.tar.gz"
    mirror "https://deb.debian.org/debian/pool/main/c/cd-discid/cd-discid_1.4.orig.tar.gz"
    sha256 "ffd68cd406309e764be6af4d5cbcc309e132c13f3597c6a4570a1f218edd2c63"

    # macOS fix; see https://github.com/Homebrew/homebrew/issues/46267
    # Already fixed in upstream head; remove when bumping version to >1.4
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/cd-discid/1.4.patch"
      sha256 "f53b660ae70e91174ab86453888dbc3b9637ba7fcaae4ea790855b7c3d3fe8e6"
    end
  end

  livecheck do
    url :homepage
    regex(/href=.*?cd-discid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cd-discid"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "70dc6943f38c5ab01bc27be8a08b0fb23a04d163af7a4cbb53803542c5e17387"
  end

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "cd-discid"
    man1.install "cd-discid.1"
  end

  test do
    assert_equal "cd-discid #{version}.", shell_output("#{bin}/cd-discid --version 2>&1").chomp
  end
end
