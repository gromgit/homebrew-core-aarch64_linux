class Pacapt < Formula
  desc "Package manager in the style of Arch's pacman"
  homepage "https://github.com/icy/pacapt"
  url "https://github.com/icy/pacapt/archive/v3.0.6.tar.gz"
  sha256 "159490b4b9ceb15624376ba2d7062440032b7793d2da1776d43ebc0bd3616f8e"
  license "Fair"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cac7a51aebcde759b8e63946032c859a66f234318dbb5ec5ffe96e0021aad2c0"
  end

  def install
    bin.mkpath
    system "make", "install", "BINDIR=#{bin}", "VERSION=#{version}"
  end

  test do
    system "#{bin}/pacapt", "-Ss", "wget"
  end
end
