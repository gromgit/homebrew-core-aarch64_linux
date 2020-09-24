class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.11.4.tar.gz"
  sha256 "06af1e84167c381a97d42a54c1420d5033a5757c834742bdd66659054593e0eb"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d65b5f9006a160152b0f6544744c450fcb727ad864452b9c54793e720fc8baaf" => :catalina
    sha256 "5267e37f84caca5aa62d30dd488d5722cb421be8d626dd81e8f5eff150873015" => :mojave
    sha256 "1756610bb72615d4c5077ec1e798e7222fcb7c883e2a00f5abdbb3ba79eed1c9" => :high_sierra
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
