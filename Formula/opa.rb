class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.23.0.tar.gz"
  sha256 "b7e1ffc8927e41e5bfbc16081245b6e27ed6afa1b22f3a7792a4732d040db235"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "721f45af256355dd43763ebafd0c48622fc9ea8a9340421560e70b8d0ef0eea0" => :catalina
    sha256 "9f4fe641b53e03ae843a475d390179cacd250a93c79b3a70cb6653c8e96bc7e4" => :mojave
    sha256 "38d738f67fa3ae1e87ace32366990fc5c43d43688404a6e040b0c1f263d7f7ef" => :high_sierra
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
