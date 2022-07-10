class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.33.1.tar.gz"
  sha256 "1afa5a95fe37209ac8b5447b0c7001e996371f2965769aec88096aea0075ae6f"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8624b41c4041110b63235ec2d6ebaf666699ae466745ed19d467fa9bcd85935e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36306c36fc840f8c297399b26490c44d5c8bb8e8ef8fcd757c89e02624ddce01"
    sha256 cellar: :any_skip_relocation, monterey:       "7ba8b8869676061701d80759b5dc4d9949a71eed7cdb650348a28851b378c6c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "b19988ab8c1653e9973f3384ee613b34f19df961e6d68f3bab810661eff82933"
    sha256 cellar: :any_skip_relocation, catalina:       "8f0f5fc6da16300d687c75e62b9356fa66f26fc201fccea3a239f912619d65d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06848213916c57b88ed98e2bece659dd75596305569ac88c2a80ee5607a6afee"
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
