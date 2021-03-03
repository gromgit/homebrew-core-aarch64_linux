class Smali < Formula
  desc "Assembler/disassembler for Android's Java VM implementation"
  homepage "https://github.com/JesusFreke/smali"
  url "https://github.com/JesusFreke/smali/archive/v2.5.1.tar.gz"
  sha256 "cc7e0e5e8412075ad3c2ec1b3773fa529f0480ca290742c4292ef81e8e8d6f82"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d6f9288dfc3b4e54513d0b93b7a3f2320d63240f3c376df1a8d968eae6770c8e"
    sha256 cellar: :any_skip_relocation, big_sur:       "8b49cc2d62cb4dccf995436cc465b04240a4f1dbb6bc557cb904eccd3040f2c5"
    sha256 cellar: :any_skip_relocation, catalina:      "44ec49c4790ec596a434e4e6770e2a6ac8ee605dabdea1ca10381e5e83cf1fe7"
    sha256 cellar: :any_skip_relocation, mojave:        "c43896dd00d7576c2bb4299f8e14ec99d8dab8b3138d5a5319b23c91ea216b09"
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
