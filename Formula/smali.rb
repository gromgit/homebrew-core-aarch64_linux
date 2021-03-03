class Smali < Formula
  desc "Assembler/disassembler for Android's Java VM implementation"
  homepage "https://github.com/JesusFreke/smali"
  url "https://github.com/JesusFreke/smali/archive/v2.5.1.tar.gz"
  sha256 "cc7e0e5e8412075ad3c2ec1b3773fa529f0480ca290742c4292ef81e8e8d6f82"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "981c11bc45c80e77a6ff26c2bfc8929b777ed143643ecb532a9c6d4b8396c070"
    sha256 cellar: :any_skip_relocation, big_sur:       "98ab2cc87f4b5e204eb3fa61348c9eed09a446b0b78b97b8e5aa9eb297197fe2"
    sha256 cellar: :any_skip_relocation, catalina:      "6e4881eb8ab09baa9ecb83587b17465be09e6d75a8ba26cad624078fd633f111"
    sha256 cellar: :any_skip_relocation, mojave:        "3a7ceafe3219a9de33ab07257f8214a3eab096625a937bb5c365a4485b0314e1"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "build", "--no-daemon"

    %w[smali baksmali].each do |name|
      jarfile = "#{name}-#{version}-dev-fat.jar"

      libexec.install "#{name}/build/libs/#{jarfile}"
      bin.write_jar_script libexec/jarfile, name
    end
  end

  test do
    # From examples/HelloWorld/HelloWorld.smali in Smali project repo.
    # See https://bitbucket.org/JesusFreke/smali/src/2d8cbfe6bc2d8ff2fcd7a0bf432cc808d842da4a/examples/HelloWorld/HelloWorld.smali?at=master
    (testpath/"input.smali").write <<~EOS
      .class public LHelloWorld;
      .super Ljava/lang/Object;

      .method public static main([Ljava/lang/String;)V
        .registers 2
        sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;
        const-string v1, "Hello World!"
        invoke-virtual {v0, v1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
        return-void
      .end method
    EOS

    system bin/"smali", "assemble", "-o", "classes.dex", "input.smali"
    system bin/"baksmali", "disassemble", "-o", pwd, "classes.dex"
    assert_match "Hello World!", File.read("HelloWorld.smali")
  end
end
