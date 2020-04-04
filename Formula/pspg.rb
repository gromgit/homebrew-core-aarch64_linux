class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/2.7.2.tar.gz"
  sha256 "d657c53d9571ce97553295f407ae6c041705663c6b0e78bc01ac37d2868b513e"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "d2919cf0155856576d47fc1f55f0df3ed86849e926459c638916a17390ec2bab" => :catalina
    sha256 "56887b8b33673e768543329d927badba89761452756c07ca2bb99ce866aebe7f" => :mojave
    sha256 "fb36f17e02e53e6513eb5c25c2bcdcfa864e072253bf608080363ace6ab81815" => :high_sierra
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
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
