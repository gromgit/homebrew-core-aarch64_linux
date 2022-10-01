class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.29.4",
      revision: "bf05ae5c02fcbcc57986f2cd77b8527bf93e72a8"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e1ceb20678227873ff04fb77b3a54fb06ffaf78c2eaf6e7125b799f25ebd9c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4773d916294ed2c1c32d4e3fa016cac868750ec961b9944e47e66cec3f5c48d9"
    sha256 cellar: :any_skip_relocation, monterey:       "e32dae1c5380895e888f7625beadc05cd0df7069c603d0393095ea33b2cf686e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8cfde1173c437206df2453df9fd4ce059ad8a4ff73d7994b9d76837914658b2"
    sha256 cellar: :any_skip_relocation, catalina:       "0b8b8b925d68b2ca7ae861f96040c956e5b45ba34e7630ffcccdba66e68f5cb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f38a13e8e3c128afdeeca1790e8a297c5628bfb7fc2cbc624f1503229ef463f5"
  end

  depends_on "go" => :build

  def install
    project = "github.com/hashicorp/consul-template"
    ldflags = %W[
      -s -w
      -X #{project}/version.Name=consul-template
      -X #{project}/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    prefix.install_metafiles
  end

  test do
    (testpath/"template").write <<~EOS
      {{"homebrew" | toTitle}}
    EOS
    system bin/"consul-template", "-once", "-template", "template:test-result"
    assert_equal "Homebrew", (testpath/"test-result").read.chomp
  end
end
