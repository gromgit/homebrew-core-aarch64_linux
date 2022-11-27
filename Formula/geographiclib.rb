class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib-C++/GeographicLib-2.1.1.tar.gz"
  sha256 "28080fc48e1c76560eb2f8c306404de80c13d35687f676ff47a51695506e4a0a"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/geographiclib"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "1218f12cff88ccc42063cc356813fba4255aadc447ca89c6d473cc1382a6f360"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}" if OS.mac?
      args << "-DEXAMPLEDIR="
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system bin/"GeoConvert", "-p", "-3", "-m", "--input-string", "33.3 44.4"
  end
end
