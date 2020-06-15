class Ott < Formula
  desc "Tool for writing definitions of programming languages and calculi"
  homepage "https://www.cl.cam.ac.uk/~pes20/ott/"
  url "https://github.com/ott-lang/ott/archive/0.31.tar.gz"
  sha256 "7723378fdec3a322005b7505d20ec1a6ae7756823426317156d2ebafe26fd930"
  head "https://github.com/ott-lang/ott.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1cf56f59cd4fa2cd4c1e067fdcd9c63d9287ea700b9ced54af926222b43dfea0" => :catalina
    sha256 "f96a67f19f9eea3bebd7144e126b37aceae2853d2f3b91fb6a06b3dec533ab30" => :mojave
    sha256 "0383486c69d738578cd580b9e9b4de2274909ce86cad1fc5274c5c13b2bcabd7" => :high_sierra
  end

  depends_on "ocaml" => :build

  def install
    system "make", "world"
    bin.install "bin/ott"
    pkgshare.install "examples"
    (pkgshare/"emacs/site-lisp/ott").install "emacs/ott-mode.el"
  end

  test do
    system "#{bin}/ott", "-i", pkgshare/"examples/peterson_caml.ott",
      "-o", "peterson_caml.tex", "-o", "peterson_caml.v"
  end
end
