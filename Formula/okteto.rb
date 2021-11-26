class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.14.8.tar.gz"
  sha256 "69473bb9814e4a95d6a63065ef77025e51ef85f6324a75f133c5cb4de1c1a30a"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff643feb7ff1cfdc761b3afa7687a7a25aece5700e52529f4dec9ded1f6b6e83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "480144680010a69e6a6a8c04e885892fcf43ca4114052872deb738aa550a3ebd"
    sha256 cellar: :any_skip_relocation, monterey:       "7cfa1c4a3958f7d07b4750544516cadf993cddec3b4afd67f1b7b55dd668c38a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6c638a3e7c2314a6acaa693b64859f22fd78d98c7de035eb78f4215f2baba63"
    sha256 cellar: :any_skip_relocation, catalina:       "3f9e917e1e9c826441b23aae246ef4050f2fdfd274e0277a3d1212a842b4be6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aceed0cfcd8bbfa64b953141a03072b1071c57c1e047dcb3937ca5b6b1697c67"
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
