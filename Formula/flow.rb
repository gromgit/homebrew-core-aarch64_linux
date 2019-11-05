class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.111.2.tar.gz"
  sha256 "3b9de62162bd015e500339f22b9c867f955a243caef9aafba63461910041fea2"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6c7f73a1a84e19a3394b75971251c9aaba2a7de8392b29fbdbe18082c09eaa7" => :catalina
    sha256 "9bdec026ca041bb6b855d7c4758d3d85929af23d763b211c2dade80dd6afb4d2" => :mojave
    sha256 "dca7922754a397e5bd307280bf73b44bc0ffccbc378c60d46814344fcc356903" => :high_sierra
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

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
