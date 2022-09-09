class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.12.1",
      revision: "0baa044bea61e7c16d56023be20ead3d9204b24a"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be7dde9f5e6deb3596277c31b5745e381fb596d31fef7265eb49459ae6f11cad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c80219b886665c0d48bcadf6ecbe9dae1ecd5623bb9eb4118e71a2b12bc9202"
    sha256 cellar: :any_skip_relocation, monterey:       "3bfd475e025c09cd3f6d33d0a823e7b50c4a480bae36c8e7159fe70f1dbb221c"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc74e05746ead48543ecfd4e7c3cb669b5e6a6abb25f61397f1047f4f89a6f08"
    sha256 cellar: :any_skip_relocation, catalina:       "b13b08105e9f0f43ea4648458d4e9c86d92c93e42d03508ef70ce6575cf644d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93729dd201a72093a1914e3bdfd27234e1d6dcf6e64802616e7356dbc9e43ad5"
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

    generate_completions_from_executable(bin/"cosign", "completion")
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}/cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_predicate testpath/"cosign.pub", :exist?

    assert_match version.to_s, shell_output(bin/"cosign version 2>&1")
  end
end
