class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.9.2.tar.gz"
  sha256 "8289ffb9c00b20eb346ac39f396e572ac8e3e493a2b61db64ed0c0c2e797c9da"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_monterey: "fdbf4302afaec2bc8242a7cdcf1109e6deac51901e709d5068c85cd366441f36"
    sha256                               arm64_big_sur:  "8a6ad8356c263cddb8c4b83611f018b31fee8a56dafc3492d45fe879b3841229"
    sha256                               monterey:       "80992d850f32f83e88989fa5ea9d9bdb089172b663fabf25a532cfbd93816e8f"
    sha256                               big_sur:        "40213fd5a81c95c460f6bc52b40f255faa236ef6527006d0a4eae23621b12428"
    sha256                               catalina:       "15adaaadde23817406c10a1310d22e45e2f0123e9255b780b2958e3fe3a98991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb7dc43dded380a49bf209389251b61b39f7c450024c59ac5426bc72ec71484a"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build

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
