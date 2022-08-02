class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.34.0.tar.gz"
  sha256 "7d305b88dd2aae866851301ee0a0db7f4ea37688ff09b77ec2a748240d5c92b9"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7514efa3d44112eca29a2598bcad65b2b1cc92d29c3a0696a931c07da3e2c8fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e947836ca75be558fb47a0a7af637d11b5d530f9457ba10b4a37b4eb0f87aa29"
    sha256 cellar: :any_skip_relocation, monterey:       "5f4043c48b4f0066b6ecb994ee16e35a565df8c48f49e024bc24e85a7a8898bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "0733f757c09688cf159d937802f87be8a7c32cdc34c7ab02b521ab095e095386"
    sha256 cellar: :any_skip_relocation, catalina:       "88cb84e8e80ef4ee580601d99d326c6c443f037807d523304a1991866783ada6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "373070d282696d815fd24e79239820074494de2009f94d0f31b20ff32adff804"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/open-policy-agent/conftest/internal/commands.version=#{version}")

    bash_output = Utils.safe_popen_read(bin/"conftest", "completion", "bash")
    (bash_completion/"conftest").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"conftest", "completion", "zsh")
    (zsh_completion/"_conftest").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"conftest", "completion", "fish")
    (fish_completion/"conftest.fish").write fish_output
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system "#{bin}/conftest", "verify", "-p", "test.rego"
  end
end
