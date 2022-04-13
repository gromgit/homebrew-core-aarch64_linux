class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.7.2",
      revision: "1b1bca3280994eebe38d35e03bbd66af6214f0f1"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0a70fa7db9ec2eedb8caa5d9b06bb892b99653c73478c67546c2bc8df374de5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc9b8afe6852c52bd99c329897e2ee5e521f582ce4e4492bd37ddc4073fa2acb"
    sha256 cellar: :any_skip_relocation, monterey:       "14ad27344c6d95aaeb3f1199423a457a57213919ff2df4d644a74aa6e9ba3ee8"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6d724ee1a746770451f0b6694916d4c46c0e1b123d67c64b1c8054b0730e486"
    sha256 cellar: :any_skip_relocation, catalina:       "2ce0377fd2d5f71db9156deeb3ed57bc943536eede7b10a22eca1cc2b039dd15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c6c510464e28fa35ed6fede2dce4ec71fe9028d5d70e4672019ffb3fcab0cca"
  end

  depends_on "go" => :build

  def install
    pkg = "sigs.k8s.io/release-utils/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.gitVersion=#{version}
      -X #{pkg}.gitCommit=#{Utils.git_head}
      -X #{pkg}.gitTreeState="clean"
      -X #{pkg}.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cosign"
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}/cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_predicate testpath/"cosign.pub", :exist?

    assert_match version.to_s, shell_output(bin/"cosign version 2>&1")
  end
end
