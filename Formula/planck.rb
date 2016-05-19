class Planck < Formula
  desc "Stand-alone OS X ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/1.12.1.tar.gz"
  sha256 "f98763a0b6ed83029ac7eb44af3e57491070b1b8afafa71d485b020fe8f90720"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fdce572a98520edae023658968ff0e45face3b1edc5c80f1a81bfdef3bd1499a" => :el_capitan
    sha256 "389017a906346137b71368ffa5bb51b0735b25e79e8a321fd0833935c59b13d1" => :yosemite
    sha256 "2062960b4aeb1d52af125d3b5294570f874343033d60280e4183239df9b0bf1d" => :mavericks
  end

  depends_on "leiningen" => :build
  depends_on :xcode => :build
  depends_on :macos => :mavericks

  def install
    system "./script/build-sandbox"
    bin.install "build/Release/planck"
  end

  test do
    system "#{bin}/planck", "-e", "(- 1 1)"
  end
end
