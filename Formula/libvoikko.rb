class Libvoikko < Formula
  desc "Linguistic software and Finnish dictionary"
  homepage "https://voikko.puimula.org/"
  url "https://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.3.1.tar.gz"
  sha256 "368240d4cfa472c2e2c43dc04b63e6464a3e6d282045848f420d0f7a6eb09a13"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.puimula.org/voikko-sources/libvoikko/"
    regex(/href=.*?libvoikko[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "32d024915b3a784c2142507c1d8c0b2ef675635ef9e387880b467a2c8aa7044b"
    sha256 cellar: :any, big_sur:       "0d36dae546a309c83750f42e8eba3b6d9b51765f78093a9b6bffa5c9d5bc0cd8"
    sha256 cellar: :any, catalina:      "94d12634dd73cba44a8e8c0fad1f2a2bea4db5ef50bffb277faaa400f798ccb0"
    sha256 cellar: :any, mojave:        "bc325b6ce79a331c7046c54449174ca7cd2640703e90f50244b5ddfe5ed8de3b"
    sha256 cellar: :any, high_sierra:   "5171bd4eeaba0f6712fd945622f76c0d615f3e6fad826329fa2ce77d8711380b"
  end

  depends_on "foma" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "hfstospell"

  resource "voikko-fi" do
    url "https://www.puimula.org/voikko-sources/voikko-fi/voikko-fi-2.4.tar.gz"
    sha256 "320b2d4e428f6beba9d0ab0d775f8fbe150284fbbafaf3e5afaf02524cee28cc"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-dictionary-path=#{HOMEBREW_PREFIX}/lib/voikko"
    system "make", "install"

    resource("voikko-fi").stage do
      ENV.append_path "PATH", bin.to_s
      system "make", "vvfst"
      system "make", "vvfst-install", "DESTDIR=#{lib}/voikko"
      lib.install_symlink "voikko"
    end
  end

  test do
    assert_match "C: onkohan", pipe_output("#{bin}/voikkospell -m", "onkohan\n")
  end
end
