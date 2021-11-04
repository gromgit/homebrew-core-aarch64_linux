class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.34.1.tar.gz"
  sha256 "2c720732a0569122719fc653956b66f9af300a4d745bc4f56ee2c1c27a3d569b"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e0f7aeefe77ca279a3889310f1db6fe41f52f7cc60147b73100d1cee2c1cd493"
    sha256 cellar: :any_skip_relocation, big_sur:       "c3e19b054c7fcf2b58fda02d70e83441f6cb04f49efe69af8850e37ed4798d9d"
    sha256 cellar: :any_skip_relocation, catalina:      "105310c71ca8aa6e627bca35dd62bf1b334f5df16b306e1bc225d919b04dccb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e07be7ab423c31f3d00745e3b97cea7a40e7974de28a4d36db4a0ec33e9ee96"
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
