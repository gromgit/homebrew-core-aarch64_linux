class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "https://github.com/ivmai/libatomic_ops/releases/download/v7.6.12/libatomic_ops-7.6.12.tar.gz"
  sha256 "f0ab566e25fce08b560e1feab6a3db01db4a38e5bc687804334ef3920c549f3e"
  license "GPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libatomic_ops"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "2750f4129484e8bb09da388a5f034aa6a4075b48c375db8ea37933afa32ede6a"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
