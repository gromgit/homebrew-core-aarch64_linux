class Globe < Formula
  desc "Prints ASCII graphic of currently-lit side of the Earth"
  homepage "https://www.acme.com/software/globe/"
  url "https://www.acme.com/software/globe/globe_14Aug2014.tar.gz"
  version "0.0.20140814"
  sha256 "5507a4caaf3e3318fd895ab1f8edfa5887c9f64547cad70cff3249350caa6c86"

  livecheck do
    url :homepage
    regex(/href=.*?globe[._-](\d{1,2}\w+\d{2,4})\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| Date.parse(match.first)&.strftime("0.0.%Y%m%d") }
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/globe"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "954e6536eea026b600c498b0187a62d977526ce0b707e3e7c6da33b5b96f1c84"
  end

  def install
    bin.mkpath
    man1.mkpath

    system "make", "all", "install", "BINDIR=#{bin}", "MANDIR=#{man1}"
  end

  test do
    system "#{bin}/globe"
  end
end
