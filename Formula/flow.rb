class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.142.0.tar.gz"
  sha256 "c58c32deeeab454f5d56a98269d668237c68010da18d686f40a5b1e1b1d9acfb"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "972d2d72805838e317029ead7d3f91b950a1016bd5d47c9bed93f7302b74a6f8" => :big_sur
    sha256 "5bc3b2df39c56538bdbdbf8793c6c6d994e0a6d9c9b88a9779f1f875247e89bf" => :catalina
    sha256 "3ec8c858dcf424ef827f5bc210cda9a0bd9b4a1f374ea36a2eba7f65ddd41213" => :mojave
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

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
