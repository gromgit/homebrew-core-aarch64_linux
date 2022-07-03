class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/2022-06-17.tar.gz"
  version "2022.06.17"
  sha256 "4b1f477510cde965f230317305b0b111bce20f21e02c1c0e73d7bb6ebec0e783"
  license "MIT"
  head "https://github.com/microsoft/vcpkg-tool.git", branch: "main"

  # The source repository has pre-release tags with the same
  # format as the stable tags.
  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d{4}(?:[._-]\d{2}){2})["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "80820e827202de1533d2cfcdd221f588e12027986a24f33985542466a53b9a47"
    sha256 cellar: :any,                 arm64_big_sur:  "0a26d57af1488987e62cad10dbca55bf9034c95e6bf7fd4843e3a4999a8fd3f5"
    sha256 cellar: :any,                 monterey:       "92a8476fb93392bf818dc56e36c6e8d469e2b2b7d0d1d85f1999254102a6cd74"
    sha256 cellar: :any,                 big_sur:        "f6a94c99e1e5e22f6a24c7999e97e295216ea70d5561deb367b81e48fd70a98f"
    sha256 cellar: :any,                 catalina:       "ae2128c1cc8280ce1ec55fdbecdd94e3ffd20169475fe9a216f33e866aa03e1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a8170967cb129e69c6e219a9e785582a6e49b160852c8a069b56773c80fc570"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace ["src/vcpkg/vcpkgpaths.cpp", "locales/messages.json"],
              "If you are trying to use a copy of vcpkg that you've built, y", "Y"

    system "cmake", "-S", ".", "-B", "build",
                    "-DVCPKG_DEVELOPMENT_WARNINGS=OFF",
                    "-DVCPKG_BASE_VERSION=#{version.to_s.tr(".", "-")}",
                    "-DVCPKG_VERSION=#{version}",
                    "-DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  # This is specific to the way we install only the `vcpkg` tool.
  def caveats
    <<~EOS
      This formula provides only the `vcpkg` executable. To use vcpkg:
        git clone https://github.com/microsoft/vcpkg "$HOME/vcpkg"
        export VCPKG_ROOT="$HOME/vcpkg"
    EOS
  end

  test do
    message = "error: Could not detect vcpkg-root."
    assert_match message, shell_output("#{bin}/vcpkg search sqlite", 1)
  end
end
