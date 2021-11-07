class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.31.1.tar.gz"
  sha256 "b16d18bb15e30e25882da8cf3c1706919bc7953ea0da319f32ee503721ca88c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3c8814a7cd9d2b6f33bc164fc0db2355af4e45570176d1e87d0deeebd70eb41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97ce917aede94c81ad902efd6d3e38b91c5e64351d9996345a7a16f1ee43744a"
    sha256 cellar: :any_skip_relocation, monterey:       "4e343af83b032da1a828c454c1624c9f4d8fecb2c1fa699e4a8e19048e3768e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "731e5240007306b37e1d73d35779168e28599e55e8adc64ea2e9102a7e15505b"
    sha256 cellar: :any_skip_relocation, catalina:       "95d991cf1f14be2533fd3085640f8b35c5fea110ad9e74e365c8db99e0d09fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e37fcd18d87645db3d2c4ddd475749019c1e7b010dfdd93884dc2c266b12d622"
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
