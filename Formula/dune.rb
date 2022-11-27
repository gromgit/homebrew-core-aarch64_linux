class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.1.1/fiber-3.1.1.tbz"
  sha256 "02484454ab1b998840c7873509ec6b2301eb92662c132ef8f5f4f569b35a6b60"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/dune"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e929273b4799a0c1ba3bbe6a0a281e7f7f488f428127add1b07dd1ae3dd82b60"
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
