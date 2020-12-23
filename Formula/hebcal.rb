class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.23.tar.gz"
  sha256 "bf32b8feb1f08099b462b928aed70a73523c8aaff237b7256dc7edbad46bf4a8"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3bd7989cdea11ebf9b0f23db74423f9437e8da3cd0422b79cded311599732a3" => :big_sur
    sha256 "d7a80ab99402feb40acf3d4fdf58f363af5cd5e36c8bdf168cea5578ae6ae53b" => :catalina
    sha256 "3370096c6542b25553fd3ad19f4eb5f1b4e4c9911b214979d37af97fe93ffb0f" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
