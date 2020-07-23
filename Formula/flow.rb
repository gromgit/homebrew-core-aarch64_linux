class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.130.0.tar.gz"
  sha256 "db3e0fdc2d9b2f7ee27b7e5d8bb8d18800f08c97c763637cf1d117ca56e5f43c"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "98bbb2ac2679935055b30340ac4b741377ac4a44e49ae309722ec14568ac212b" => :catalina
    sha256 "5d7fd22ddcb1b9c682a96ab83834f83d5bc9c7fb78ead449271ebcdac28f2745" => :mojave
    sha256 "7beb91973d8f667f6f0cc0eb399f6c685cfc083514a9eb781b814628c259b210" => :high_sierra
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  on_linux do
    depends_on "elfutils"
  end

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
