class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/2.9.2/dune-site-2.9.2.tbz"
  sha256 "b8e7cc507fb978b45f6fdc839f2b3201d2c1e611e4a8e972c8c8cfd8522e7447"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a4b54dd7247b91672a1dde5eb527a51d4fc150c3fad18c25e8170501fced830"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b7d058d01e441fe189a98c6c599714df63d7e23d38d711e42f56a266390252a"
    sha256 cellar: :any_skip_relocation, monterey:       "46cf2177b00aa94c8c3226b24114c2450fc4fb76cef65f9928ade922dfe3048e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d437c08892e45e72736063ff90dbab9a98953117d43922f5005f25c03112ee3"
    sha256 cellar: :any_skip_relocation, catalina:       "8b93c7b1b8ad5053b87ed8c1dad302c8021b78e0127656f81215d03e4da2738f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e26c214bb13b411185f4c138c3023ba55e4d0b8af57f217272d5305c64934b5f"
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
