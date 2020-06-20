class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20200619/menhir-20200619.tar.bz2"
  sha256 "742fd861ad3e87d3268c70ebd4528e0a3be79afb4e847cd6cf6c699f2b8906e0"

  bottle do
    cellar :any
    sha256 "b1ef8ebaff344d301a6275be8a18cf47a82853ffe66176a4a850e80f7deed5a1" => :catalina
    sha256 "5aabb2c25bd2a026081c201a2d53b38accdc0b9c6552ee14b74aacfa26d763ea" => :mojave
    sha256 "27b3b48a3299528e13a280df8b0531d7bad3c36bebe3ffdfb15367ad2bd81305" => :high_sierra
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
