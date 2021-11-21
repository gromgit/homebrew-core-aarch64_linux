class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.23.1",
    revision: "aa566440bcd0aaae05e43f664fcb164b3c92686c"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7add2035a9fc9172fe1fbd004cebedf926a51d9c6ddcf67414e2fcb77a363c73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04afa7d582253ea3581bdfdb97de47bb1809014202c0191193bbd8301e878a19"
    sha256 cellar: :any_skip_relocation, monterey:       "665047f371735a847372c9480d91ed9d1af9c3a179a8e429f3c39055cddd9853"
    sha256 cellar: :any_skip_relocation, big_sur:        "680a00c50a93ea426cb4215dfbc1f6b0e51303ccf6419a29ae6d82e09c8a33d8"
    sha256 cellar: :any_skip_relocation, catalina:       "cb9ee2d9dc56035652898ab6db6ab3ef54e09292d428c7f5fcfc21160be5dba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de949b8daafa23e7353dd2b6b3c2665d977af68b34447891bd8f743bcf57d812"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/tilt"
    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/tilt", "completion", "bash")
    (bash_completion/"tilt").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/tilt", "completion", "zsh")
    (zsh_completion/"_tilt").write output

    # Install fish completion
    output = Utils.safe_popen_read("#{bin}/tilt", "completion", "fish")
    (fish_completion/"tilt.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end
