class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "0073a9488196abf7fcad2be00f043eeefdb7b1d7d7fc3aa71973b7b4b5d371d0"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cd217a21725c625a0be884331d25575d6bd74133c9db4cd1854d81cae949b637"
    sha256 cellar: :any_skip_relocation, big_sur:       "86c52c1845b4e7894a65f9fd85e41a7ca4d1f4ea714f8bfaaa7f875e4276f2fa"
    sha256 cellar: :any_skip_relocation, catalina:      "176687c30628ebbb76deb9702c531ed268cc5ca8ef9e880eea9051e50a075355"
    sha256 cellar: :any_skip_relocation, mojave:        "b6d26dd9eb76960b45d3d20b368cf9e1de5f8f0d98d4e739d872e10aeb9d10f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd6c52adef469e4716c37851b852b98e2bd1cd178c94bcf69cf90fb13627a624"
  end

  depends_on "go" => :build

  def install
    goldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: goldflags), "./cmd/test-reporter"
  end

  test do
    binary = bin/"buildpulse-test-reporter"
    assert_match version.to_s, shell_output("#{binary} --version")

    fake_dir = "im-not-real"
    assert_match "Received args: #{fake_dir}", shell_output("#{binary} submit #{fake_dir}", 1)
  end
end
