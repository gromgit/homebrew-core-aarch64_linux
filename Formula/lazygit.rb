class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.17.4.tar.gz"
  sha256 "75b8ee9d22d7b910704a4ab7012efcc2e9c24d1ba51488ef99a236a9bcb61cad"

  bottle do
    cellar :any_skip_relocation
    sha256 "96379706943713bf31101c735642eb48893a99303b7730b78b67679d4d33350f" => :catalina
    sha256 "ffacc4ff8cef108252854d6813e35cce36b71a2491401ab628190cb7ee2cfc42" => :mojave
    sha256 "a34e31dea35d79626df027a1ded13dac6c5a8355080adeb627e5e3391afe35ae" => :high_sierra
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
