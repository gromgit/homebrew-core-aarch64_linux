class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.135.0.tar.gz"
  sha256 "67a29297059ade81398ed73b5315a6e7a3c021c292c11c5c689733334a54f579"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e177fd3b78aebf1dadcc7efd4fe3eadf9ab383dde41dfe3a8ba63803ffaf8dbc" => :catalina
    sha256 "db4b378cae2ab2bf5ecbade9dd9a1205829e74daefce922a7694c5e734dee892" => :mojave
    sha256 "58d04c305431a1448c18fc3d3954c2988849ce224cdc0e76e332d027369b8533" => :high_sierra
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
