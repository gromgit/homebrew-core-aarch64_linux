class OneMl < Formula
  desc "Reboot of ML, unifying its core and (now first-class) module layers"
  homepage "https://people.mpi-sws.org/~rossberg/1ml/"
  url "https://people.mpi-sws.org/~rossberg/1ml/1ml-0.1.zip"
  sha256 "64c40c497f48355811fc198a2f515d46c1bb5031957b87f6a297822b07bb9c9a"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?1ml[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/one-ml"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "0e593d90eadde798cbc05d5889dc4909683f04791e4448a55fc871d0239a1260"
  end

  depends_on "ocaml" => :build

  # OCaml 4.06 and later compatibility
  patch do
    url "https://github.com/rossberg/1ml/commit/f99c0b3497c1f18c950dfb2ae3989573f90eaafd.patch?full_index=1"
    sha256 "778c9635f170a29fa6a53358e65fe85f32320eb678683ddd23e0e2c6139e7a6e"
  end

  def install
    system "make"
    bin.install "1ml"
    (pkgshare/"stdlib").install Dir.glob("*.1ml")
    doc.install "README.txt"
  end

  test do
    system "#{bin}/1ml", "#{pkgshare}/stdlib/prelude.1ml", "#{pkgshare}/stdlib/paper.1ml"
  end
end
