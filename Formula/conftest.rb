class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.31.0.tar.gz"
  sha256 "67ac9863e5e4ccae45fc039d51d20dbe7470f05ae4bd59de292f03cfe038d38c"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcc2f29f951bbaf33e6c9a72c1437383915426797e596582c2ac39e4d85ddb99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b2640fb88d891bc990aa92b1156d105003cf802b933caa71e757744679f2616"
    sha256 cellar: :any_skip_relocation, monterey:       "7cae48323d965399f2ac1f6ce59617ac145ece2547701635e837aebc877c4062"
    sha256 cellar: :any_skip_relocation, big_sur:        "09d6a02765663f1119aeb6961fb7210894411937726a915a3ce97025c283f269"
    sha256 cellar: :any_skip_relocation, catalina:       "2a5b08157abde7f74693329abbe954b9e1a60a8f45bbcb804177180fac4ff597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b82856de101c11a1f4aac2ec724775ae8c81d14ebabf4775563e2d0209aac729"
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
