class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.14.8.tar.gz"
  sha256 "69473bb9814e4a95d6a63065ef77025e51ef85f6324a75f133c5cb4de1c1a30a"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "462d322c5519a48ca40f3e6b5fc632bfe699fefe2950abde1ac97dbe8ee93e3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eec293ef4fcfbe3f64753df4e8b9645ca26aef9809b80a81329b5ebdfbe31daf"
    sha256 cellar: :any_skip_relocation, monterey:       "fdb92fb3fc1aad844bf261d1426a9e9ef2871f1b37f01d1024b1a78a5e5619d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "c06d0e21bfd59c0a603f53faa4cad4a8f78b448b05942b4c0a52fbd429969f4d"
    sha256 cellar: :any_skip_relocation, catalina:       "92a2172169c4b63af741e581ff2c1110fa840f02e9c1d2d99e479ab23e801dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c82d7b1635261dd0d8aa6af08362050614b75aa796e507b4f4a118715069429"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "No contexts are available.",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
