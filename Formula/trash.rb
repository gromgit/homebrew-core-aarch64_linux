class Trash < Formula
  desc "CLI tool that moves files or folder to the trash"
  homepage "https://hasseg.org/trash/"
  url "https://github.com/ali-rantakari/trash/archive/v0.9.2.tar.gz"
  sha256 "e8739c93d710ac4da721e16878e7693019d3a2ad7d8acd817f41426601610083"
  license "MIT"
  head "https://github.com/ali-rantakari/trash.git", branch: "master"

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  depends_on :macos

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash-cli", because: "both install a `trash` binary"

  def install
    system "make"
    system "make", "docs"
    bin.install "trash"
    man1.install "trash.1"
  end

  test do
    system "#{bin}/trash"
  end
end
