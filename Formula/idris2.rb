class Idris2 < Formula
  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris2/archive/v0.5.0.tar.gz"
  sha256 "bfb09e9e71c787f38390343786b6d223524c427fd7c017af7d08605c0d30c2dd"
  license "BSD-3-Clause"
  head "https://github.com/idris-lang/Idris2.git"

  bottle do
    sha256 cellar: :any,                 big_sur:      "d0af462a62b3d927f3b6a607620cf4d72296e5b12a30648902050868d94f5c46"
    sha256 cellar: :any,                 catalina:     "b0c3d608d96ad251fa22c99ba66f1f6d71693bfec1714ae815b70b1f85738722"
    sha256 cellar: :any,                 mojave:       "e4528db611ce511cb6e356fd50304692f6aa963f2edbdfd4e5f2ce5e09193540"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "94984a08ef2ab835bc084fca9f4d6298552d37af531a5943e6b1d8fa981ec24f"
  end

  depends_on "coreutils" => :build
  depends_on "gmp" => :build
  depends_on "chezscheme"
  uses_from_macos "zsh" => :build, since: :mojave

  def install
    ENV.deparallelize
    scheme = Formula["chezscheme"].bin/"chez"
    system "make", "bootstrap", "SCHEME=#{scheme}", "PREFIX=#{libexec}"
    system "make", "install", "PREFIX=#{libexec}"
    bin.install_symlink libexec/"bin/idris2"
    lib.install_symlink Dir["#{libexec}/lib/#{shared_library("*")}"]
    (bash_completion/"idris2").write Utils.safe_popen_read(bin/"idris2", "--bash-completion-script", "idris2")
  end

  test do
    (testpath/"hello.idr").write <<~EOS
      module Main
      main : IO ()
      main =
        let myBigNumber = (the Integer 18446744073709551615 + 1) in
        putStrLn $ "Hello, Homebrew! This is a big number: " ++ ( show $ myBigNumber )
    EOS

    system bin/"idris2", "hello.idr", "-o", "hello"
    assert_equal "Hello, Homebrew! This is a big number: 18446744073709551616",
                 shell_output("./build/exec/hello").chomp
  end
end
