class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.117.1.tar.gz"
  sha256 "fefa18ec3949e5907a45b7147253c06cf813a4e46434cfb1cb0baed562c4a161"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "462c169b7c71d1dd2e7b77326e02a5afe179257f768604aec039b65189fdf28b" => :catalina
    sha256 "2cd54458468890b8ba7999f12814732bd08d5ab174c12865f18dcac68fdee0c6" => :mojave
    sha256 "bcd29c63faf777949fe9479cea6c3ebcaa7b8d1c2d472e887982aff4ce1e9b38" => :high_sierra
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
