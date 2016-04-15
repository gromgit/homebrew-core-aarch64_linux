class Tlassemble < Formula
  desc "Create time lapse movies from image sequences"
  homepage "http://www.dayofthenewdan.com/projects/tlassemble/"
  url "https://github.com/dbridges/cocoa-tlassemble/archive/v1.0.tar.gz"
  sha256 "ce56ebf60665a4f400b8f4b9157825bdb3f6b2034c522c93f5137ecd671fc7c6"

  bottle do
    cellar :any_skip_relocation
    sha256 "bcc1b47fd720be507a72caafeb9336469944aae69f4ae75e00ca4c7ff20665bc" => :el_capitan
    sha256 "196bf8727ebe120ce2cd168dfb46dc232e45b9ea345737b982fb5f2e713d0c53" => :yosemite
    sha256 "0fc7c156fa020a2f7b2a9dbe8b1973b27b1c427099b4eadcf1a58d039ebb4feb" => :mavericks
  end

  def install
    system "make"
    bin.install "tlassemble"
  end

  test do
    system "\"#{bin}/tlassemble\" --help | grep 'tlassemble 1.0'"
  end
end
