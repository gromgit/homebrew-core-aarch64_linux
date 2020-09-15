class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/v4.0.0.0.tar.gz"
  sha256 "4f3513c43edf0178391ed5755266864532716b8b503bcfb9a983ae6256c51b14"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  head "https://github.com/EttusResearch/uhd.git"

  livecheck do
    url "https://github.com/EttusResearch/uhd/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 "3ca192e6af5f393b5317e90db8c3313aa8bf16d7fb9daf53bb5467ffbe3a772e" => :big_sur
    sha256 "8e65f370dea3f23cb226e35595441c1b998f1044737e3f327cb15bcc6c12838d" => :catalina
    sha256 "78652146db42531d9af14c776f8acb4eaaa1abbb2d956aeedcaa27d91f7bd305" => :mojave
    sha256 "107ab41c9790f36ef37efb7382a65d8cd57f8bd872408943f8224dc3061d1bab" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.9"

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/72/89/402d2b4589e120ca76a6aed8fee906a0f5ae204b50e455edd36eda6e778d/Mako-1.1.3.tar.gz"
    sha256 "8195c8c1400ceb53496064314c6736719c6f25e7479cd24c77be3d9361cddc27"
  end

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    resource("Mako").stage do
      system Formula["python@3.9"].opt_bin/"python3",
             *Language::Python.setup_install_args(libexec/"vendor")
    end

    mkdir "host/build" do
      system "cmake", "..", *std_cmake_args, "-DENABLE_STATIC_LIBS=ON", "-DENABLE_TESTS=OFF"
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end
