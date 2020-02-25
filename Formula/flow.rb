class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.119.1.tar.gz"
  sha256 "884f6a283b189da89a71550e897458439da2d5254395ac965dfe1773b72da869"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "853cb868c082fb3955134a0274965a6a9d265ed1a930f3ca057ef282a07d7990" => :catalina
    sha256 "8edd971d6859ac16d746731472e7a796fdcb3d7c9f87a37b9be190b368f6fc09" => :mojave
    sha256 "50373a9c9b395f5dafc147bf00efd599a3772d57d8b7b1080652ba32db637673" => :high_sierra
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
