class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.25.2",
      revision: "81823ae167ae8b8d7219971e3fa87fccf7c8f6c3"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ae5497e3e52a112763709a0e320579c6ce3a7b6f93d84d7f99b8bdc2463c84a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4007050781241c27e3ae766add158a613bcc55289ffdf3a766a6a4ca9c72de84"
    sha256 cellar: :any_skip_relocation, monterey:       "275580890f11141d3e09ec57b6a5dc18ac78ecad00fa815f44bcd88483e8cceb"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a02efc26575d6ad4bdf0b35c2f8c0418be91668dcaf150d27c7d9eabc3f7fde"
    sha256 cellar: :any_skip_relocation, catalina:       "96e21870cb32df52eb68fe2dc614aaba5a04cded15824dbaec05d7310841baae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "722d5e837c0b5dd4ffdf03014397a87a8dddcadd461ac5b1ea46be981304f72b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/derailed/k9s/cmd.version=#{version}
             -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}",
             *std_go_args

    bash_output = Utils.safe_popen_read(bin/"k9s", "completion", "bash")
    (bash_completion/"k9s").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"k9s", "completion", "zsh")
    (zsh_completion/"_k9s").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"k9s", "completion", "fish")
    (fish_completion/"k9s.fish").write fish_output
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
