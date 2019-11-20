class Skymaker < Formula
  desc "Generates fake astronomical images"
  homepage "https://www.astromatic.net/software/skymaker"
  url "https://www.astromatic.net/download/skymaker/skymaker-3.10.5.tar.gz"
  sha256 "a16f9c2bd653763b5e1629e538d49f63882c46291b479b4a4997de84d8e9fb0f"

  depends_on "autoconf" => :build
  depends_on "fftw"

  def install
    system "autoconf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "added", shell_output("#{bin}/sky 2>&1")
  end
end
