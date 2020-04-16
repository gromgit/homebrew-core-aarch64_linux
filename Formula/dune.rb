class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/2.5.0/dune-2.5.0.tbz"
  sha256 "9cc1661b9b173dd183867edcf8ee28a9ce79079a7d00316b719bdcba1d78d7da"
  head "https://github.com/ocaml/dune.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9e20a762026b9f3144aaa3c142e34717ba4bd965fdc15396d871c1281a7b787" => :catalina
    sha256 "be4d441437c8e0a586fbe2085d84de2e74bad886ef35a4fa60f5f1edda22b875" => :mojave
    sha256 "c366a17ed9c20893b079ba368029a2a42ce62034c5ecfe3ee26540c6b3172553" => :high_sierra
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
