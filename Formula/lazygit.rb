class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.22.8.tar.gz"
  sha256 "1771c113b8b93db3321a90ff8270e736628a156a44bd6963200656a49ab488c1"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "822213bd28af757d3c3e1044799a886091b09f5ee471996fde5b351b26da650d" => :catalina
    sha256 "c4b995a6ef908ea184762df340ac445c20e55146be8a197e7faf7ee30fe9bd16" => :mojave
    sha256 "ead845746d1d41d5acc22d4105bc5a356df4555cbfc70f1d2561b11d7eb8eecf" => :high_sierra
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
