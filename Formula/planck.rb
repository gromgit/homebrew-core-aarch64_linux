class Planck < Formula
  desc "Stand-alone OS X ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/1.13.tar.gz"
  sha256 "f0613d6554c719006b554f7b0d2393d5928428d8bdd61adb845e91bb1a862a05"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f334c7530e635fdebe024b6ae4561c60d1af09efc458661917c5b5a2ec5660f" => :el_capitan
    sha256 "0383f5df703a1a8d1374324625d502e8e8b3d0cb21d9bd078a7446d40dee1745" => :yosemite
    sha256 "c062e307e5681be00a9ed83a35d3c2e838927ba872f35a065dffca788d0b09db" => :mavericks
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
