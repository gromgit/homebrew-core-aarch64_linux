class Phoon < Formula
  desc "Displays current or specified phase of the moon via ASCII art"
  homepage "https://www.acme.com/software/phoon/"
  url "https://www.acme.com/software/phoon/phoon_14Aug2014.tar.gz"
  version "20140814"
  sha256 "bad9b5e37ccaf76a10391cc1fa4aff9654e54814be652b443853706db18ad7c1"
  version_scheme 1

  # We check the site using HTTP (rather than HTTPS) because this server
  # produces the following cURL error on our Ubuntu CI:
  #   curl: (56) GnuTLS recv error (-110): The TLS connection was non-properly
  #   terminated.
  # If/when this is resolved, we can update this to use `url :homepage`.
  livecheck do
    url "http://www.acme.com/software/phoon/"
    regex(/href=.*?phoon[._-]v?(\d{1,2}[a-z]+\d{2,4})\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| Date.parse(match.first)&.strftime("%Y%m%d") }
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/phoon"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b9a3b08249e269eef5ba690f4491585f38d03d73aa4bb50be5bc22c909a28071"
  end

  def install
    system "make"
    bin.install "phoon"
    man1.install "phoon.1"
  end

  test do
    system "#{bin}/phoon"
  end
end
