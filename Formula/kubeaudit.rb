class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.11.6.tar.gz"
  sha256 "12d948da1789087286219b40e439f9688ed37918150e78381b2e1d820512b036"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd4c15b14c888f0ba52bc8f9f26b12ce073c990641dd10d7c899349a5b5d5c98" => :big_sur
    sha256 "394668c7ec1a212bf48765d5b4a434189968d493c23a8c04254b65b6058749cd" => :catalina
    sha256 "c6d2fdb6945d9b6ed28d7e3a81fb2f3bc6c1f80243e6578b15cf169aea25dec3" => :mojave
    sha256 "0c9ab243680baa0926eb9c3d3e554730e436907f8fa2c457c6f8abca055a48e3" => :high_sierra
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
