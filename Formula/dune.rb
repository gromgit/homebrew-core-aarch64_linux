class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/2.8.1/dune-2.8.1.tbz"
  sha256 "e7b405c75af321ce6518aa8e70ebdd403dbcc2ede931713e69c2b5addda4bd44"
  license "MIT"
  head "https://github.com/ocaml/dune.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d599af2937a8e8e537ab70341958b3bc29fa9e7cf1a4a0ce6f5ce37a3d3b7ed5" => :big_sur
    sha256 "76e09af59aa100d5a7734bbc93d2a7b77928dcaa8db47c68b8b9a58caa4e03e3" => :catalina
    sha256 "7e46e43d0ea8544ffa77171924ee7d35e880d825df1ba52e5b67d53a91eaa34f" => :mojave
  end

  depends_on "ocaml" => [:build, :test]

  def install
    system "ocaml", "bootstrap.ml"
    system "./dune.exe", "build", "-p", "dune", "--profile", "dune-bootstrap"
    bin.install "_build/default/bin/dune.exe" => "dune"
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
