class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.13.3.tar.gz"
  sha256 "53441cede140f3c543e6fd30de6ad8b5bbd9547e38cffd9892e31db6aa188f40"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6d2fcef40688f70e4e4a0f959efccbe9fcbfddc2a524efb3cf29b68135635397"
    sha256 cellar: :any_skip_relocation, big_sur:       "3076e38532ffdcfe76ef3c738bd16a2b03860bcc066ad057f8096d5f7fd62ed3"
    sha256 cellar: :any_skip_relocation, catalina:      "d57324fdca5a343a40769d8554439e16f84cc4df4c378f280ced507e73b6c3ef"
    sha256 cellar: :any_skip_relocation, mojave:        "6ce496aaa5c5d0749ec8d2c46d1536489f0513373a8394300b1830aced2120a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4bcbdfc7b6d76a45cb088394ebdc2b2e09a0961f4085db22fff5f5bf5aaae67"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    touch "test.rb"
    assert_match "Failed to load your local Kubeconfig",
      shell_output("echo | #{bin}/okteto init --overwrite --file test.yml 2>&1")
  end
end
