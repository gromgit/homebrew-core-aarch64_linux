class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "846ad5000e43e37c6089332f964d421a72fdded710066b58de8dcae655627749"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ee9449d8dfab23f6bdb033a5e4dfc855a1d0c8c14bee6d49e55817ca248a29f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e170b3cd7b35d5529607504cbe57226d5170dde87921fe9e4adb74c7d18ce9c"
    sha256 cellar: :any_skip_relocation, monterey:       "75b1d3c9f507dd53a36ce47426b67afcf53c8117c9f92d16c776d3c0900b05ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "51e05aa5b1b16f61e5d1be576fc2e13cfc38b0f40de503c1b62ff08e6415e23e"
    sha256 cellar: :any_skip_relocation, catalina:       "adab6a88fdb4f67f816babf9e89ce57937215c0f04d7d11bc8a3cbce924d6ebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1b1ba0f5b756d29fc5d7559d0418afdbbb1080214429f19ae73a4883f1e62b3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Shopify/kubeaudit/cmd.Version=#{version}
      -X github.com/Shopify/kubeaudit/cmd.BuildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"
  end

  test do
    output = shell_output(bin/"kubeaudit --kubeconfig /some-file-that-does-not-exist all 2>&1", 1).chomp
    assert_match "failed to open kubeconfig file /some-file-that-does-not-exist", output
  end
end
