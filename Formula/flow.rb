class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.117.0.tar.gz"
  sha256 "e08fa0ca9633f29e17a9a811f905a60f75d7d60a3d3fe6ba510a9a78edac8877"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2e7b22c1292be745e0421527f5040a7b4f837551c405a3c98338ac6ee469dea" => :catalina
    sha256 "70c383cec8dddc6dc9e8b8119e66c5abc1b49223f0e8a7c941569953214a0c11" => :mojave
    sha256 "409ff90d6103b2eb21730c1ac1cefa743551208719493cccb149221c320fbc86" => :high_sierra
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
