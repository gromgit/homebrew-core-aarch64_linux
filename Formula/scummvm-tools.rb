class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.6.0/scummvm-tools-2.6.0.tar.xz"
  sha256 "9daf3ff8b26e3eb3d2215ea0416e78dc912b7ec21620cc496657225ea8a90428"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/scummvm/scummvm-tools.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "78512ebdf536034d934ad4889183cc98f6e4de5b4c418956118ee2aaacfd4a29"
    sha256 cellar: :any,                 arm64_big_sur:  "559e4544f32ede9f680561b86edbea6d82998acf583b63c5b994601b88b4a88c"
    sha256 cellar: :any,                 monterey:       "5f78d7b7829534c412a2afb7206e1c842df9669ec2e86ad06380ad14558cc69f"
    sha256 cellar: :any,                 big_sur:        "0250bdeb6acd8fe1051bcca2648c855739e7ac939bef172cfa77e69832ff74ee"
    sha256 cellar: :any,                 catalina:       "d06751982041199c36d78c4d64e495c25d019845c1c1fa3df182018d6850a81a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bf72c689c543e70dc8102f73760b7af2673eb239b3821c89185e233e126b409"
  end

  depends_on "boost"
  depends_on "flac"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "wxwidgets"

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
    system bin/"scummvm-tools-cli", "--list"
  end
end
