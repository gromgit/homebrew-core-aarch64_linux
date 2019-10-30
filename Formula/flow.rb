class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.111.0.tar.gz"
  sha256 "8f7133468c23d58a51cba4236f7cfb87d5dc73822c303510842045aa6d951dcf"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "36c276bbec899229ab1761f77cf2fdf558cfb630ea8f2f23ceae3d89b613a65b" => :catalina
    sha256 "281ecd8425632b3d2e78ffd013c52b07a4ab32e5c92b6557548ae1ee1e845c99" => :mojave
    sha256 "44130b86c4366a10dc304b40905ce91d2a43c2ac822a89b238c14cc3fee057e6" => :high_sierra
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
