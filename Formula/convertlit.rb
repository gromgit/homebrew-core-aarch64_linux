class Convertlit < Formula
  desc "Convert Microsoft Reader format eBooks into open format"
  homepage "http://www.convertlit.com/"
  url "http://www.convertlit.com/clit18src.zip"
  version "1.8"
  sha256 "d70a85f5b945104340d56f48ec17bcf544e3bb3c35b1b3d58d230be699e557ba"

  # The archive filenames don't use periods in the version, so we have to match
  # the version from the link text.
  livecheck do
    url "http://www.convertlit.com/download.php"
    regex(/href=.*?clit[._-]?v?\d+(?:\.\d+)*src\.zip[^>]+>\s*?Convert LIT v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/convertlit"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "526a90900992dc12f491aaad536b1047733008973013b4984d54e783f04db5dc"
  end

  depends_on "libtommath"

  def install
    inreplace "clit18/Makefile" do |s|
      s.gsub! "-I ../libtommath-0.30", "#{HOMEBREW_PREFIX}/include"
      s.gsub! "../libtommath-0.30/libtommath.a", "#{HOMEBREW_PREFIX}/lib/libtommath.a"
    end

    system "make", "-C", "lib"
    system "make", "-C", "clit18"
    bin.install "clit18/clit"
  end
end
