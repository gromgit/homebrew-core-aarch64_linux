class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.0.0.tar.zst"
  version "1.0.0"
  sha256 "8d99b8fc1057aef6437be1312112781e00030afdd01da2f0e233b042187a2f01"
  license "GPL-3.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "c03721823a2849b78cc5ccf20e52a0ae0469e1795f9b2c36110b949b1bc5168e" => :big_sur
    sha256 "ec16c45979431a557b937df2a5e657bc85b576a2ebf9f9b089895e7f2ded917c" => :arm64_big_sur
    sha256 "6037d2404387e19dea95837cec3ac12883e073033bcdad792d9e9556e72864fb" => :catalina
    sha256 "a2c78dcbcd336c13c8a2e5dd224d44e924187abc6062b99ac0ff02d0084593ad" => :mojave
  end

  depends_on "go" => :build
  depends_on "zstd" => :build

  def install
    goredo_prefix = "goredo-#{version}"
    system "tar", "--use-compress-program", "unzstd", "-xvf", "#{goredo_prefix}.tar.zst"
    cd "#{goredo_prefix}/src" do
      system "go", "build", *std_go_args, "-mod=vendor"
    end
    cd bin do
      system "./goredo", "-symlinks"
    end
  end

  test do
    (testpath/"gore.do").write <<~EOS
      echo YOU ARE LIKELY TO BE EATEN BY A GRUE >&2
    EOS
    assert_equal "YOU ARE LIKELY TO BE EATEN BY A GRUE\n", shell_output("#{bin}/redo -no-progress gore 2>&1")
  end
end
