class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.122.0.tar.gz"
  sha256 "edb3bd70a5adba1938c68df6a7d1f35a5fdfb8d8f9d09fd682f89faec4ad356a"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "78c95dbc2339a9c6d2316663b108f95047d8d70dcbb98a2fcbe54527b538ad40" => :catalina
    sha256 "72a44011a3a61c90acd8ebbe4ccfdf369806a11b72a81c05107df3a25db39771" => :mojave
    sha256 "4083423e04a40605ffa59b56085da3f8efaabe7deaf0f6ac9ea69345d65d7c2c" => :high_sierra
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
