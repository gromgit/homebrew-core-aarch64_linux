class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.21.0-Source.tar.gz"
  sha256 "da0a0bf184bb436052e3eae582defafecdb7c08cdaab7216780476e49b509755"
  license "Apache-2.0"

  livecheck do
    url "https://software.ecmwf.int/wiki/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "d9fa397297960472ba10a04051075ba5042fcbc790bd361295c3e27db8d21129"
    sha256 big_sur:       "6578d9ba48507eabbba86d742671f46ae68a95a41b0aeb7561b7e830b3b1180e"
    sha256 catalina:      "d4d8cd897a7bd149fa9cc6e6e0fa3e0f3029f4fd865a0c78a2fc3bfed0d39721"
    sha256 mojave:        "d02a1fa0bd508ede255dd971274a14dc8fcfaed0bfc6a27d828ff0fe319ba801"
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
