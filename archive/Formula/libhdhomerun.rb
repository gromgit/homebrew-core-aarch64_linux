class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20220303.tgz"
  sha256 "1e54ffefc2d4893911501da31e662b9d063e6c18afe2cb5c6653325277a54a97"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.silicondust.com/hdhomerun/libhdhomerun.tgz"
    regex(/libhdhomerun[._-]v?(\d+(?:\.\d+)*)\.t/i)
    strategy :header_match
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libhdhomerun"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8fa280741497369e26adfbf40e7edbf1c7c7ed86d4dfd8bfd0d45be09ba81541"
  end

  def install
    system "make"
    bin.install "hdhomerun_config"
    lib.install shared_library("libhdhomerun")
    include.install Dir["hdhomerun*.h"]
  end

  test do
    # Devices may be found or not found, with differing return codes
    discover = pipe_output("#{bin}/hdhomerun_config discover")
    assert_match(/no devices found|hdhomerun device|found at/, discover)
  end
end
