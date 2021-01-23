class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/findomain"
  url "https://github.com/Findomain/findomain/archive/3.0.0.tar.gz"
  sha256 "49efa3c55a1bf73c06e212630e20da4080313ce6d0e3d29d13544af8f2151f0b"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4ad50723952f3be57618a6d8abe573a0ee3485bcd132f6ef7f6747a676236c8e" => :big_sur
    sha256 "048595848f25aab1d8ce875ee206f2de26bff21d481af45386f3dcfe6bb60a00" => :arm64_big_sur
    sha256 "fe80011577eafc2f17973ea265859b41a13064e039179fa663a7cdbcf9199d45" => :catalina
    sha256 "4f19c79953f6e322684eeeda38a79c3a0bdeb05b6665007aa042d8644e555a8d" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
