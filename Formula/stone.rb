class Stone < Formula
  desc "TCP/IP packet repeater in the application layer"
  homepage "https://www.gcd.org/sengoku/stone/"
  url "https://www.gcd.org/sengoku/stone/stone-2.4.tar.gz"
  sha256 "d5dc1af6ec5da503f2a40b3df3fe19a8fbf9d3ce696b8f46f4d53d2ac8d8eb6f"

  livecheck do
    url :homepage
    regex(/href=.*?stone[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/stone"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "576d21ebc1035371a6f786de4395875a81f96db70e3988bc532d9165b5d1c2cb"
  end

  def install
    os = OS.mac? ? "macosx" : OS.kernel_name.downcase
    system "make", os
    bin.install "stone"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stone -h 2>&1", 1)
  end
end
