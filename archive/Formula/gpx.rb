class Gpx < Formula
  desc "Gcode to x3g converter for 3D printers running Sailfish"
  homepage "https://github.com/markwal/GPX/blob/HEAD/README.md"
  url "https://github.com/markwal/GPX/archive/2.6.8.tar.gz"
  sha256 "0877de07d405e7ced8428caa9dd989ebf90e7bdb7b1c34b85b2d3ee30ed28360"
  license "GPL-2.0"
  head "https://github.com/markwal/GPX.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gpx"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8e3386920567d2dfd260edd7c1ca23deda2bbd264451c4b981c1ae3dae094233"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.gcode").write("G28 X Y Z")
    system "#{bin}/gpx", "test.gcode"
  end
end
