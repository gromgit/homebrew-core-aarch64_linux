class Regula < Formula
  desc "Checks infrastructure as code templates using Open Policy Agent/Rego"
  homepage "https://regula.dev/"
  url "https://github.com/fugue/regula.git",
      tag:      "v2.9.2",
      revision: "b41673e7b12a194969965c6a450b58a1bf263dca"
  license "Apache-2.0"
  head "https://github.com/fugue/regula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a65da9d28efba217367af0fad5512d01f5dfd30ce056530856a0e885dfd08e52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "821be6c1ea4c5eece8ac2af51011294ad10ade05b031be7c521a5ddd3c91780f"
    sha256 cellar: :any_skip_relocation, monterey:       "552ece789137e73648254f462332116ac28e9bdde4c9ea696e02d5ce2d283b8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fbb800846643f44e3fd045b00ef7cb10bc7eee95e34aa3e0f09a266f735369a"
    sha256 cellar: :any_skip_relocation, catalina:       "558b11b0af41180b2a57d1eefe2cdde16cbd314a2c2de374f7d93f570c05f443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "216d7abd7b19d44f4d1fd63a67af67d997dbd68e5d009cba120c33ba47e54810"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/fugue/regula/v2/pkg/version.Version=#{version}
      -X github.com/fugue/regula/v2/pkg/version.GitCommit=#{Utils.git_short_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"regula", "completion")
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
