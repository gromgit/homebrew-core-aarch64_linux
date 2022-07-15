class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.9.6.tar.gz"
  sha256 "7f4de8d561695d9153dbe39b7f6d919dc849daf57cb7c402a2beb0ebe35a42e0"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_monterey: "cacf4a200dacc2dff5502ddfd5f32a635c45e46d51f40b17e94e03575eda5155"
    sha256                               arm64_big_sur:  "331f761da33844889a21539ea6803b5401d1f195bf7a7cca8ce96cf19179a873"
    sha256                               monterey:       "a933956e51e4a53e4288381b511a72568bf5be72b0f565d5a1679a4e0a9a1020"
    sha256                               big_sur:        "43e85fb10029a48a8bf088d4523f38ace50fee2211ae0265e85f2f9b0ebe7bed"
    sha256                               catalina:       "ff590fb826b45d2da094a4dd14ecfa1e917c19ad966752d3d186754def6dedde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a6bc2a830586688f9ef3f92f394a93fb28bcfd9fb1709da7412b4a5f7963c99"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"

  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    # Prevent fluent-bit to install files into global init system
    #
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    chdir "build" do
      # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
      # is not set then it's forced to 10.4, which breaks compile on Mojave.
      # fluent-bit builds against a vendored Luajit.
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end
