class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.11.3.tar.gz"
  sha256 "0feb5f50be85db2f1da1f4b3c88e84bed805701bc367205216c75a21431037fa"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "730b054a56e802a9499e147ae83e452294f215484a915ee074b1d40f27e6e4a3" => :catalina
    sha256 "c6ae841973747d42f2c45193b33fc8f3627c2c23077aaf655d56799748ede8a8" => :mojave
    sha256 "c5c81b1fe8f0ec9c1013b5b6a4357529bdc54beaa71648d52f0acf89788e387e" => :high_sierra
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
