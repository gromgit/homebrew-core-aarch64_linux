class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.56.6.tar.gz"
  sha256 "d2faffe1d68bcc554d201af8d763a2a820c0ed2df8a73732f5996475b94c05a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f0fc8cff890d243ffe96dafb9c8350ac05a9c80c713cedd891c655702593e85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5919e308fd5aeb067be7b2fb0a46771ed33fd56ce6db0ac700e60a1c66205e63"
    sha256 cellar: :any_skip_relocation, monterey:       "56bcfdbb2f28bff911ffb0fb89c276f95dac03a4633b2d2772ffbbafee01ecde"
    sha256 cellar: :any_skip_relocation, big_sur:        "a75a0ad308962bdcaaaa2251bdd5895ee5874db108e6a0e735610f4460e298d6"
    sha256 cellar: :any_skip_relocation, catalina:       "d5904c19f74c31c97ec52f7f6c9904c8a3494ff0d02f044ad8f9557e81e7961b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b36326db5124c524d5eb31b7587c17d94e4a854ae1868ccb3f3daa0ffebe2142"
  end

  # Segfaults on Go 1.18 - try test it again when updating this formula.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vmware-tanzu/sonobuoy/pkg/buildinfo.Version=v#{version}")
  end

  test do
    assert_match "Sonobuoy is a Kubernetes component that generates reports on cluster conformance",
      shell_output("#{bin}/sonobuoy 2>&1")
    assert_match version.to_s,
      shell_output("#{bin}/sonobuoy version 2>&1")
    assert_match "name: sonobuoy",
      shell_output("#{bin}/sonobuoy gen --kubernetes-version=v1.21 2>&1")
  end
end
