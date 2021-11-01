class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.34.0.tar.gz"
  sha256 "abc9716c43d742f21e13600c84527a58ac0ea34f8eedb25b8bfc36215b85e3b3"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6c33ea5a7b0805d904d6e9ef6685241c65fc8cd2a270e6eb8cf0a7dd7817203e"
    sha256 cellar: :any_skip_relocation, big_sur:       "37f10c5123a63a75428cfa1f51fb562f2759fa8f524777cb05a013110c30e943"
    sha256 cellar: :any_skip_relocation, catalina:      "2fba8bde97d0b20df9dbc7c86428dbec96f7ab13fd0622624cae5b87c7bae054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cad14d24cd671b0b58b9280789fa83a9db6532a160b492c0ad263f39c207cfc5"
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
