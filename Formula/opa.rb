class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.29.4.tar.gz"
  sha256 "f9b1926d9149aab07b19f3f558f698c96db39216b166b7a4ca45dbf3471e2f08"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "39b6791d54f97453f0d0a43ad60ba165e3c93fa15a3a2edf21b346ded55be88b"
    sha256 cellar: :any_skip_relocation, big_sur:       "d9e35885afb90dd2de839afe9db328bc051a6a36d61f37d84b8be00a50f25dd2"
    sha256 cellar: :any_skip_relocation, catalina:      "aaf2fbe601c0e47ea5b0280316c31212ae79a33cbbce96d09f41004be75b9486"
    sha256 cellar: :any_skip_relocation, mojave:        "eeabb6bf5193eb27e81cdbf979c91f38e7a2d54494009600519515466bedab4e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args,
              "-ldflags", "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
