class Quotatool < Formula
  desc "Edit disk quotas from the command-line"
  homepage "https://quotatool.ekenberg.se/"
  url "https://quotatool.ekenberg.se/quotatool-1.6.2.tar.gz"
  sha256 "e53adc480d54ae873d160dc0e88d78095f95d9131e528749fd982245513ea090"
  license "GPL-2.0"

  livecheck do
    url "https://quotatool.ekenberg.se/index.php?node=download"
    regex(/href=.*?quotatool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/quotatool"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "36933a1c1d44151288a7a055981bbc22307432f75616a90f2b8562bdf7e82fb0"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    sbin.mkpath
    man8.mkpath
    system "make", "install"
  end

  test do
    system "#{sbin}/quotatool", "-V"
  end
end
