class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.24.4",
      revision: "5ea54e3881563fff7d223427123312e3e916ef6e"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "997f22647bd8a020c031adb2c4caff1b65981e3697571f9adc5305983bb0336e"
    sha256 cellar: :any_skip_relocation, big_sur:       "24d311946e8d7333642c0e261cdf6f59253a9738b2e363c0033f399fe2f31893"
    sha256 cellar: :any_skip_relocation, catalina:      "c54e82c272fc987294ecb71818384a03a3cdd1fe9696836699796c4c9298f41d"
    sha256 cellar: :any_skip_relocation, mojave:        "883b11293bd0453ce1d50161cf00525b84f700e32e24dc98c2d077b707c2dede"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/derailed/k9s/cmd.version=#{version}
             -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}",
             *std_go_args
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
