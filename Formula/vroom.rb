class Vroom < Formula
  desc "Vehicle Routing Open-Source Optimization Machine"
  homepage "http://vroom-project.org/"
  url "https://github.com/VROOM-Project/vroom.git",
      tag:      "v1.12.0",
      revision: "d3abd6b22fe4afc0daa64d6b905911999b12dcdd"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7a823e112cf6cac7b986ca5e142c1517a8be92fc34048ea26ad4cd97e0b68703"
    sha256 cellar: :any,                 arm64_big_sur:  "3bf10d29ff9e95edd39ac68c2ffde3e87ebb86f42a220486471d3e641b1048e9"
    sha256 cellar: :any,                 monterey:       "93d5164b0e7630e9af621d7da2eb9c550b23c5701ca28117eb43f16861762377"
    sha256 cellar: :any,                 big_sur:        "8e22ef70463048645622fa6892cd17561dff683b261e4b0e4133ddded27f6714"
    sha256 cellar: :any,                 catalina:       "aa67ba7ad30b43826f38d798f67689ad224080791950e82ef763d29420a30e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b43cccb5dfda7f01cee6c9ca1fa43a3cb11879cb35e85183ec05df8e26770c0"
  end

  depends_on "cxxopts" => :build
  depends_on "pkg-config" => :build
  depends_on "rapidjson" => :build
  depends_on "asio"
  depends_on macos: :mojave # std::optional C++17 support
  depends_on "openssl@1.1"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # Fix build on macOS (https://github.com/VROOM-Project/vroom/issues/723)
  # Patch accepted upstream, remove on next release
  patch do
    url "https://github.com/VROOM-Project/vroom/commit/f9e66df218e32eeb0026d2e1611a27ccf004fefd.patch?full_index=1"
    sha256 "848d5f03910d5cd4ae78b68f655c2db75a0e9f855e5ec34855e8cac58a0601b7"
  end

  def install
    # Use brewed dependencies instead of vendored dependencies
    cd "include" do
      rm_rf ["cxxopts", "rapidjson"]
      mkdir_p "cxxopts"
      ln_s Formula["cxxopts"].opt_include, "cxxopts/include"
      ln_s Formula["rapidjson"].opt_include, "rapidjson"
    end

    cd "src" do
      system "make"
    end
    bin.install "bin/vroom"
    pkgshare.install "docs"
  end

  test do
    output = shell_output("#{bin}/vroom -i #{pkgshare}/docs/example_2.json")
    expected_routes = JSON.parse((pkgshare/"docs/example_2_sol.json").read)["routes"]
    actual_routes = JSON.parse(output)["routes"]
    assert_equal expected_routes, actual_routes
  end
end
