class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.17.4.tar.gz"
  sha256 "75b8ee9d22d7b910704a4ab7012efcc2e9c24d1ba51488ef99a236a9bcb61cad"

  bottle do
    cellar :any_skip_relocation
    sha256 "072c9454798760bf9d194c24338c3401e2b69ad0d8749076547d09838c54047d" => :catalina
    sha256 "0bd451dba8225d5dc21ea46e74565f7deaef65eb9ce4652944beeff6df8885bd" => :mojave
    sha256 "1ca06a1f378b92bda2a4bb177d6cd62e6a44e788295668fd7b6139004c38f6b0" => :high_sierra
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
