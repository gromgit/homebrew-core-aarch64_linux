class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/v0.15.2.tar.gz"
  sha256 "ddd9a37d746a264a9a8f86fb727e156188b9f8e9e3147f8be510bd768b1ef46a"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "91a54b5a3c5995ad39649300d7c07a86ca0863de908f8a1b4d5ada5a96b35425"
    sha256 cellar: :any_skip_relocation, big_sur:       "5f12b034ad92fd41682c01b07dca58ae38f0848aa5f9e7333203e022fec60e46"
    sha256 cellar: :any_skip_relocation, catalina:      "8cbc4967ccf172be818ae07ec70e9f3dc62884e79ae868eb891fdb63a3c7af21"
    sha256 cellar: :any_skip_relocation, mojave:        "a0c9c53da41f3c9ac60d65f982fb6dbb07602d79608dc9cae7042b9db465debb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"clarinet", "new", "test-project"
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
