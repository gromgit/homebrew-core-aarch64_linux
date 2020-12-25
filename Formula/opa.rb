class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.25.2.tar.gz"
  sha256 "014e7828b0530a18e23f6ff883502ae67070440707cb9c8bd9c0adf6d354caa2"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "534ee9b3f0f351da7a3f43666b0c020d2e499c7bf831de6381e0668f39b7bbd3" => :big_sur
    sha256 "42c1a3792eff3e5612a88be6f80b4a7d9ee6f441064ee3247df8bce58786cc22" => :arm64_big_sur
    sha256 "9ff5370ed969a140bfbba7a6d0ddf48c130f3a630a6ab90cfe41fb78844711ba" => :catalina
    sha256 "e23755f822f539989b592337f8807da97f0db336e8588d4317ceaa236a6dcb56" => :mojave
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
