class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.3.0.tar.gz"
  sha256 "6d63ce17341cd7d49a802f0d934f30d0a3fb8b0bbbc4c6a5668aa2df563bed58"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "336cd18c3acdc4c7f544dd175be198424d0500864a1f60ed49910ab2d0323206" => :big_sur
    sha256 "cd518abec7d1aaa19503e6905193cf6dbc4610179201d5c7a9e8b59a95b603bc" => :catalina
    sha256 "8a2539b7a0c52566ab67edce670cd9d421f0d75a925ee331cffa92a180844bfa" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/cloudskiff/driftctl/build.env=release
             -X github.com/cloudskiff/driftctl/pkg/version.version=v#{version}",
             *std_go_args
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/driftctl version")
    assert_match "Invalid AWS Region", shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 1)
  end
end
