class Mlkit < Formula
  desc "Compiler for the Standard ML programming language"
  homepage "https://melsman.github.io/mlkit"
  url "https://github.com/melsman/mlkit/archive/mlkit-4.4.3.tar.gz"
  sha256 "51ee5ced1dc639f2c58556dca0dec5c3243dba4705e1cdb91247fa9644b16625"
  license "GPL-2.0"
  head "https://github.com/melsman/mlkit.git"

  bottle do
    rebuild 1
    sha256 big_sur:  "40b6dcb141c3c8d77df6e0e269f29f8b738353b9c21201c4bad83b7ae66f460c"
    sha256 catalina: "e4d43996ae80f20aa5792b23cf1e01e8f8bf12828c3e8a1b3c698c001f52f8b2"
    sha256 mojave:   "b650ddc8a5b9448fa159e053a8daf246e404f7ac817eff8e8195036e13e1bb75"
  end

  depends_on "autoconf" => :build
  depends_on "mlton" => :build
  depends_on "gmp"

  def install
    system "sh", "./autobuild"
    system "./configure", "--prefix=#{prefix}"

    # The ENV.permit_arch_flags specification is needed on 64-bit
    # machines because the mlkit compiler generates 32-bit machine
    # code whereas the mlton compiler generates 64-bit machine
    # code. Because of this difference, the ENV.m64 and ENV.m32 flags
    # are not sufficient for the formula as clang is used by both
    # tools in a single makefile target. For the mlton-compilation of
    # sml-code, no arch flags are used for the clang assembler
    # invocation. Thus, on a 32-bit machine, both the mlton-compiled
    # binary (the mlkit compiler) and the 32-bit native code generated
    # by the mlkit compiler will be running 32-bit code.
    ENV.permit_arch_flags
    system "make", "mlkit"
    system "make", "mlkit_libs"
    system "make", "install"
  end

  test do
    (testpath/"test.sml").write <<~EOS
      fun f(x) = x + 2
      val a = [1,2,3,10]
      val b = List.foldl (op +) 0 (List.map f a)
      val res = if b = 24 then "OK" else "ERR"
      val () = print ("Result: " ^ res ^ "\\n")
    EOS
    system "#{bin}/mlkit", "-o", "test", "test.sml"
    assert_equal "Result: OK\n", shell_output("./test")
  end
end
