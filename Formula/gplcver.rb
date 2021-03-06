class Gplcver < Formula
  desc "Pragmatic C Software GPL Cver 2001"
  homepage "https://gplcver.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gplcver/gplcver/2.12a/gplcver-2.12a.src.tar.bz2"
  sha256 "f7d94677677f10c2d1e366eda2d01a652ef5f30d167660905c100f52f1a46e75"

  # This regex intentionally matches seemingly unstable versions, as the only
  # available version at the time of writing was `2.12a`.
  livecheck do
    url :stable
    regex(%r{url=.*?/gplcver[._-]v?(\d+(?:\.\d+)+[a-z]?)\.src\.}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gplcver"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "6bda90f1ec9cb1a11a9ceb0c14badb5c98e99cf21d7a1f8d21b316bf423e57ea"
  end

  def install
    inreplace "src/makefile.osx" do |s|
      s.gsub! "-mcpu=powerpc", ""
      s.change_make_var! "CFLAGS", "$(INCS) $(OPTFLGS) #{ENV.cflags}"
      s.change_make_var! "LFLAGS", ""
    end

    system "make", "-C", "src", "-f", "makefile.osx"
    bin.install "bin/cver"
  end
end
