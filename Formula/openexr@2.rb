class OpenexrAT2 < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/v2.5.8.tar.gz"
  sha256 "db261a7fcc046ec6634e4c5696a2fc2ce8b55f50aac6abe034308f54c8495f55"
  license "BSD-3-Clause"

  livecheck do
    formula "ilmbase"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/openexr@2"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "edac18f9fbf0535a8e0a013528a41cbfa073253396eb71715e7a5b4ce5e76722"
  end

  keg_only :versioned_formula

  # Commented out while this formula still has dependents.
  # deprecate! date: "2021-04-01", because: :unsupported

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ilmbase"

  uses_from_macos "zlib"

  resource "exr" do
    url "https://github.com/AcademySoftwareFoundation/openexr-images/raw/master/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    cd "OpenEXR" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
