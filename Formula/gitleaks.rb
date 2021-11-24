class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.0.2.tar.gz"
  sha256 "db80329125656dc1c5f733a298c6c8132b81c678662ce89337782e5bb6b57457"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc5348e7b667d59cd867faa7e0101f285dc9095071f69c491b442e3f080be008"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c105428ab5f5dfd0ef62ca6692936f840aaf12834920014107124f6dd1655b9"
    sha256 cellar: :any_skip_relocation, monterey:       "643c1a33f0d1ef41fcaf2d8278a58aeab63de3bbf13eb0cc0dac58b21aaf554a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1a2a8b926ad270961ec24e3fd9f77f92e98ad22b21f8d30f56f55e25126a32e"
    sha256 cellar: :any_skip_relocation, catalina:       "849aa5efb4d73f4374c15f67b5b38f6822aa908ea0c8aecf1e0f43f8a656dc48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c7f05fa5dc3fca14c3cf01c000888e454123afa6c20aa87e970e21b8292560a"
  end

  depends_on "go" => :build

  uses_from_macos "git"

  def install
    ldflags = "-X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"README").write "ghp_deadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
    system "git", "init"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match(/WRN\S* leaks found: [1-9]/, shell_output("#{bin}/gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}/gitleaks version").strip
  end
end
