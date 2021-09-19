class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.9.2.tar.gz"
  sha256 "6feee1db48d9296580fdfe715e43c57c080dda49bb5f52a8c8dddcc02a170e57"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "c1144679c3679ec53326540f72cc8e669ed3429c983cd903ce321f0f7f81faf4"
    sha256 big_sur:       "ba646f48f54c9adac837a1b01444d61a3a6e47e12826c5f4ce87fa4d979dbcc8"
    sha256 catalina:      "3e5ac85be9536a5727afa116003b1eea1b9e5a8b32257105e351e43844889c2a"
    sha256 mojave:        "7f7fea0a55e5a02131aaf68cd52ad619945b3bcee41add1ecd7c09e8977364fb"
    sha256 x86_64_linux:  "c20da23078d1fd0d6636cdbf15d71347b75042055dc03854804254a6a16b6b8b"
  end

  depends_on "readline"

  conflicts_with "omake", because: "both install 'osh' binaries"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make"
    system "./install"
  end

  test do
    system "#{bin}/osh", "-c", "shopt -q parse_backticks"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system "#{bin}/oil", "-c", "shopt -q parse_equals"
    assert_equal "bar", shell_output("#{bin}/oil -c 'var foo = \"bar\"; write $foo'").strip
  end
end
