class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.21.0-Source.tar.gz"
  sha256 "da0a0bf184bb436052e3eae582defafecdb7c08cdaab7216780476e49b509755"
  license "Apache-2.0"
  revision 3

  livecheck do
    url "https://software.ecmwf.int/wiki/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "1e5abc64db5fee39068c13ba7f3c793fa85455374418537dff65b95a1d3ac2c7"
    sha256 big_sur:       "3e5ea15804e66d04fd04974eae397cca9b84348c8a45c206f8f421145e98637d"
    sha256 catalina:      "f9d24402dd6f55cc7709bb4b80e858826b8ffd2d7571a8832642b959c6dcccbd"
    sha256 mojave:        "d3132e4511814160ef3e9df97609339d2445eb09b2edbb97eafd8422ecbb18e6"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "jasper"
  depends_on "libpng"
  depends_on "netcdf"

  def install
    # Fix for GCC 10, remove with next version
    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=957159
    ENV.prepend "FFLAGS", "-fallow-argument-mismatch"

    inreplace "CMakeLists.txt", "find_package( OpenJPEG )", ""

    mkdir "build" do
      system "cmake", "..", "-DENABLE_NETCDF=ON", "-DENABLE_PNG=ON",
                            "-DENABLE_PYTHON=OFF", "-DENABLE_ECCODES_THREADS=ON",
                             *std_cmake_args
      system "make", "install"
    end

    # Avoid references to Homebrew shims directory
    inreplace include/"eccodes_ecbuild_config.h", HOMEBREW_LIBRARY/"Homebrew/shims/mac/super/clang", "/usr/bin/clang"
    inreplace lib/"pkgconfig/eccodes.pc", HOMEBREW_LIBRARY/"Homebrew/shims/mac/super/clang", "/usr/bin/clang"
    inreplace lib/"pkgconfig/eccodes_f90.pc", HOMEBREW_LIBRARY/"Homebrew/shims/mac/super/clang", "/usr/bin/clang"
  end

  test do
    grib_samples_path = shell_output("#{bin}/codes_info -s").strip
    assert_match "packingType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB1.tmpl")
    assert_match "gridType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB2.tmpl")
  end
end
