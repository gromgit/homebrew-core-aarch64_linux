class Samurai < Formula
  desc "Ninja-compatible build tool written in C"
  homepage "https://github.com/michaelforney/samurai"
  url "https://github.com/michaelforney/samurai/releases/download/1.2/samurai-1.2.tar.gz"
  sha256 "3b8cf51548dfc49b7efe035e191ff5e1963ebc4fe8f6064a5eefc5343eaf78a5"
  license "Apache-2.0"
  head "https://github.com/michaelforney/samurai.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/samurai"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "817e1e508525a593c1675a9fbeb8f78d83960f166d38ac579897c77698994248"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"build.ninja").write <<~EOS
      rule cc
        command = #{ENV.cc} $in -o $out
      build hello: cc hello.c
    EOS
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system bin/"samu"
    assert_match "Hello, world!", shell_output("./hello")
  end
end
