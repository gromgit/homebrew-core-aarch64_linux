class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  url "https://breakfastquay.com/files/releases/rubberband-1.9.1.tar.bz2"
  sha256 "fc474878f6823c27ef5df1f9616a8c8b6a4c01346132ea7d1498fe5245e549e3"
  license "GPL-2.0-or-later"
  head "https://hg.sr.ht/~breakfastquay/rubberband", using: :hg

  livecheck do
    url :homepage
    regex(/Rubber Band Library v?(\d+(?:\.\d+)+) released/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b7436d1a91b540cc384f15f3c4416f229635c5412b5939ae0037ceb8158bf451"
    sha256 cellar: :any, big_sur:       "f5b7d05107fadeca115e0ab09130178ede93fb6f0e18c7b392bdd77e3587b966"
    sha256 cellar: :any, catalina:      "4598d98fb8994cd6545f5858a38beae10b43968317b53ec0916542d95355f27c"
    sha256 cellar: :any, mojave:        "487182397781621580ecb07f51d301d84b46c6f2f8458880cb8213044f5181cb"
    sha256 cellar: :any, high_sierra:   "15082ba72d1f88258739752b4f4a8094d5f931fac1d69aa64d8bf25ecb21648d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libsamplerate"
  depends_on "libsndfile"

  on_linux do
    depends_on "fftw"
    depends_on "ladspa-sdk"
    depends_on "openjdk"
    depends_on "vamp-plugin-sdk"
  end

  def install
    mkdir "build" do
      system "meson", *std_meson_args
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    output = shell_output("#{bin}/rubberband -t2 #{test_fixtures("test.wav")} out.wav 2>&1")
    assert_match "Pass 2: Processing...", output
  end
end
