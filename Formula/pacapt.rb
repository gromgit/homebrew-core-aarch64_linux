class Pacapt < Formula
  desc "Package manager in the style of Arch's pacman"
  homepage "https://github.com/icy/pacapt"
  url "https://github.com/icy/pacapt/archive/v3.0.3.tar.gz"
  sha256 "b9e984f9ed81fcf9d1aaf270b18c512ccc7443fc15412530e4b2ec3c754bf4a6"
  license "Fair"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e4c4bd5edea42dd8e0ad6a5315b3960daa84b360e87619e7843599d63b79758c"
  end

  def install
    bin.mkpath
    system "make", "install", "BINDIR=#{bin}", "VERSION=#{version}"
  end

  test do
    system "#{bin}/pacapt", "-Ss", "wget"
  end
end
