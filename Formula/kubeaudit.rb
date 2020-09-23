class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.11.3.tar.gz"
  sha256 "0feb5f50be85db2f1da1f4b3c88e84bed805701bc367205216c75a21431037fa"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a85ad800af6a035a4e2638f53ae8b40514a40070f68f5e75fe3ce617dcb81632" => :catalina
    sha256 "33a12e5c2abc59ffbf7f1c47b552c388a7a9922b9c3f5922c95af83fbdf3b705" => :mojave
    sha256 "e7b3dc1fec29a2ec4850122fa9a639bd7a359469eb65c6a6e6cc7d8768ac7c50" => :high_sierra
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
