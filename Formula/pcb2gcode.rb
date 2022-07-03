class Pcb2gcode < Formula
  desc "Command-line tool for isolation, routing and drilling of PCBs"
  homepage "https://github.com/pcb2gcode/pcb2gcode"
  url "https://github.com/pcb2gcode/pcb2gcode/archive/v2.4.0.tar.gz"
  sha256 "5d4f06f7041fe14a108780bdb953aa520f7e556773a7b9fb8435e9b92fef614d"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/pcb2gcode/pcb2gcode.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "70b7a09bf490ec4ab251bba4f11e384eee7ab4fdf0155b42b1586f78526cefe6"
    sha256 cellar: :any,                 arm64_big_sur:  "8982e5d343c3a2f70ad92953144d8ab89f934c40f838e607a7e4914480de6a10"
    sha256 cellar: :any,                 monterey:       "3bc721515abad735514715ac571306c65889b538faae0ea862e161f60beb84c6"
    sha256 cellar: :any,                 big_sur:        "fb2caa63d391b966d8fd3949ea76158b46f72a2ed43797bdca557e921e31d386"
    sha256 cellar: :any,                 catalina:       "febb8b969830b3c659a78e0512e7a8925f8436110185da77bd3d4556b79fb078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "096aa7ced11dea9c634d936462848bc2b75e0197370dc16adaedb7881ccfeb3f"
  end

  # Release 2.0.0 doesn't include an autoreconfed tarball
  # glibmm, gtkmm and librsvg are used only in unittests,
  # and are therefore not needed at runtime.
  depends_on "atkmm@2.28" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cairomm@1.14" => :build
  depends_on "glibmm@2.66" => :build
  depends_on "gtkmm" => :build
  depends_on "librsvg" => :build
  depends_on "libsigc++@2" => :build
  depends_on "libtool" => :build
  depends_on "pangomm@2.46" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gerbv"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # Apply upstream commit to fix build with GCC 11.  Remove with next release.
  patch do
    url "https://github.com/pcb2gcode/pcb2gcode/commit/01cd18a6d859ab1aac6c532c99be9109f083448d.patch?full_index=1"
    sha256 "b5b316b14e9b615ee9114261eb5d04a0b234823847a18bb5ab4d8e2af4210750"
  end

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"front.gbr").write <<~EOS
      %FSLAX46Y46*%
      %MOMM*%
      G01*
      %ADD11R,2.032000X2.032000*%
      %ADD12O,2.032000X2.032000*%
      %ADD13C,0.250000*%
      D11*
      X127000000Y-63500000D03*
      D12*
      X127000000Y-66040000D03*
      D13*
      X124460000Y-66040000D01*
      X124460000Y-63500000D01*
      X127000000Y-63500000D01*
      M02*
    EOS
    (testpath/"edge.gbr").write <<~EOS
      %FSLAX46Y46*%
      %MOMM*%
      G01*
      %ADD11C,0.150000*%
      D11*
      X123190000Y-67310000D02*
      X128270000Y-67310000D01*
      X128270000Y-62230000D01*
      X123190000Y-62230000D01*
      X123190000Y-67310000D01*
      M02*
    EOS
    (testpath/"drill.drl").write <<~EOS
      M48
      FMAT,2
      METRIC,TZ
      T1C1.016
      %
      G90
      G05
      M71
      T1
      X127.Y-63.5
      X127.Y-66.04
      T0
      M30
    EOS
    (testpath/"millproject").write <<~EOS
      metric=true
      zchange=10
      zsafe=5
      mill-feed=600
      mill-speed=10000
      offset=0.1
      zwork=-0.05
      drill-feed=1000
      drill-speed=10000
      zdrill=-2.5
      bridges=0.5
      bridgesnum=4
      cut-feed=600
      cut-infeed=10
      cut-speed=10000
      cutter-diameter=3
      fill-outline=true
      zbridges=-0.6
      zcut=-2.5
      al-front=true
      al-probefeed=100
      al-x=15
      al-y=15
      software=LinuxCNC
    EOS
    system "#{bin}/pcb2gcode", "--front=front.gbr",
                               "--outline=edge.gbr",
                               "--drill=drill.drl"
  end
end
