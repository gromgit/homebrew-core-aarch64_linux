class Rsnapshot < Formula
  desc "File system snapshot utility (based on rsync)"
  homepage "https://www.rsnapshot.org/"
  url "https://github.com/rsnapshot/rsnapshot/releases/download/1.4.4/rsnapshot-1.4.4.tar.gz"
  sha256 "c1cb7cb748c5a9656c386362bdf6c267959737724abb505fbf9e940a9d988579"
  license "GPL-2.0"
  head "https://github.com/rsnapshot/rsnapshot.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "debc885727c81ec84b780d5ebf84e94531a96a45a1c5b6151f5e4cc9cbe7f162"
    sha256 cellar: :any_skip_relocation, big_sur:       "58392bc53c467eaab2d62cf6ffbf6598f0a709e679c92430ed8583209da7cccf"
    sha256 cellar: :any_skip_relocation, catalina:      "e195b17e2c28a787e6bc183c3f57397256fba91c8d5c490f3c24576033d39a74"
    sha256 cellar: :any_skip_relocation, mojave:        "e195b17e2c28a787e6bc183c3f57397256fba91c8d5c490f3c24576033d39a74"
    sha256 cellar: :any_skip_relocation, high_sierra:   "e195b17e2c28a787e6bc183c3f57397256fba91c8d5c490f3c24576033d39a74"
  end

  uses_from_macos "rsync" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/rsnapshot", "--version"
  end
end
