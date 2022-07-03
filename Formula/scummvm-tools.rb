class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.5.0/scummvm-tools-2.5.0.tar.xz"
  sha256 "5cdc8173e1ee3fb74d62834e79995be0c5b1d999f72a0a125fab611222f927da"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/scummvm/scummvm-tools.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "25802720d5990ecf69ef61dfdfba57dd7a2c017a91ce31eb85dbb55cc0e86216"
    sha256 cellar: :any,                 arm64_big_sur:  "46153393342ac8d4b9ebffaa30bf404c2d2a04228fd0303a8aada5bb2d84286d"
    sha256 cellar: :any,                 monterey:       "c328946d81f8025c6240e0e75b18369d9475ecafa4349d6781547dc51e96586c"
    sha256 cellar: :any,                 big_sur:        "35772d6de4633c6fbfeaed8e800fdc188591dda5dc28f9a960d91c1e43094bee"
    sha256 cellar: :any,                 catalina:       "bcc9754b82e993b53eeca37efa6351d54593de0e2204cde353fa5df52bcd24b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e20689e030d11aed9c77ec9df02beb39547ec8b5f9dfe97791ecc7ab3f59af01"
  end

  depends_on "boost"
  depends_on "flac"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "wxwidgets@3.0"

  def install
    # configure will happily carry on even if it can't find wxwidgets,
    # so let's make sure the install method keeps working even when
    # the wxwidgets dependency version changes
    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)?)?$/) }
                    .to_formula

    # The configure script needs a little help finding our wx-config
    wxconfig = "wx-config-#{wxwidgets.version.major_minor}"
    inreplace "configure", /^_wxconfig=wx-config$/, "_wxconfig=#{wxconfig}"

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--enable-verbose-build"
    system "make", "install"
  end

  test do
    system "#{bin}/scummvm-tools-cli", "--list"
  end
end
