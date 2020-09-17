class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.22.7.tar.gz"
  sha256 "712228f82e4e80f72f4437037c3dbfbf1d83a4f1ee7b8205f741175c4d00c60a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "75ef8bf077707223b213d1701e35b03cfa65adc7f62ac384af3d2ad73f803bd0" => :catalina
    sha256 "6354cf064d2245d9e14b12e283ece05e1e48e70ba8599b19c2635823ed7c1a7e" => :mojave
    sha256 "6092293f7fe0fe84759fb83049032a023ff12ca5fe17b2d4a9eb27707c7e8f16" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazygit",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  # lazygit is a terminal GUI, but it can be run in 'client mode' for example to write to git's todo file
  test do
    (testpath/"git-rebase-todo").write ""
    ENV["LAZYGIT_CLIENT_COMMAND"] = "INTERACTIVE_REBASE"
    ENV["LAZYGIT_REBASE_TODO"] = "foo"
    system "#{bin}/lazygit", "git-rebase-todo"
    assert_match "foo", (testpath/"git-rebase-todo").read
  end
end
