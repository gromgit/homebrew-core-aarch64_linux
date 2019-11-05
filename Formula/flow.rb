class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.111.3.tar.gz"
  sha256 "4781a644f7059f994d0c1f73c509e25bbc72a1d9dcbb0fbeffaeb1a1896c1b86"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "53fb70336c4b54aa6916b2e5be4e9d8f847056728ad90a6404d84b624caca689" => :catalina
    sha256 "d5e01809de741d6288da58a79c78dd55205fda756a1f9286d15e697cda605284" => :mojave
    sha256 "2ec1dcc52576a78c48427933206f525be92e17c575104bb0952f6960c3fb0784" => :high_sierra
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
