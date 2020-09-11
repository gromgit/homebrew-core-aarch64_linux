class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.11.2.tar.gz"
  sha256 "2cf042904b3cd49692c4332110e914809d5c6d3558152fe342eae47569247b98"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fa32081649a395cef2cbbcb7a8ae31efc3a62b4b14718d3edfa1d7a024a7d8d" => :catalina
    sha256 "8e2312cddcb81a64953b8007e1d72ae95541822c78d84f0c79163e91bc641bde" => :mojave
    sha256 "39fc802a440c2903ed1fbcaa8bc147eb5b277276a3243b5cf292668deb8ee337" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Shopify/kubeaudit/cmd.Version=#{version}
      -X github.com/Shopify/kubeaudit/cmd.BuildDate=#{Date.today}
    ]

    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args, "./cmd"
  end

  test do
    output = shell_output(bin/"kubeaudit -c /some-file-that-does-not-exist all 2>&1", 1).chomp
    assert_match "failed to open kubeconfig file /some-file-that-does-not-exist", output
  end
end
