class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/archive/V8.11.1.tar.gz"
  sha256 "994c9f5e0b1493c1682946f6154ef8853c9ddeb614902a7fa8403a3650d5377a"
  head "https://github.com/coq/coq.git"

  bottle do
    sha256 "eb9ac2272a0eba9bcf3334e311c09e5d55b844fe8599f52cd624769d4b883017" => :catalina
    sha256 "d6cef670b28d6969ea2ba1515e0e066069ab994ce53911d36e288f233b29ae54" => :mojave
    sha256 "3e72f1e82e7a271ab962c275434810d27b67404881ef870933a962d6252fa4ed" => :high_sierra
  end

  depends_on "ocaml-findlib" => :build
  depends_on "ocaml"
  depends_on "ocaml-num"

  def install
    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-coqdocdir", "#{pkgshare}/latex",
                          "-coqide", "no",
                          "-with-doc", "no"
    system "make", "world"
    ENV.deparallelize { system "make", "install" }
  end

  test do
    (testpath/"testing.v").write <<~EOS
      Require Coq.omega.Omega.
      Require Coq.ZArith.ZArith.

      Inductive nat : Set :=
      | O : nat
      | S : nat -> nat.
      Fixpoint add (n m: nat) : nat :=
        match n with
        | O => m
        | S n' => S (add n' m)
        end.
      Lemma add_O_r : forall (n: nat), add n O = n.
      Proof.
      intros n; induction n; simpl; auto; rewrite IHn; auto.
      Qed.

      Import Coq.omega.Omega.
      Import Coq.ZArith.ZArith.
      Open Scope Z.
      Lemma add_O_r_Z : forall (n: Z), n + 0 = n.
      Proof.
      intros; omega.
      Qed.
    EOS
    system("#{bin}/coqc", "#{testpath}/testing.v")
  end
end
