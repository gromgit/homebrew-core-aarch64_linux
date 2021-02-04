class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.144.0.tar.gz"
  sha256 "03d5ff09e9505cd05d539e64896cdc95d0e1b8c14603e47e9a8b6a5db26e075c"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "0965f426e1f5b57149862b394ff0a36fd834b4819af14683d274e983b19ddf04"
    sha256 cellar: :any_skip_relocation, catalina: "2f6ca5138d04ab505fbf6d5f8fdf1b3c93853e05c86d3ceb479727af7fed701e"
    sha256 cellar: :any_skip_relocation, mojave:   "2ab520bda78db45dd193c73f745d496fe1e8680195937238bb88c3d83a405ac3"
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
