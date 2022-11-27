class Sha3sum < Formula
  desc "Keccak, SHA-3, SHAKE, and RawSHAKE checksum utilities"
  homepage "https://github.com/maandree/sha3sum"
  url "https://github.com/maandree/sha3sum/archive/1.2.2.tar.gz"
  sha256 "57cfda5d9d16aa14c78d278b1c14fd9f3504424ee62bc18137ce6435c1364d12"
  license "ISC"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/sha3sum"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b2818dfd4c2b11610a553cea5eb350ee9f878f90e992314813af6dd66a7c07c7"
  end

  depends_on "libkeccak"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    inreplace "test", "./", "#{bin}/"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test", testpath
    system "./test"
  end
end
