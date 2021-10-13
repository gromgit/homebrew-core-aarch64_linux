class VapoursynthSub < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/subtext/archive/R2.tar.gz"
  sha256 "509fd9b00f44fd3db5ad0de4bfac6ccff3e458882281d479a11c10ac7dfc37e4"
  license "MIT"
  version_scheme 1

  head "https://github.com/vapoursynth/subtext.git", branch: "master"

  livecheck do
    formula "vapoursynth"
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e00dd437364121c4633ac304e1494bffa20a9fad1e4f4fee4de3cd16015a17f2"
    sha256 cellar: :any, big_sur:       "40eda0329ae57f8deaac051521a8ee8f1fe6f5106db3ef024f2fce9ce3432f09"
    sha256 cellar: :any, catalina:      "29204e101abc88a961a53518abc868c67af788b1369e3fc07e8df439442859d7"
    sha256 cellar: :any, mojave:        "291ec2fad5ccca0b0046b29a2bcb842a700e8395d106747058faf60032735cd4"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libass"
  depends_on "vapoursynth"

  def install
    # A meson-based install method has been added but is not present
    # in this release. Switch to it in the next release to avoid
    # manually installing the shared library.
    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    (lib/"vapoursynth").install "build/#{shared_library("libsubtext")}"
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", "from vapoursynth import core; core.sub"
  end
end
