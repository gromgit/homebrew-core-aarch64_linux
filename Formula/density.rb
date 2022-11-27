class Density < Formula
  desc "Superfast compression library"
  homepage "https://github.com/k0dai/density"
  url "https://github.com/k0dai/density/archive/density-0.14.2.tar.gz"
  sha256 "0b130ea9da3ddaad78810a621a758b47c4135d91d5b5fd22d60bbaf04bc147da"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/density"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e853ae1adc8b01dd78da159de2c3eb7b79090be2e119f9aa509f3d6672faf646"
  end

  resource "cputime" do
    url "https://github.com/k0dai/cputime.git",
        revision: "d435d91b872a4824fb507a02d0d1814ed3e791b0"
  end

  resource "spookyhash" do
    url "https://github.com/k0dai/spookyhash/archive/spookyhash-1.0.6.tar.gz"
    sha256 "11215a240af513e673e2d5527cd571df0b4f543f36cce50165a6da41695144c6"
  end

  def install
    # The `gcc-ar` wrapper must be used for LTO to work for the static library on Linux.
    ENV["AR"] = "gcc-ar" unless OS.mac?
    (buildpath/"benchmark/libs/cputime").install resource("cputime")
    (buildpath/"benchmark/libs/spookyhash").install resource("spookyhash")
    system "make"
    include.install "src/density_api.h"
    pkgshare.install "build/benchmark"
    lib.install "build/libdensity.a"
    lib.install "build/#{shared_library("libdensity")}"
  end

  test do
    system pkgshare/"benchmark", "-f"
  end
end
