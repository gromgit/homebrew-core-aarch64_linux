class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.127.0.tar.gz"
  sha256 "fd0320896fdd2e39135638b4b307ab754ac665c0fe1592cf5e700b47e859b99f"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9be5e6872cf9e785a2eccae42e900eee2e08100003127d6a0b25b9f70951c44b" => :catalina
    sha256 "f862a67fb5b231ab3edeb6c98cc7553ee8ca718b02cc3d69894d52b7fcfadfd2" => :mojave
    sha256 "27cda4c8a071a9bf2d36200686698558e5b6cec3cc48e737cf69649af48b814f" => :high_sierra
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
