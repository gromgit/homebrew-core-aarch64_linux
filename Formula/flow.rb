class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.116.1.tar.gz"
  sha256 "ab994cd6d5dab9e45d722607dea099269e87b1119f159d6eeb4bdb3340c41a5a"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ef6a2eccda6f742fd6bbc7cb21883eaa1b84f506b16a62e26dc8c9b67e875c4" => :catalina
    sha256 "0aee01fb7932c74220dd94e6f0f103ef54a35180417090a9482e14a4baffd1f4" => :mojave
    sha256 "966ca0033a355e79242ee52593115d3e7eb7a845b258465e730f5c5056ff18ad" => :high_sierra
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
