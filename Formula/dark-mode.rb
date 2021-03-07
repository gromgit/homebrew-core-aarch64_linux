class DarkMode < Formula
  desc "Control the macOS dark mode from the command-line"
  homepage "https://github.com/sindresorhus/dark-mode"
  url "https://github.com/sindresorhus/dark-mode/archive/v3.0.2.tar.gz"
  sha256 "fda7d4337fe3f0af92267fb517a17f11a267b5f8f38ec2db0c416526efd42619"
  license "MIT"
  head "https://github.com/sindresorhus/dark-mode.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "f55ca33ba8a81afb01c168743c8ecad337af15d883822acd9982729b2a129bcb"
    sha256 cellar: :any_skip_relocation, catalina: "b9ce8876210cccd70e87ed5781a313f4b2705330453cd4af7ff2474f659d184e"
    sha256 cellar: :any_skip_relocation, mojave:   "bfb3cbcc43a333d6ca8ef8c52c89dc6d0cc23938f4e4fbd6ac13683e4ad63bd6"
  end

  depends_on xcode: :build
  depends_on macos: :mojave

  def install
    mkdir "bin"
    system "./build"
    bin.install "bin/dark-mode"
  end

  test do
    assert_match(/\A(on|off)\z/, shell_output("#{bin}/dark-mode status").chomp)
  end
end
