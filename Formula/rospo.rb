require "language/node"

class Rospo < Formula
  desc "🐸 Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "757d196bec665e68fedbe9b61ef2022f39bebc58cf20166418303837e0f45551"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "066fdcc114912b39154648543f094d1986a48201723ef5a74977672ba3d32304"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bb0c5154ee5a58bf157a4e77db24481c146744da8582a7ce46c2bffe97dcbcf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4154b7c201fc4fd918699ee1c6b503383ea76263869e377976b1f60c5efc03c6"
    sha256 cellar: :any_skip_relocation, monterey:       "37912d30d64d25b750e6538e307f22c90b263f9680df6648337a5f1e7b53a9f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f4ba0676ea61b26cc34aca44abd939b87cc77818b28c47037b0e6559dafa15c"
    sha256 cellar: :any_skip_relocation, catalina:       "dcc71e0a9bdda3add8c1c46d0adb2f364fd43c9f94c64a85d3a7f490170408eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bb0b72e3d8e6c65f3221be110fd66650bd116a35f46d1a0d43576b8ef04423d"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    chdir "pkg/web/ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/ferama/rospo/cmd.Version=#{version}'")

    generate_completions_from_executable(bin/"rospo", "completion")
  end

  test do
    system "rospo", "-v"
    system "rospo", "keygen", "-s"
    assert_predicate testpath/"identity", :exist?
    assert_predicate testpath/"identity.pub", :exist?
  end
end
