class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/3.10.0.tar.gz"
  sha256 "1e09b312ba76e548bd0ad3d97711a56cc928d19dbfee7c3452345091df066c98"

  bottle do
    cellar :any_skip_relocation
    sha256 "804b8da4ed4cb0ed7e6ea12a129ef5a0d881094bd3603be59bfb4266cda74a7c" => :catalina
    sha256 "9272eb507cf4bf588988cb0c801e8e9ff364274a1d1e9b941f858b9e27bf929e" => :mojave
    sha256 "bab77b471c4dde2fc2af31c37e6118b972a4e0bb76211888a92fca2eb4e5dc15" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "bash-snippets", :because => "Both install a `cheat` executable"

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"

    bash_completion.install "scripts/cheat.bash"
    fish_completion.install "scripts/cheat.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output
  end
end
