class Regula < Formula
  desc "Checks infrastructure as code templates using Open Policy Agent/Rego"
  homepage "https://regula.dev/"
  url "https://github.com/fugue/regula.git",
      tag:      "v2.8.1",
      revision: "7edd0138d9bc7fb6684366f082954381df99c210"
  license "Apache-2.0"
  head "https://github.com/fugue/regula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9af40c1786bbfae634cf09ced957b83aa877c8baf8a5789e89986f148fecfc6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68d7a808b2527f2f3534d7356e20d00e71c1c0e265205d4122f4465814409057"
    sha256 cellar: :any_skip_relocation, monterey:       "3d4cefab85be6651c89829749d257f2a00e1d65853e02f651fbdba53ea8bb9e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "260502c3d98f3fdca43005b39ef209595a4ca51bad1a1d02c0bb69ce60f22d64"
    sha256 cellar: :any_skip_relocation, catalina:       "9606e8be8a007b4f2d7d1af1df00c9ae9688958679b32f987bfa1e27f8e0612e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9aeeb3da1a70c5a2e9245836b34027c82c87890027ceab6d1db910fc48f2c6b6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/fugue/regula/v2/pkg/version.Version=#{version}
      -X github.com/fugue/regula/v2/pkg/version.GitCommit=#{Utils.git_short_head}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_output = Utils.safe_popen_read(bin/"regula", "completion", "bash")
    (bash_completion/"regula").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"regula", "completion", "zsh")
    (zsh_completion/"_regula").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"regula", "completion", "fish")
    (fish_completion/"regula.fish").write fish_output
  end

  test do
    (testpath/"infra/test.tf").write <<~EOS
      resource "aws_s3_bucket" "foo-bucket" {
        region        = "us-east-1"
        bucket        = "test"
        acl           = "public-read"
        force_destroy = true

        versioning {
          enabled = true
        }
      }
    EOS

    assert_match "Found 10 problems", shell_output(bin/"regula run infra", 1)

    assert_match version.to_s, shell_output(bin/"regula version")
  end
end
