class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "https://github.com/ivmai/libatomic_ops/releases/download/v7.6.14/libatomic_ops-7.6.14.tar.gz"
  sha256 "390f244d424714735b7050d056567615b3b8f29008a663c262fb548f1802d292"
  license "GPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libatomic_ops"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e27e8ccbec5b11d18cb2d924a9ebd4183e7fc90c7bdff41283afaa998c623938"
  end


  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
