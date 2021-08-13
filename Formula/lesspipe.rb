class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/1.88.tar.gz"
  sha256 "442a178f40e0261144f03f1a31048e00d09c8d0fbd7107d99d183b54f10c7ac3"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d64f78aa39d7efe3b82a8ed8d73dab156d835471d9a828231e5543ef6b2ee63c"
    sha256 cellar: :any_skip_relocation, big_sur:       "d64f78aa39d7efe3b82a8ed8d73dab156d835471d9a828231e5543ef6b2ee63c"
    sha256 cellar: :any_skip_relocation, catalina:      "d64f78aa39d7efe3b82a8ed8d73dab156d835471d9a828231e5543ef6b2ee63c"
    sha256 cellar: :any_skip_relocation, mojave:        "d64f78aa39d7efe3b82a8ed8d73dab156d835471d9a828231e5543ef6b2ee63c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78d4d1153a3e7ba606da746a311c539c82c64bc65bfd824a9aa4e483bd3c596a"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--yes"
    man1.mkpath
    system "make", "install"
  end

  def caveats
    <<~EOS
      Append the following to your #{shell_profile}:
      export LESSOPEN="|#{HOMEBREW_PREFIX}/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1
    EOS
  end

  test do
    touch "file1.txt"
    touch "file2.txt"
    system "tar", "-cvzf", "homebrew.tar.gz", "file1.txt", "file2.txt"

    assert_predicate testpath/"homebrew.tar.gz", :exist?
    assert_match "file2.txt", pipe_output(bin/"tarcolor", shell_output("tar -tvzf homebrew.tar.gz"))
  end
end
