class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.113.0.tar.gz"
  sha256 "c3fe9e0e95b28a9d4648508999ef2d89fbf46732ec7e9484537026ff62b18b62"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bea63abf04085805ba297dc0c87c5c1321b6fefd9d0468dfcda53c33e7abefab" => :catalina
    sha256 "856d8c2cdeee600c661c3bdbe39fb595b2b5c31a009272df377c374afa738d32" => :mojave
    sha256 "85ccfb90c163c491baf7be667c776568536177f5936f118912f76367ac8053b1" => :high_sierra
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
