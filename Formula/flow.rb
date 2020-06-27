class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.128.0.tar.gz"
  sha256 "91a6c83840ce7daa36d1c67272c5526b7118ce24ae106a4fb93e692f0f58f530"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0463affda726349a5daa1dbd342bcb88d87314d371d287f0e5541903b782253" => :catalina
    sha256 "bc888a8f604a720fc8b881994d852b00e899635b1c7948df7a852ca238510f43" => :mojave
    sha256 "0d1663371403fe7a9bc39b991a8b99ac4119f9273359117b9d9c01159ac9bbbe" => :high_sierra
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
