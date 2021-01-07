class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.142.0.tar.gz"
  sha256 "c58c32deeeab454f5d56a98269d668237c68010da18d686f40a5b1e1b1d9acfb"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6b89007f7a05ad563a6967d854776b5a6f873e666acc60fd9d4e87b0d3e5d1c" => :big_sur
    sha256 "2d960358af60b4493caa870910d8b0eed787c6d83b7fc1a9f821683f025c63bd" => :catalina
    sha256 "9b47420f10e3dad07fbc7b32f827dd07c229e64d7eaa12a812a322d0c5bc526c" => :mojave
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
