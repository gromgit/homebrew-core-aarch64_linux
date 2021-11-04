class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.31.tar.gz"
  sha256 "49dac8254cbd08eb29bc6667947a3cccbb22115a01ef029757f72ead1c6300f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "de5d79dca8f5eb818ed32d241ce9c38bf0296289b788e0d43f92175968d27bf6"
    sha256 cellar: :any_skip_relocation, big_sur:       "6e7975f2485da4d93753126587298da4faba662436f228e62326dfee31320210"
    sha256 cellar: :any_skip_relocation, catalina:      "4c485529643a75cb7f28a9ef6e1274defb4a1794a234edec56d918921f5a9cbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "449bc48da4a2dcdac2ff30b68afbc56a16c47ce7d0f558ee2ce3eb191226067e"
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
