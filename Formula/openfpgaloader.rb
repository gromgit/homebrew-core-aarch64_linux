class Openfpgaloader < Formula
  desc "Universal utility for programming FPGA"
  homepage "https://github.com/trabucayre/openFPGALoader"
  url "https://github.com/trabucayre/openFPGALoader/archive/v0.6.0.tar.gz"
  sha256 "0971db2302e704966d2e29b8d34e95f553cfd8f81e5ab70ec0533f03f219cf49"
  license "Apache-2.0"
  head "https://github.com/trabucayre/openFPGALoader.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ccd414071fcf39ba458105556c2e1e60f152417f7e796b821bf5640671ae33f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e457e88cf813303dedb16d9fee8fcc577cac17d3c9276fd7ee21bfa3685c5361"
    sha256 cellar: :any_skip_relocation, monterey:       "10d1b3a5d8f0245da7952d25cba9191fb4012e110a8e33f88df31f8529bbf691"
    sha256 cellar: :any_skip_relocation, big_sur:        "c577d1bf83ef0231ad07cc16c8ff1d64354b80fbd1079eb5a3bd85946a7ed7f6"
    sha256 cellar: :any_skip_relocation, catalina:       "739456515905a9c75676bfc5c0e4c2385d6602d0cc1342df8a042c564c00d8dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90ab75ffc9c43013658b46c770b71ad0dc4124c4af79ddcbf397f2ecc6a857e6"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libftdi"
  depends_on "libusb"
  uses_from_macos "zlib"

  # Fix incorrect version
  # https://github.com/trabucayre/openFPGALoader/pull/144
  patch do
    url "https://github.com/trabucayre/openFPGALoader/commit/efeb0d83c479200e359407245f82000ee4f33558.patch?full_index=1"
    sha256 "7f15ac39f8d079ebe8e73a763bbb4e3d7b441f74df1d5586dbe15af967d5fc33"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    version_output = shell_output("#{bin}/openFPGALoader -V 2>&1")
    assert_match "openFPGALoader v#{version}", version_output

    error_output = shell_output("#{bin}/openFPGALoader --detect 2>&1 >/dev/null", 1)
    assert_includes error_output, "JTAG init failed"
  end
end
