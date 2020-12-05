class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/v2.3.0.tar.gz"
  sha256 "ea7ae310282c922772a46a9a85e2b4213043283038b74d012047b5294687d168"
  license "MIT"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "00cfdeb5892e2834b144a6e4c816a50d594440882327e65a771f9e72cd13f82d" => :catalina
    sha256 "4b0bb8f5e2385b99318cc85ff38496e87814d5658f5dd4054fdc7d2a0a8ebc07" => :mojave
    sha256 "4b64f7c46ab2fdfb997ca918c81e0d423609f565bdd405eaa9a2d7e848295ab7" => :high_sierra
  end

  depends_on "mono-libgdiplus" => :build
  depends_on "nuget" => :build
  depends_on "mono"

  resource "boogie" do
    url "https://github.com/boogie-org/boogie.git",
        revision: "9e74c3271f430adb958908400c6f6fce5b59000a"
  end

  # Use the following along with the z3 build below, as long as dafny
  # cannot build with latest z3 (https://github.com/dafny-lang/dafny/issues/810)
  resource "z3" do
    url "https://github.com/Z3Prover/z3/archive/z3-4.8.4.tar.gz"
    sha256 "5a18fe616c2a30b56e5b2f5b9f03f405cdf2435711517ff70b076a01396ef601"
  end

  def install
    (buildpath/"../boogie").install resource("boogie")
    cd buildpath/"../boogie" do
      system "nuget", "restore", "Source/Boogie.sln"
      system "msbuild", "Source/Boogie.sln"
    end
    system "msbuild", "Source/Dafny.sln"

    libexec.install Dir["Binaries/*"]

    dst_z3_bin = libexec/"z3/bin"
    dst_z3_bin.mkpath

    resource("z3").stage do
      system "./configure"
      system "make", "-C", "build"
      mv("build/z3", dst_z3_bin/"z3")
    end

    (bin/"dafny").write <<~EOS
      #!/bin/bash
      mono #{libexec}/dafny.exe "$@"
    EOS
  end

  test do
    (testpath/"test.dfy").write <<~EOS
      method Main() {
        var i: nat;
        assert i as int >= -1;
        print "hello, Dafny\\n";
      }
    EOS
    assert_equal "\nDafny program verifier finished with 1 verified, 0 errors\n",
                  shell_output("#{bin}/dafny /nologo /compile:0 #{testpath}/test.dfy")
    assert_equal "\nDafny program verifier finished with 1 verified, 0 errors\nRunning...\n\nhello, Dafny\n",
                  shell_output("#{bin}/dafny /nologo /compile:3 #{testpath}/test.dfy")
    assert_equal "Z3 version 4.8.4 - 64 bit\n",
                 shell_output("#{libexec}/z3/bin/z3 -version")
  end
end
