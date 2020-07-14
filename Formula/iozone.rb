class Iozone < Formula
  desc "File system benchmark tool"
  homepage "http://www.iozone.org/"
  url "http://www.iozone.org/src/current/iozone3_490.tar"
  sha256 "5eadb4235ae2a956911204c50ebf2d8d8d59ddcd4a2841a1baf42f3145ad4fed"

  bottle do
    cellar :any_skip_relocation
    sha256 "01780007c0b535d058e5431c6cc42fc89f9c7caeb08b2a930e37618e3dacae30" => :catalina
    sha256 "2f1b2aa83dc4844aea07d2317da1e10c8649b1e654ef2a01e668f754db4ea0e0" => :mojave
    sha256 "665363653cd2fcee68332a8f872c4aa94bbe1a3b2b131a95a23f49833727dde6" => :high_sierra
  end

  def install
    cd "src/current" do
      system "make", "macosx", "CC=#{ENV.cc}"
      bin.install "iozone"
      pkgshare.install %w[Generate_Graphs client_list gengnuplot.sh gnu3d.dem
                          gnuplot.dem gnuplotps.dem iozone_visualizer.pl
                          report.pl]
    end
    man1.install "docs/iozone.1"
  end

  test do
    assert_match "File size set to 16384 kB",
      shell_output("#{bin}/iozone -I -s 16M")
  end
end
