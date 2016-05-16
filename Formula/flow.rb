class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.25.0.tar.gz"
  sha256 "7144ecef267fb629051f6a941652cd6cb26793b9d91213eca0f9ef31a466cffa"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f23f7c40cf32fc7b627108ecf99081311b64ae3fcd20b0acaea7f29077df135" => :el_capitan
    sha256 "6f73be034ece45a02e20395760bbd328229da0547102ebf89ea4172851639cde" => :yosemite
    sha256 "a281a81f5712f7d91aa90c2b60a3908c1b61b2437f5f08aaa13d488fe47b3409" => :mavericks
  end

  depends_on "ocaml" => :build
  depends_on "ocamlbuild" => :build

  def install
    system "make"
    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<-EOS.undent
      /* @flow */
      var x: string = 123;
    EOS
    expected = /number\nThis type is incompatible with\n.*string\n\nFound 1 error/
    assert_match expected, shell_output("#{bin}/flow check --old-output-format #{testpath}", 2)
  end
end
