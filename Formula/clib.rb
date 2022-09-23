class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/2.8.1.tar.gz"
  sha256 "0d2330e3c46ce21d7fa3d29f0f99b9527eb5ab323b1efb9b1a0e6915779c74d6"
  license "MIT"
  head "https://github.com/clibs/clib.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/clib"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "537068ff23f38d46ac2eb34ed79488d4317f3881bff6afada1a8096848141400"
  end

  uses_from_macos "curl"

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
