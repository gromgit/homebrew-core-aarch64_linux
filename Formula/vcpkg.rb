class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg/archive/2020.06.tar.gz"
  sha256 "cfaecee6f18b6e2763f41c4257b6d6a1d2ef536a2018a6c7f579df0b6ad42e56"

  bottle do
    cellar :any
    sha256 "8a8aa4727a0b8e5c514c0c742c2a88b6fc7c38c9bf8f8ffdfaf3d6ce480cb047" => :catalina
    sha256 "404677363b87dd1a94ea865082fd56c1798cd71d8234b311c4cea7cfdb3c1b48" => :mojave
    sha256 "f984abc24e2316833210b1bb313b134baef6855e2b1734cb296b05a9b3237b5e" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  if MacOS.version <= :mojave
    fails_with :clang do
      cause "'file_status' is unavailable: introduced in macOS 10.15"
    end
  end

  def install
    # fix for conflicting declaration of 'char* ctermid(char*)' on Mojave
    # https://github.com/microsoft/vcpkg/issues/9029
    ENV.prepend "CXXFLAGS", "-D_CTERMID_H_" if MacOS.version == :mojave

    args = %w[-useSystemBinaries -disableMetrics]
    args << "-allowAppleClang" if MacOS.version > :mojave
    system "./bootstrap-vcpkg.sh", *args

    bin.install "vcpkg"
    bin.env_script_all_files(libexec/"bin", :VCPKG_ROOT => libexec)
    libexec.install Dir["*.txt", ".vcpkg-root", "{ports,scripts,triplets}"]
  end

  def post_install
    (var/"vcpkg/installed").mkpath
    (var/"vcpkg/packages").mkpath
    ln_s var/"vcpkg/installed", libexec/"installed"
    ln_s var/"vcpkg/packages", libexec/"packages"
  end

  test do
    assert_match "sqlite3", shell_output("#{bin}/vcpkg search sqlite")
  end
end
