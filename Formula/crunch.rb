class Crunch < Formula
  desc "Wordlist generator"
  homepage "https://sourceforge.net/projects/crunch-wordlist/"
  url "https://downloads.sourceforge.net/project/crunch-wordlist/crunch-wordlist/crunch-3.6.tgz"
  sha256 "6a8f6c3c7410cc1930e6854d1dadc6691bfef138760509b33722ff2de133fe55"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/crunch"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b8789ac24f4fda4a17e28742cbd7e3aa7c530dd8e4caa503c98813df15d555e1"
  end

  def install
    system "make", "CC=#{ENV.cc}", "LFS=-D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"

    bin.install "crunch"
    man1.install "crunch.1"
    share.install Dir["*.lst"]
  end

  test do
    system "#{bin}/crunch", "-v"
  end
end
