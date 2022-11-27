class Arabica < Formula
  desc "XML toolkit written in C++"
  homepage "https://www.jezuk.co.uk/tags/arabica.html"
  url "https://github.com/jezhiggins/arabica/archive/2020-April.tar.gz"
  version "20200425"
  sha256 "b00c7b8afd2c3f17b5a22171248136ecadf0223b598fd9631c23f875a5ce87fe"
  license "BSD-3-Clause"
  head "https://github.com/jezhiggins/arabica.git", branch: "main"

  # The `strategy` block below is used to generate a version from the datetime
  # of the "latest" release on GitHub, so it will match the formula `version`.
  livecheck do
    url :stable
    regex(/datetime=["']?(\d{4}-\d{2}-\d{2})T/i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/arabica"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b1b95252db60067363ca4b9da1c6cf81e4a2444c434dbf8a5eff9331f2adc4cf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost"

  uses_from_macos "expat"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/mangle")
    assert_match "mangle is an (in-development) XSLT processor", output
  end
end
