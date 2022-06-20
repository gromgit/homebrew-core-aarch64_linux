class LpSolve < Formula
  desc "Mixed integer linear programming solver"
  homepage "https://sourceforge.net/projects/lpsolve/"
  url "https://downloads.sourceforge.net/lpsolve/lp_solve_5.5.2.11_source.tar.gz"
  sha256 "6d4abff5cc6aaa933ae8e6c17a226df0fc0b671c438f69715d41d09fe81f902f"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/lp_solve"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "3cc3dde62116cbf08aacbc6cfe43f3e41cc3dcc25541469ffe15ebead9d1bd0b"
  end

  def install
    subdir = if OS.mac?
      target = ".osx"
      "osx64"
    else
      "ux64"
    end

    cd "lpsolve55" do
      system "sh", "ccc#{target}"
      lib.install "bin/#{subdir}/liblpsolve55.a"
      lib.install "bin/#{subdir}/#{shared_library("liblpsolve55")}"
    end

    cd "lp_solve" do
      system "sh", "ccc#{target}"
      bin.install "bin/#{subdir}/lp_solve"
    end

    include.install Dir["*.h"], Dir["shared/*.h"], Dir["bfp/bfp_LUSOL/LUSOL/lusol*.h"]
  end

  test do
    (testpath/"test.lp").write <<~EOS
      max: 143 x + 60 y;

      120 x + 210 y <= 15000;
      110 x + 30 y <= 4000;
      x + y <= 75;
    EOS
    output = shell_output("#{bin}/lp_solve test.lp")
    assert_match "Value of objective function: 6315.6250", output
    assert_match(/x\s+21\.875/, output)
    assert_match(/y\s+53\.125/, output)
  end
end
