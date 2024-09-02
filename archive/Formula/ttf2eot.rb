class Ttf2eot < Formula
  desc "Convert TTF files to EOT"
  homepage "https://github.com/wget/ttf2eot"
  url "https://github.com/wget/ttf2eot/archive/v0.0.3.tar.gz"
  sha256 "f363c4f2841b6d0b0545b30462e3c202c687d002da3d5dec7e2b827a032a3a65"
  license any_of: ["LGPL-2.0-or-later", "BSD-2-Clause"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ttf2eot"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "bc60a12d3a2f1f43b1974e519de18535b9cf6d157708553573a5ca339419808f"
  end

  def install
    system "make"
    bin.install "ttf2eot"
  end

  test do
    if OS.mac?
      font_name = (MacOS.version >= :catalina) ? "Arial Unicode" : "Arial"
      font_dir = "/Library/Fonts"
    else
      font_name = "DejaVuSans"
      font_dir = "/usr/share/fonts/truetype/dejavu"
    end
    cp "#{font_dir}/#{font_name}.ttf", testpath
    system("#{bin}/ttf2eot < '#{font_name}.ttf' > '#{font_name}.eot'")
    assert_predicate testpath/"#{font_name}.eot", :exist?
  end
end
