class Polyml < Formula
  desc "Standard ML implementation"
  homepage "https://www.polyml.org/"
  url "https://github.com/polyml/polyml/archive/v5.8.2.tar.gz"
  sha256 "310b0ba748a50f38e99de7f65ba990bc4b4f4b0123ad76aba4c44d7cd1ed9277"
  license "LGPL-2.1"
  head "https://github.com/polyml/polyml.git"

  bottle do
    sha256 big_sur:     "f1f5c8dfdf185d5fc562d3fdc80f30cd646bce0dde7cb9381a731372b22ff11b"
    sha256 catalina:    "22f583ec73be6a469af9adff8eb3e3bc7b7ad7b40db56c16a91569f3d2097dbc"
    sha256 mojave:      "65a6a917d00e9bfb09705833ac96584f3e503edb3342c7203b083f17c8103d97"
    sha256 high_sierra: "1f0d015938e838043ab26bffb144a2abe0cf5ad5944514c1a8497d79f02dbede"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"hello.ml").write <<~EOS
      let
        fun concatWithSpace(a,b) = a ^ " " ^ b
      in
        TextIO.print(concatWithSpace("Hello", "World"))
      end
    EOS
    assert_match "Hello World", shell_output("#{bin}/poly --script hello.ml")
  end
end
