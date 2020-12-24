class Shntool < Formula
  desc "Multi-purpose tool for manipulating and analyzing WAV files"
  homepage "http://shnutils.freeshell.org/shntool/"
  url "http://shnutils.freeshell.org/shntool/dist/src/shntool-3.0.10.tar.gz"
  mirror "https://www.mirrorservice.org/sites/download.salixos.org/x86_64/extra-14.2/source/audio/shntool/shntool-3.0.10.tar.gz"
  sha256 "74302eac477ca08fb2b42b9f154cc870593aec8beab308676e4373a5e4ca2102"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2d6288006837305251858e7ff434646727104197329ac62a3c534ad7cbc50f68" => :big_sur
    sha256 "b9978393fd387c12aa64ae33b653b790df8bb422f2d278c146071fa402de0e02" => :catalina
    sha256 "e7dfe8483a2c233a3bf6ce9838367a0a292c08a764afb1e156ca6cad537e9e31" => :mojave
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/shninfo", test_fixtures("test.wav")
  end
end
