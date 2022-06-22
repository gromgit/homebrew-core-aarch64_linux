class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/v3.7.1.tar.gz"
  sha256 "6d77fca0875bdac4ef9167b1fd72bb9de02fc60bc01be3d8243d224709e50ec5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "060faf0802086ee192f8b37d871a2febfa57e1a2a1e2dbe4fbd26572d8deaef2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c88b516d752dfe3b2701f94d967fe467a9135332dfebc9149ca6da8aa6405fa"
    sha256 cellar: :any_skip_relocation, monterey:       "4b8177ae0ccaa626e7f922870f537ec49ce095158dbeff2fbe305bfda37c58e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3387d9d093421af5189097ca22015389418661e07f563e8bf593bc9e5c767f9"
    sha256 cellar: :any_skip_relocation, catalina:       "8c29f1b8684747037284fb1ad30cad61e87d95d0ecd07a65032e9858140f512b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32ed0b3612597a3e62bbfde539d6f851ed36269e89f785a0c91075b3edfaf02d"
  end

  depends_on "gradle" => :build
  depends_on "python@3.10" => :build # for z3
  depends_on "dotnet"
  depends_on "openjdk@11"

  # Use the following along with the z3 build below, as long as dafny
  # cannot build with latest z3 (https://github.com/dafny-lang/dafny/issues/810)
  resource "z3" do
    url "https://github.com/Z3Prover/z3/archive/Z3-4.8.5.tar.gz"
    sha256 "4e8e232887ddfa643adb6a30dcd3743cb2fa6591735fbd302b49f7028cdc0363"
  end

  def install
    system "make", "exe"

    libexec.install Dir["Binaries/*", "Scripts/quicktest.sh"]

    dst_z3_bin = libexec/"z3/bin"
    dst_z3_bin.mkpath

    resource("z3").stage do
      ENV["PYTHON"] = which("python3")
      system "./configure"
      system "make", "-C", "build"
      mv("build/z3", dst_z3_bin/"z3")
    end

    (bin/"dafny").write <<~EOS
      #!/bin/bash
      dotnet #{libexec}/Dafny.dll "$@"
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
                  shell_output("#{bin}/dafny /compile:0 #{testpath}/test.dfy")
    assert_equal "\nDafny program verifier finished with 1 verified, 0 errors\nRunning...\n\nhello, Dafny\n",
                  shell_output("#{bin}/dafny /compile:3 #{testpath}/test.dfy")
    assert_equal "Z3 version 4.8.5 - 64 bit\n",
                 shell_output("#{libexec}/z3/bin/z3 -version")
  end
end
