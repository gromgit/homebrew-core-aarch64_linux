class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.12.1",
      revision: "f90df0f5ece7c239817f51b46df5b8b63fcf1f3a"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59fa632092001241ac180e2833d3c0d3279f37d6c2763f06e7561628bf253fc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06357ee87f852752b197405dc5cd67b4daed4dff2e03324b1affb54e9308457e"
    sha256 cellar: :any_skip_relocation, monterey:       "2e6b9a63ae2569abf76d3dda62149163ce5a78b5267e3e2baa19776916e37e99"
    sha256 cellar: :any_skip_relocation, big_sur:        "83b6c18b01c55af0255db683ce68056de6aa85c1ba6a13efd2b9dd5f4e430910"
    sha256 cellar: :any_skip_relocation, catalina:       "b508d184c6d9db8854f3c34a02662bd9cf1f88ec6c6c99996c5c214ef6fb5569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f3227577f700f5472693396d270c85fae67f966cbc57eb6c77e77133a54d51c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
