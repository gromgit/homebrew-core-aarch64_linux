class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/2.5.5.tar.gz"
  sha256 "fdef17e5ebe4211962cc7be01a9c4ae9672af4ae54865e6227c26ad269d1bc2a"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "3dd4ac46e99da57d26546bbf59b75ac00536800ea3125798242d583f0b412c3a" => :catalina
    sha256 "33921139604ab2ea39d0730a9303a5f4bd9507be0ab22e46c380d30d5ae15380" => :mojave
    sha256 "6e76b1bc3005be9c595ba39a5729bc97676a44cb5bce51daed3ba0487975f7ea" => :high_sierra
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    Add the following line to your psql profile (e.g. ~/.psqlrc)
      \\setenv PAGER pspg
      \\pset border 2
      \\pset linestyle unicode
  EOS
  end

  test do
    assert_match "pspg-#{version.to_f}", shell_output("#{bin}/pspg --version")
  end
end
