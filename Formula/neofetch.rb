class Neofetch < Formula
  desc "fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/1.6.tar.gz"
  sha256 "d48f581473fbfc37d250509f8dc2b10bc48df8eafef2429b2a48865d14c88092"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ef1c16b29dd40dcc3c2c3b4faf062b1ab32146dbf1e6c065c4f4eb025ab8fe0" => :el_capitan
    sha256 "122c3aa39eb3ea1ea4dc79827381bb09bb50964d91f859c0d88b679b16aec4d8" => :yosemite
    sha256 "ee6cd0f34c3be48eebe3ccb9e7d391d64abdead610c4690ad30957a35d868340" => :mavericks
  end

  depends_on "screenresolution" => :recommended
  depends_on "imagemagick" => :recommended

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/neofetch", "--test", "--config off"
  end
end
