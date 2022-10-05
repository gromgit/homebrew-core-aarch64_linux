class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.29.5",
      revision: "f07ce88535e6314e09784e021a29697f97d9edad"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a48da2a728be32abcbbb1ab31604080dcd90c4bcc03c63fdb0841aaa47bbfadb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5dd8a3d2d92cd26a6adf2750ea9248598a42d815fc41980848e62521e53faa6"
    sha256 cellar: :any_skip_relocation, monterey:       "c1f4d8312270538e4fdde3078363a5c9dab070722b56527c23b96964bd8e908c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bfc440e690a3ad431c582a24a1d2273150697624fa9b73c570c83a24953f35a"
    sha256 cellar: :any_skip_relocation, catalina:       "5774d0ca4c1dfee32ead5c5dc0b6f090f7a8014b99b630e4fd89e0b11a7457dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d66882462769c320e17896a73728077a8afddd8ba4066611638d39ca7c3e3fce"
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
