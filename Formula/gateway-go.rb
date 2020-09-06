class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go.git",
      tag:      "v0.1.91",
      revision: "8df96b8ae676344c14277c61ee8ac8bb206d8ef9"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "209b362a3764ac90193afad85d0c43e645519de66144bacd3d92cb210a4e657e" => :catalina
    sha256 "5e05a10e0237c9b4e55e3ada3327d2eba6aa3c326654f008d63fc5a52189d86e" => :mojave
    sha256 "df5f2343742a4fc07ac616f7b50c9b2768f705826ab5a944eef4bd295f225d1e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gateway-go -v 2>&1")
    assert_match "config created", shell_output("#{bin}/gateway-go init --config=gateway.yml 2>&1")
    assert_predicate testpath/"gateway.yml", :exist?
  end
end
