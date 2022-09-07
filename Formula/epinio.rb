class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "3216304faef81e7668cf55f98c39ca5aef65bc3bf7a34dc8e3a9e582ba472e49"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/epinio"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d894c9c40c922cb4befb7f11f8601b7a0c33bd2eb30f286f5d0e3293d4bf98a6"
  end

  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=#{version}")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: #{version}", output

    output = shell_output("#{bin}/epinio settings update 2>&1")
    assert_match "failed to get kube config", output
    assert_match "no configuration has been provided", output
  end
end
