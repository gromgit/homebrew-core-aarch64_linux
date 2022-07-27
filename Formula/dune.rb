class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.4.1/dune-3.4.1.tbz"
  sha256 "299fa33cffc108cc26ff59d5fc9d09f6cb0ab3ac280bf23a0114cfdc0b40c6c5"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f1711a1db262e1f99d4d47afb998fd1cf595eaeda8d926e8031cf870b1705f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f63ec53d768154ff1b39a198e309cab1bf28ef550a7ab02a3b3fab98745103f"
    sha256 cellar: :any_skip_relocation, monterey:       "d7499cc506bd3b4398816a52fb4aeee5968841ef6f92288bf8a33a5298bdddee"
    sha256 cellar: :any_skip_relocation, big_sur:        "87217b56ce84732e9461f6fc83013ca99f32fe6ecd42fa3a3f1706eea91ffd8c"
    sha256 cellar: :any_skip_relocation, catalina:       "55560751bf4b7da58fbe1f5b9bf339d6cfe6cff2ef6e559b048e333d9711b210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29c63dcb5dbb75abf0e9a2ab210659c9582df14df0c31878d4134d18d657038c"
  end

  depends_on "ocaml" => [:build, :test]

  def install
    system "make", "release"
    system "make", "PREFIX=#{prefix}", "install"
    share.install prefix/"man"
    elisp.install Dir[share/"emacs/site-lisp/*"]
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
