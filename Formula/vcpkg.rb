class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg/archive/2020.04.tar.gz"
  sha256 "51bdc81d074407b760de5950760f43c253da6cd8135e13744967cf7c95e837fd"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ba22eee80d89ba5518d0bdd0e38e6e0a2d7656d986467b26177a7cba4e15fe3" => :catalina
    sha256 "b6648b679288130524034783cc3dada6dc21eba7f850b3fa331eecaa3fc3a7a2" => :mojave
    sha256 "aa6e77116fbf6aa56f450eaea187639d485a7e91640b87013403bef1411993a0" => :high_sierra
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
