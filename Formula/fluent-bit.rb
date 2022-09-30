class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.9.9.tar.gz"
  sha256 "d58dc649f6b4e2433711666ae68c8f443c0542801eb6241b21d245fb421daced"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_monterey: "19fdc15b77a5b73aa9859160a83e3aab0630140d7972f13a19aaaab9dfd630e4"
    sha256                               arm64_big_sur:  "d0cddda4b35d05968621fc1c3580b8179223f91d90653e2ba8734cc74004ca07"
    sha256                               monterey:       "e00e9a729bd42066fa16749bbaa33a5f04e4d2b308d9aa200461f77d15e0a8d0"
    sha256                               big_sur:        "a0f6c4a87ff6d90cbb6674d7210a7d1f382d7a546133464df535542435fbe018"
    sha256                               catalina:       "45a137b3290b4ddd40516d58dac4da2d04176bda6cff6a3f7bd9c88549a79d80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "885c13f69eca19ca717d07964647c72dd889d8ba86388b09921582fec485f079"
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
