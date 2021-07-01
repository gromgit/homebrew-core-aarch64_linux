class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.30.0.tar.gz"
  sha256 "be744434c2cf6fcebcb1fd9ac1f212d9d34523eaee23546b878812e3d0a06acb"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2d3ea69f34082e231dd0ab699ffd55c632727d75843878219f5e992d91091ba7"
    sha256 cellar: :any_skip_relocation, big_sur:       "143148bceb78b8574cdd4cdae88de57c05365d8c83b9aa886bf349b2524ac8a4"
    sha256 cellar: :any_skip_relocation, catalina:      "43f50bd7ddbb40c7058e2d259b98274d91ce6e9c63f874d069cd70736ebba631"
    sha256 cellar: :any_skip_relocation, mojave:        "16fdb8981fb420870a098dc89fbb591db25da24cefde5b07b6dfeea55f33a73c"
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
