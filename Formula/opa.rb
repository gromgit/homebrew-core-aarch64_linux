class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.42.2.tar.gz"
  sha256 "f96ca3c985c50c2c393d0c914a9ec22f7ed4a21f1948094b8161319ca63b1625"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b77ec905743564e2fa328f953ff5e816017d12d4106c4975713fa45a48ca2ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81b7221bbecfa3acdbf0350212f13a27a0373f82b00df0f0f7308ca574483dcb"
    sha256 cellar: :any_skip_relocation, monterey:       "3880f1ac2968b52ed6680e4f27c630beab0fd977a01b93446db7ff5b8f9afe2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d05a434699ba28b2d683416475d3db81ae8b9a7d02bfafd056d4307023324523"
    sha256 cellar: :any_skip_relocation, catalina:       "ad037929681cacaddb9006c12a448a8e896f965919d72b6d9bbccd946013f4fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fb1d64d116116f49f4e73c177407da44ad58183bf1ecb627db0e1dc93ce9ae1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args,
              "-ldflags", "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    bash_output = Utils.safe_popen_read(bin/"opa", "completion", "bash")
    (bash_completion/"opa").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"opa", "completion", "zsh")
    (zsh_completion/"_opa").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"opa", "completion", "fish")
    (fish_completion/"opa.fish").write fish_output
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
