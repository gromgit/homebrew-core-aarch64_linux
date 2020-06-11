class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/2.6.0/dune-2.6.0.tbz"
  sha256 "12c9d849fbc5f202f99e9f8ed13fdff7de85ae9c5206cb1b821763dcd1916fc3"
  head "https://github.com/ocaml/dune.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3925b22f4991e9fb8e13829ab177b67d47fd7f83855008897bbde3b136525a0b" => :catalina
    sha256 "9004fbf716ba62b978342e9a658138a380244e67efb6f1d527e4adfd5ff0998a" => :mojave
    sha256 "d53326785711c403eaa8e734edea397b888a12025386dc512f894850624e4397" => :high_sierra
  end

  depends_on "ocaml" => [:build, :test]

  def install
    system "ocaml", "configure.ml"
    system "ocaml", "bootstrap.ml"
    system "./dune.exe", "build", "-p", "dune", "--profile", "dune-bootstrap"
    bin.install "_build/default/bin/dune.exe"
    mv bin/"dune.exe", bin/"dune"
  end

  test do
    contents = "bar"
    target_fname = "foo.txt"
    (testpath/"dune").write("(rule (with-stdout-to #{target_fname} (echo #{contents})))")
    system bin/"dune", "build", "foo.txt", "--root", "."
    output = File.read(testpath/"_build/default/#{target_fname}")
    assert_match contents, output
  end
end
