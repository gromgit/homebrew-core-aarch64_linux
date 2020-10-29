class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.137.0.tar.gz"
  sha256 "a6f13b7a2fb53fb00a1d7378bd40d3d11031f561c47b82414f4ccf51916a5380"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d84598b58fee0688b772b381abd0ebb64e266d1217c279d6bb36f447ba5fd9ae" => :catalina
    sha256 "e9a2a2e17aad2aee2491421b3839a58783b871be11d93eba1c55a44bb417792f" => :mojave
    sha256 "2ec5d46cc98b1b5d01933a0f91636d105093d44edf37db9c8a598fc1f9a9d4db" => :high_sierra
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
