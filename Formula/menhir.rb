class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20200612/menhir-20200612.tar.bz2"
  sha256 "37a40ff261973cb1403ac3b16254cd2424e39e4e9f9bb4b6feb12b27aa6f29a2"

  bottle do
    cellar :any
    sha256 "8d28d09c890a44e5676d25e21f6cf876e2267b0d57271c34269014e99a5c5227" => :catalina
    sha256 "3418112b611f115c6797057b989db2d3bce5405a84f74fb4a98e7bdc24f0cde9" => :mojave
    sha256 "a87fd77f2f18284feac646558505cc8134189103972901a6b3e35b7970dd7717" => :high_sierra
  end

  depends_on "dune" => :build
  depends_on "ocamlbuild" => :build
  depends_on "ocaml"

  def install
    system "dune", "build", "@install"
    system "dune", "install", "--prefix=#{prefix}", "--mandir=#{man}"
  end

  test do
    (testpath/"test.mly").write <<~EOS
      %token PLUS TIMES EOF
      %left PLUS
      %left TIMES
      %token<int> INT
      %start<int> prog
      %%

      prog: x=exp EOF { x }

      exp: x = INT { x }
      |    lhs = exp; op = op; rhs = exp  { op lhs rhs }

      %inline op: PLUS { fun x y -> x + y }
                | TIMES { fun x y -> x * y }
    EOS

    system "#{bin}/menhir", "--dump", "--explain", "--infer", "test.mly"
    assert_predicate testpath/"test.ml", :exist?
    assert_predicate testpath/"test.mli", :exist?
  end
end
